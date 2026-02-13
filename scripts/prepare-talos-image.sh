#!/usr/bin/env bash

set -euo pipefail

# --- constants ---

TALOS_VERSION="${TALOS_VERSION:-v1.12.3}"
FACTORY_URL="https://factory.talos.dev"

# --- logging ---

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >&2
}

error() {
  log "ERROR: $*"
  exit 1
}

# --- functions ---

check_dependencies() {
  local missing_deps=()

  for dep in curl jq cosign; do
    if ! command -v "$dep" > /dev/null 2>&1; then
      missing_deps+=("$dep")
    fi
  done

  if [[ ${#missing_deps[@]} -gt 0 ]]; then
    error "Missing required dependencies: ${missing_deps[*]}"
  fi
}

get_schematic_id() {
  log "Creating schematic with extensions..."

  local schematic_file="$1"

  local response
  response=$(curl -s -X POST \
    --data-binary "@$schematic_file" \
    "$FACTORY_URL/schematics")

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
  local installer_image="factory.talos.dev/installer/${schematic_id}:${version}"

  log "Verifying installer image signature: $installer_image"

  # verify installer image signature
  if ! cosign verify \
    --certificate-identity-regexp '@siderolabs\.com$' \
    --certificate-oidc-issuer https://accounts.google.com \
    "$installer_image" > /dev/null 2>&1; then
    error "Installer image signature verification failed"
  fi

  log "Signature verification: PASSED"
}

download_nocloud_iso() {
  local schematic_id="$1"
  local version="$2"
  local output_file="$3"

  local url="$FACTORY_URL/image/${schematic_id}/${version}/nocloud-amd64.iso"

  log "Downloading Talos image from factory..."
  log "URL: $url"

  if ! curl -L -o "$output_file" "$url"; then
    error "Failed to download image from factory"
  fi

  log "Downloaded: $(basename "$output_file")"
}

# --- main ---

main() {
  local version="$TALOS_VERSION"
  local schematic_file=""
  local output_dir="./output"

  while [[ $# -gt 0 ]]; do
    case $1 in
      --version)
        version="$2"
        shift 2
        ;;
      --schematic-file)
        schematic_file="$2"
        shift 2
        ;;
      --output-dir)
        output_dir="$2"
        shift 2
        ;;
      *)
        error "Unknown argument: $1"
        ;;
    esac
  done

  if [[ -z "$schematic_file" ]]; then
    error "--schematic-file is required"
  fi

  if [[ ! -f "$schematic_file" ]]; then
    error "Schematic file not found: $schematic_file"
  fi

  mkdir -p "$output_dir"

  check_dependencies

  local schematic_id
  schematic_id=$(get_schematic_id "$schematic_file")

  verify_installer_signature "$schematic_id" "$version"

  local iso_file="$output_dir/talos-${version}-nocloud-amd64.iso"
  download_nocloud_iso "$schematic_id" "$version" "$iso_file"

  log "Done."
  log "Schematic ID:     $schematic_id"
  log "Installer image:  factory.talos.dev/installer/${schematic_id}:${version}"
  log "ISO:              $iso_file"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
