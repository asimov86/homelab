#!/usr/bin/env bash

# Jarvis Backup Standard (JBS)
# Logging library
# Version: 1.0

log_timestamp() {
  date '+%Y-%m-%d %H:%M:%S %z'
}

log_info() {
  printf '[%s] [INFO] %s\n' "$(log_timestamp)" "$*"
}

log_warn() {
  printf '[%s] [WARN] %s\n' "$(log_timestamp)" "$*" >&2
}

log_error() {
  printf '[%s] [ERROR] %s\n' "$(log_timestamp)" "$*" >&2
}

die() {
  log_error "$*"
  return 1
}
