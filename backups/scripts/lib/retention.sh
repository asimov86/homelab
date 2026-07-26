#!/usr/bin/env bash

# Jarvis Backup Standard (JBS)
# Retention library
# Version: 1.0

apply_retention() {
  local backup_dir="$1"
  local keep_count="$2"
  local pattern="${3:-*.tar.zst}"

  if [[ ! -d "$backup_dir" ]]; then
    log_error "El directorio de retención no existe: $backup_dir"
    return 1
  fi

  if ! [[ "$keep_count" =~ ^[0-9]+$ ]]; then
    log_error "La cantidad a conservar no es válida: $keep_count"
    return 1
  fi

  log_info "Aplicando retención en $backup_dir"
  log_info "Patrón: $pattern | Conservar: $keep_count"

  mapfile -t backup_files < <(
    find "$backup_dir" \
      -maxdepth 1 \
      -type f \
      -name "$pattern" \
      -printf '%T@ %p\n' \
      | sort -nr \
      | cut -d' ' -f2-
  )

  local total="${#backup_files[@]}"

  if (( total <= keep_count )); then
    log_info "No hay archivos excedentes. Total=$total"
    return 0
  fi

  local index
  for (( index = keep_count; index < total; index++ )); do
    local backup_file="${backup_files[$index]}"
    local checksum_file="${backup_file}.sha256"

    log_warn "Eliminando backup excedente: $backup_file"
    rm -f -- "$backup_file"

    if [[ -f "$checksum_file" ]]; then
      log_warn "Eliminando checksum asociado: $checksum_file"
      rm -f -- "$checksum_file"
    fi
  done

  log_info "Retención finalizada. Conservados=$keep_count Eliminados=$((total - keep_count))"
}
