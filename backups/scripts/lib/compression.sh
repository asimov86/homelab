#!/usr/bin/env bash

# Jarvis Backup Standard (JBS)
# Compression library
# Version: 1.0

compress_directory() {
  local source_dir="$1"
  local output_file="$2"

  if [[ ! -d "$source_dir" ]]; then
    log_error "El directorio origen no existe: $source_dir"
    return 1
  fi

  mkdir -p "$(dirname "$output_file")"

  log_info "Comprimiendo $source_dir en $output_file"

  tar \
    --use-compress-program='zstd -T0 -10' \
    -cf "$output_file" \
    -C "$(dirname "$source_dir")" \
    "$(basename "$source_dir")"

  log_info "Compresión finalizada: $output_file"
}

test_compressed_archive() {
  local archive_file="$1"

  if [[ ! -f "$archive_file" ]]; then
    log_error "El archivo no existe: $archive_file"
    return 1
  fi

  log_info "Validando integridad zstd: $archive_file"

  zstd --test "$archive_file"

  log_info "Validando contenido tar: $archive_file"

  tar \
    --use-compress-program=unzstd \
    -tf "$archive_file" \
    >/dev/null

  log_info "Archivo comprimido válido: $archive_file"
}
