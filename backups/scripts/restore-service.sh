#!/usr/bin/env bash

set -Eeuo pipefail

# Jarvis Backup Standard (JBS)
# Generic restore engine
#
# Usage:
#   Test restore:
#     ./restore-service.sh --test <service> <backup-file>
#
#   Real restore:
#     ./restore-service.sh <service> <backup-file>
#
# Version:
#   JBS v1.0

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly JBS_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
readonly CONFIG_DIR="${JBS_ROOT}/config"

source "${SCRIPT_DIR}/lib/logger.sh"

SERVICE_WAS_STOPPED=false

load_service_config() {
  local service="$1"
  local config_file="${CONFIG_DIR}/${service}.conf"

  if [[ ! -f "$config_file" ]]; then
    log_error "No existe la configuración del servicio: $config_file"
    return 1
  fi

  # shellcheck source=/dev/null
  source "$config_file"

  local required_variables=(
    SERVICE_NAME
    CONTAINER_NAME
    VOLUME_NAME
  )

  local variable
  for variable in "${required_variables[@]}"; do
    if [[ -z "${!variable:-}" ]]; then
      log_error "Variable obligatoria ausente: $variable"
      return 1
    fi
  done
}

validate_dependencies() {
  local dependencies=(
    docker
    tar
    zstd
    sha256sum
  )

  local dependency
  for dependency in "${dependencies[@]}"; do
    if ! command -v "$dependency" >/dev/null 2>&1; then
      log_error "Dependencia no disponible: $dependency"
      return 1
    fi
  done
}

validate_backup_file() {
  local backup_file="$1"

  if [[ ! -f "$backup_file" ]]; then
    log_error "El archivo de backup no existe: $backup_file"
    return 1
  fi

  "${SCRIPT_DIR}/validate-backup.sh" "$backup_file"
}

restore_archive_to_volume() {
  local backup_file="$1"
  local target_volume="$2"

  log_info "Restaurando backup en volumen: $target_volume"

  zstd -dc -- "$backup_file" \
    | docker run \
        --rm \
        --interactive \
        --volume "${target_volume}:/restore" \
        alpine:3.22 \
        tar -C /restore -xf -

  log_info "Contenido restaurado en volumen: $target_volume"
}

verify_restored_volume() {
  local target_volume="$1"

  log_info "Inspeccionando volumen restaurado: $target_volume"

  docker run \
    --rm \
    --volume "${target_volume}:/restore:ro" \
    alpine:3.22 \
    sh -c '
      test -f /restore/db.sqlite3 &&
      test -f /restore/rsa_key.pem &&
      echo "Archivos esenciales encontrados:"
      ls -lah /restore
    '

  log_info "Validación básica del volumen restaurado finalizada"
}

test_restore() {
  local backup_file="$1"
  local test_volume="jbs_test_${SERVICE_NAME}_$(date '+%Y%m%d%H%M%S')"

  log_info "Iniciando restauración de prueba"
  log_info "Volumen temporal: $test_volume"

  docker volume create "$test_volume" >/dev/null

  if restore_archive_to_volume "$backup_file" "$test_volume" \
    && verify_restored_volume "$test_volume"; then

    log_info "Restauración de prueba completada correctamente"
  else
    log_error "La restauración de prueba falló"
    docker volume rm "$test_volume" >/dev/null 2>&1 || true
    return 1
  fi

  log_info "Eliminando volumen temporal de prueba: $test_volume"
  docker volume rm "$test_volume" >/dev/null

  log_info "Prueba de restauración finalizada sin modificar producción"
}

restart_service_if_needed() {
  if [[ "$SERVICE_WAS_STOPPED" == "true" ]]; then
    log_warn "Iniciando nuevamente el contenedor: $CONTAINER_NAME"
    docker start "$CONTAINER_NAME" >/dev/null
    SERVICE_WAS_STOPPED=false
    log_info "Contenedor iniciado: $CONTAINER_NAME"
  fi
}

real_restore() {
  local backup_file="$1"
  local safety_volume="${VOLUME_NAME}_before_restore_$(date '+%Y%m%d%H%M%S')"

  log_warn "ATENCIÓN: se realizará una restauración sobre producción"
  log_warn "Servicio: $SERVICE_NAME"
  log_warn "Volumen productivo: $VOLUME_NAME"

  if [[ "${JBS_CONFIRM_RESTORE:-}" != "YES" ]]; then
    log_error "Restauración cancelada."
    log_error "Ejecutar con JBS_CONFIRM_RESTORE=YES para confirmar."
    return 1
  fi

  docker stop "$CONTAINER_NAME" >/dev/null
  SERVICE_WAS_STOPPED=true

  log_info "Creando copia de seguridad previa en volumen: $safety_volume"
  docker volume create "$safety_volume" >/dev/null

  docker run \
    --rm \
    --volume "${VOLUME_NAME}:/source:ro" \
    --volume "${safety_volume}:/safety" \
    alpine:3.22 \
    sh -c 'cd /source && tar -cf - . | tar -C /safety -xf -'

  log_info "Limpiando volumen productivo"

  docker run \
    --rm \
    --volume "${VOLUME_NAME}:/restore" \
    alpine:3.22 \
    sh -c 'find /restore -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +'

  restore_archive_to_volume "$backup_file" "$VOLUME_NAME"
  verify_restored_volume "$VOLUME_NAME"

  restart_service_if_needed

  log_info "Restauración productiva completada"
  log_info "Volumen de contingencia conservado: $safety_volume"
}

main() {
  if (( $# == 3 )) && [[ "$1" == "--test" ]]; then
    load_service_config "$2"
    validate_dependencies
    validate_backup_file "$3"
    test_restore "$3"
    return
  fi

  if (( $# == 2 )); then
    load_service_config "$1"
    validate_dependencies
    validate_backup_file "$2"
    real_restore "$2"
    return
  fi

  log_error "Uso:"
  log_error "  $0 --test <service> <backup-file>"
  log_error "  $0 <service> <backup-file>"
  return 64
}

trap restart_service_if_needed EXIT

main "$@"
