#!/usr/bin/env bash

set -Eeuo pipefail

# Jarvis Backup Standard (JBS)
# Generic backup validator
#
# Usage:
#   ./validate-backup.sh <backup-file>
#
# Version:
#   JBS v1.0

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly JBS_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

source "${SCRIPT_DIR}/lib/logger.sh"
source "${SCRIPT_DIR}/lib/checksum.sh"
source "${SCRIPT_DIR}/lib/compression.sh"

validate_backup() {
  local backup_file="$1"
  local checksum_file="${backup_file}.sha256"

  log_info "Iniciando validación del backup: $backup_file"

  if [[ ! -f "$backup_file" ]]; then
    log_error "El backup no existe: $backup_file"
    return 1
  fi

  if [[ ! -s "$backup_file" ]]; then
    log_error "El backup está vacío: $backup_file"
    return 1
  fi

  if [[ ! -f "$checksum_file" ]]; then
    log_error "No existe el checksum asociado: $checksum_file"
    return 1
  fi

  verify_checksum "$checksum_file"
  test_compressed_archive "$backup_file"

  log_info "Backup válido: $backup_file"
}

main() {
  if (( $# != 1 )); then
    log_error "Uso: $0 <backup-file>"
    return 64
  fi

  validate_backup "$1"
}

main "$@"
