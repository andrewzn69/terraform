#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TEMP_DIR="$PROJECT_ROOT"/temp
IMAGES_DIR="$PROJECT_ROOT/images"
FILES_DIR="$PROJECT_ROOT/files"

show_help() {
  cat << EOF
	Usage: $0 [OPTIONS]

	Prepare Talos image for Oracle Cloud Infrastructure

	Detects .xz or .zst files in project root and converts them to .oci format.

	OPTIONS:
		-h, --help	Show this help message
		-v, --verbose	Enable verbose output
		-c, --clean	Clean temp directory after completion

	REQUIREMENTS:
		- Compressed Talos image (.xz or .zst) in project root
		- files/image_metadata.json file
		- qemu-img, xz/zstd, tar commands

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

  if ! command -v qemu-img > /dev/null 2>&1; then
    missing_deps+=("qemu-img")
  fi

  if ! command -v tar > /dev/null 2>&1; then
    missing_deps+=("tar")
  fi

  if [[ ${#missing_deps[@]} -gt 0 ]]; then
    error "Missing required dependencies: ${missing_deps[*]}"
  fi
}

find_archive_file() {
  local archive_files=()

  while IFS= read -r -d '' file; do
    archive_files+=("$file")
  done < <(find "$PROJECT_ROOT" -maxdepth 1 \( -name "*.xz" -o -name "*.zst" \) -print0)

  if [[ ${#archive_files[@]} -eq 0 ]]; then
    error "No .xz or .zst files found in project root"
  elif [[ ${#archive_files[@]} -gt 1 ]]; then
    error "Multiple archive files found: ${archive_files[*]}. Please keep only one."
  fi

  echo "${archive_files[0]}"
}

decompress_image() {
  local archive_file="$1"
  local output_file="$2"

  log "Decompressing $(basename "$archive_file")..."

  case "$archive_file" in
    *.xz)
      if ! command -v xz > /dev/null 2>&1; then
        error "xz is required for .xz files"
      fi
      xz --decompress --stdout "$archive_file" > "$output_file"
      ;;
    *.zst)
      if ! command -v zstd > /dev/null 2>&1; then
        error "zstd is required for .zst files"
      fi
      zstd --decompress --stdout "$archive_file" > "$output_file"
      ;;
    *)
      error "Unsupported archive format: $archive_file"
      ;;
  esac
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

  (cd "$TEMP_DIR" && tar zcf "$oci_file" "$(basename "$qcow2_file")" -C "$FILES_DIR" "image_metadata.json")
}

main() {
  local verbose=false
  local clean=false

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

  local archive_file
  archive_file=$(find_archive_file)

  local metadata_file="$FILES_DIR/image_metadata.json"
  if [[ ! -f "$metadata_file" ]]; then
    error "Metadata file not found: $metadata_file"
  fi

  mkdir -p "$TEMP_DIR" "$IMAGES_DIR"

  local basename_no_ext="${archive_file##*/}"
  basename_no_ext="${basename_no_ext%.xz}"
  basename_no_ext="${basename_no_ext%.zst}"

  local raw_file="$TEMP_DIR/$basename_no_ext"
  local qcow2_file="$TEMP_DIR/${basename_no_ext%.*}.qcow2"
  local oci_file="$IMAGES_DIR/${basename_no_ext%.*}.oci"

  log "Processing: $(basename "$archive_file")"

  decompress_image "$archive_file" "$raw_file"
  convert_to_qcow2 "$raw_file" "$qcow2_file"
  create_oci_archive "$qcow2_file" "$metadata_file" "$oci_file"

  log "Successfully created: $(basename "$oci_file")"

  if [[ "$clean" == true ]]; then
    log "Cleaning temporary files..."
    rm -rf "$TEMP_DIR"
  fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
