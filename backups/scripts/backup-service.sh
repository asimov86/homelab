#!/usr/bin/env bash

set -Eeuo pipefail

# Jarvis Backup Standard (JBS)
# Generic backup engine
#
# Usage:
#   ./backup-service.sh <service>
#
# Example:
#   ./backup-service.sh vaultwarden
#
# Version:
#   JBS v1.0

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly JBS_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
readonly CONFIG_DIR="${JBS_ROOT}/config"

source "${SCRIPT_DIR}/lib/logger.sh"
source "${SCRIPT_DIR}/lib/checksum.sh"
source "${SCRIPT_DIR}/lib/retention.sh"

SERVICE_WAS_STOPPED=false
TEMP_BACKUP=""

restart_service_if_needed() {
  if [[ "$SERVICE_WAS_STOPPED" == "true" ]]; then
    log_warn "Intentando iniciar nuevamente el contenedor: $CONTAINER_NAME"

    if docker start "$CONTAINER_NAME" >/dev/null; then
      SERVICE_WAS_STOPPED=false
      log_info "Contenedor iniciado correctamente: $CONTAINER_NAME"
    else
      log_error "No se pudo iniciar el contenedor: $CONTAINER_NAME"
      return 1
    fi
  fi
}

cleanup() {
  local exit_code=$?

  if [[ -n "$TEMP_BACKUP" && -f "$TEMP_BACKUP" ]]; then
    log_warn "Eliminando archivo temporal incompleto: $TEMP_BACKUP"
    rm -f -- "$TEMP_BACKUP"
  fi

  restart_service_if_needed || true

  exit "$exit_code"
}

trap cleanup EXIT
trap 'exit 130' INT TERM

load_service_config() {
  local service="$1"
  local config_file="${CONFIG_DIR}/${service}.conf"

  if [[ ! -f "$config_file" ]]; then
    log_error "No existe la configuración del servicio: $config_file"
    return 1
  fi

  # La configuración es administrada y versionada dentro de Jarvis.
  # shellcheck source=/dev/null
  source "$config_file"

  local required_variables=(
    SERVICE_NAME
    CONTAINER_NAME
    VOLUME_NAME
    BACKUP_ROOT
    RETENTION_DAILY
  )

  local variable
  for variable in "${required_variables[@]}"; do
    if [[ -z "${!variable:-}" ]]; then
      log_error "Variable obligatoria ausente en $config_file: $variable"
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

validate_docker_resources() {
  if ! docker container inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
    log_error "El contenedor no existe: $CONTAINER_NAME"
    return 1
  fi

  if ! docker volume inspect "$VOLUME_NAME" >/dev/null 2>&1; then
    log_error "El volumen no existe: $VOLUME_NAME"
    return 1
  fi

  local container_status
  container_status="$(
    docker inspect \
      --format '{{.State.Status}}' \
      "$CONTAINER_NAME"
  )"

  if [[ "$container_status" != "running" ]]; then
    log_error \
      "El contenedor debe estar ejecutándose antes del backup. Estado actual: $container_status"
    return 1
  fi
}

stop_service() {
  log_warn "Deteniendo contenedor para backup consistente: $CONTAINER_NAME"

  docker stop "$CONTAINER_NAME" >/dev/null
  SERVICE_WAS_STOPPED=true

  log_info "Contenedor detenido: $CONTAINER_NAME"
}

create_volume_backup() {
  local output_file="$1"

  mkdir -p "$(dirname "$output_file")"

  log_info "Respaldando volumen Docker: $VOLUME_NAME"
  log_info "Archivo temporal: $output_file"

  docker run \
    --rm \
    --volume "${VOLUME_NAME}:/source:ro" \
    alpine:3.22 \
    tar -C /source -cf - . \
    | zstd -T0 -10 -o "$output_file"

  if [[ ! -s "$output_file" ]]; then
    log_error "El backup generado está vacío: $output_file"
    return 1
  fi

  log_info "Compresión del volumen finalizada"
}

run_backup() {
  local timestamp
  timestamp="$(date '+%Y-%m-%d-%H%M%S')"

  local daily_dir="${BACKUP_ROOT}/daily"
  local backup_name="${SERVICE_NAME}-${timestamp}.tar.zst"
  local final_backup="${daily_dir}/${backup_name}"

  TEMP_BACKUP="${final_backup}.tmp"

  log_info "Iniciando backup JBS v1.0"
  log_info "Servicio: $SERVICE_NAME"
  log_info "Contenedor: $CONTAINER_NAME"
  log_info "Volumen: $VOLUME_NAME"

  mkdir -p \
    "${BACKUP_ROOT}/daily" \
    "${BACKUP_ROOT}/weekly" \
    "${BACKUP_ROOT}/monthly"

  stop_service

  create_volume_backup "$TEMP_BACKUP"

  restart_service_if_needed

  mv -- "$TEMP_BACKUP" "$final_backup"
  TEMP_BACKUP=""

  generate_checksum "$final_backup"

  "${SCRIPT_DIR}/validate-backup.sh" "$final_backup"

  apply_retention \
    "$daily_dir" \
    "$RETENTION_DAILY" \
    "${SERVICE_NAME}-*.tar.zst"

  local backup_size
  backup_size="$(du -h "$final_backup" | awk '{print $1}')"

  log_info "Backup completado correctamente"
  log_info "Archivo: $final_backup"
  log_info "Tamaño: $backup_size"
}

main() {
  if (( $# != 1 )); then
    log_error "Uso: $0 <service>"
    return 64
  fi

  local service="$1"

  load_service_config "$service"
  validate_dependencies
  validate_docker_resources
  run_backup
}

main "$@"
