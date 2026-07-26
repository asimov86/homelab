#!/usr/bin/env bash

# Jarvis Backup Standard (JBS)
# Checksum library
# Version: 1.0

generate_checksum() {
  local file="$1"
  local checksum_file="${file}.sha256"

  if [[ ! -f "$file" ]]; then
    log_error "No se puede generar checksum. El archivo no existe: $file"
    return 1
  fi

  log_info "Generando checksum SHA-256 para: $file"

  (
    cd "$(dirname "$file")"
    sha256sum "$(basename "$file")" > "$(basename "$checksum_file")"
  )

  log_info "Checksum generado: $checksum_file"
}

verify_checksum() {
  local checksum_file="$1"

  if [[ ! -f "$checksum_file" ]]; then
    log_error "El archivo checksum no existe: $checksum_file"
    return 1
  fi

  log_info "Validando checksum: $checksum_file"

  if (
    cd "$(dirname "$checksum_file")"
    sha256sum --check "$(basename "$checksum_file")"
  ); then
    log_info "Checksum válido: $checksum_file"
    return 0
  fi

  log_error "Checksum inválido o archivo alterado: $checksum_file"
  return 1
}
