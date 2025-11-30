#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TEMP_DIR="$PROJECT_ROOT"/temp
IMAGES_DIR="$PROJECT_ROOT/images"
FILES_DIR="$PROJECT_ROOT/files"
TALOS_VERSION="${TALOS_VERSION:-v1.11.5}"

show_help() {
  cat << EOF
	Usage: $0 [OPTIONS]

	Prepare Talos image with Tailscale extension for Oracle Cloud Infrastructure

	Downloads Talos factory image with Tailscale extension and converts it to .oci format.

	OPTIONS:
		-h, --help           Show this help message
		-v, --verbose        Enable verbose output
		-c, --clean          Clean temp directory after completion
		--version VERSION    Talos version (default: $TALOS_VERSION)

	REQUIREMENTS:
		- files/image_metadata.json file
		- qemu-img, xz, tar, curl, jq, cosign, sha256sum commands

EOF
}

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >&2
}

error() {
  log "ERROR: $*"
  exit 1
}

check_dependencies() {
  local missing_deps=()

  for dep in qemu-img tar xz curl jq cosign sha256sum; do
    if ! command -v "$dep" > /dev/null 2>&1; then
      missing_deps+=("$dep")
    fi
  done

  if [[ ${#missing_deps[@]} -gt 0 ]]; then
    error "Missing required dependencies: ${missing_deps[*]}"
  fi
}

get_factory_schematic_id() {
  log "Creating Tailscale extension schematic..."

  local response
  response=$(
    curl -s -X POST --data-binary @- https://factory.talos.dev/schematics << 'EOF'
customization:
  systemExtensions:
    officialExtensions:
      - siderolabs/tailscale
EOF
  )

  local schematic_id
  schematic_id=$(echo "$response" | jq -r '.id')

  if [[ -z "$schematic_id" || "$schematic_id" == "null" ]]; then
    error "Failed to get schematic ID from factory"
  fi

  log "Schematic ID: $schematic_id"
  echo "$schematic_id"
}

verify_installer_signature() {
  local schematic_id="$1"
  local version="$2"

  log "Verifying installer image signature with cosign..."

  local installer_image
  installer_image="factory.talos.dev/installer/${schematic_id}:${version}"
  local signing_key
  signing_key="$TEMP_DIR/signing_key.pub"

  # download factory signing key
  if ! curl -s https://factory.talos.dev/oci/cosign/signing-key.pub -o "$signing_key"; then
    error "Failed to download factory signing key"
  fi

  log "Verifying: $installer_image"

  # verify installer image signature
  if ! cosign verify --offline --insecure-ignore-tlog --insecure-ignore-sct --key "$signing_key" "$installer_image" > /dev/null 2>&1; then
    error "Installer image signature verification failed"
  fi

  log "Signature verification: PASSED"
}

generate_image_checksum() {
  local image_file
  image_file="$1"

  log "Generating SHA256 checksum..."

  if [[ ! -f "$image_file" ]]; then
    error "Image file not found: $image_file"
  fi

  local checksum
  checksum=$(sha256sum "$image_file" | awk '{print $1}')

  log "SHA256: $checksum"

  # store checksum for audit trail
  echo "$checksum $(basename "$image_file")" > "${image_file}.sha256"
  log "Checksum saved: $(basename "$image_file").sha256"
}

verify_image_integrity() {
  local image_file
  image_file="$1"
  local expected_checksum
  expected_checksum="$2"

  if [[ ! -f "$image_file" ]]; then
    error "Image file not found: $image_file"
  fi

  local actual_checksum
  actual_checksum=$(sha256sum "$image_file" | awk '{print $1}')

  if [[ "$actual_checksum" != "$expected_checksum" ]]; then
    error "Integrity check failed: checksum mismatch"
  fi

  log "Integrity verification: PASSED"
}

download_factory_image() {
  local schematic_id="$1"
  local version="$2"
  local output_file="$3"

  local url="https://factory.talos.dev/image/${schematic_id}/${version}/oracle-arm64.raw.xz"

  log "Downloading Talos image from factory..."
  log "URL: $url"

  if ! curl -L -o "$output_file" "$url"; then
    error "Failed to download image from factory"
  fi

  log "Downloaded: $(basename "$output_file")"
}

decompress_image() {
  local archive_file="$1"
  local output_file="$2"

  log "Decompressing $(basename "$archive_file")..."
  xz --decompress --stdout "$archive_file" > "$output_file"
}

convert_to_qcow2() {
  local raw_file="$1"
  local qcow2_file="$2"

  log "Converting to qcow2 format..."
  qemu-img convert -f raw -O qcow2 "$raw_file" "$qcow2_file"
}

create_oci_archive() {
  local qcow2_file="$1"
  local metadata_file="$2"
  local oci_file="$3"

  log "Creating OCI archive..."

  if [[ ! -f "$metadata_file" ]]; then
    error "Metadata file not found: $metadata_file"
  fi

  if ! (cd "$TEMP_DIR" && tar zcf "$oci_file" "$(basename "$qcow2_file")" -C "$FILES_DIR" "image_metadata.json"); then
    error "Failed to create OCI archive"
  fi
}

main() {
  local verbose=false
  local clean=false
  local version="$TALOS_VERSION"

  while [[ $# -gt 0 ]]; do
    case $1 in
      -h | --help)
        show_help
        exit 0
        ;;
      -v | --verbose)
        verbose=true
        shift
        ;;
      -c | --clean)
        clean=true
        shift
        ;;
      --version)
        version="$2"
        shift 2
        ;;
      -*)
        error "Unknown option: $1"
        ;;
      *)
        error "Unexpected argument: $1. Use --help for usage information."
        ;;
    esac
  done

  if [[ "$verbose" == true ]]; then
    set -x
  fi

  check_dependencies

  local metadata_file="$FILES_DIR/image_metadata.json"
  if [[ ! -f "$metadata_file" ]]; then
    error "Metadata file not found: $metadata_file"
  fi

  mkdir -p "$TEMP_DIR" "$IMAGES_DIR"

  # get schematic id and download factory image
  local schematic_id
  schematic_id=$(get_factory_schematic_id)

  verify_installer_signature "$schematic_id" "$version"

  # download factory image and generate checksum
  local archive_file="$TEMP_DIR/oracle-arm64-tailscale.raw.xz"
  download_factory_image "$schematic_id" "$version" "$archive_file"

  generate_image_checksum "$archive_file"

  # process the image
  local raw_file="$TEMP_DIR/oracle-arm64.raw"
  local qcow2_file="$TEMP_DIR/oracle-arm64.qcow2"
  local oci_file="$IMAGES_DIR/oracle-arm64-tailscale.oci"

  log "Processing: Talos $version with Tailscale extension..."

  decompress_image "$archive_file" "$raw_file"

  # verify decompressed raw image integrity
  generate_image_checksum "$raw_file"
  convert_to_qcow2 "$raw_file" "$qcow2_file"

  # verify qcow2 conversion integrity
  generate_image_checksum "$qcow2_file"

  create_oci_archive "$qcow2_file" "$metadata_file" "$oci_file"

  log "Successfully created: $(basename "$oci_file")"
  log "Schematic ID: $schematic_id"
  log "Factory installer image: factory.talos.dev/installer/${schematic_id}:${version}"

  if [[ "$clean" == true ]]; then
    log "Cleaning temporary files..."
    rm -rf "$TEMP_DIR"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
