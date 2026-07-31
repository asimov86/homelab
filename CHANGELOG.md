# Changelog


## [1.2.0] - Julio 2026 - Network Infrastructure

### Agregado

- Incorporación del TP-Link Omada ER605 como gateway principal.
- Nueva arquitectura de red independiente del router del ISP.
- Implementación de AdGuard Home como servidor DNS interno.
- Implementación de dominios internos (*.jarvis.local).
- Incorporación de Nginx Proxy Manager como Reverse Proxy.
- Creación de la red Docker compartida `jarvis_network`.
- Documentación completa del Sprint 4.

### Mejorado

- Centralización del direccionamiento IP mediante DHCP.
- Política de publicación de puertos.
- Arquitectura preparada para HTTPS interno.

### Documentación

- Nuevo documento de migración de red.
- Registro de troubleshooting.
- Diagramas de arquitectura.
- Lecciones aprendidas.

## [1.1.0] - Julio 2026 - Foundation

### Observability

#### Agregado

- Arquitectura oficial de Observability (`observability-architecture.md`).
- Matriz de monitoreo de servicios.
- Documentación de Uptime Kuma.
- Documentación de Dozzle.
- Integración de Homepage con Docker mediante `docker.yaml`.
- Visualización del estado operativo de los contenedores desde Homepage.

#### Mejorado

- Reorganización de las categorías de Homepage.
- Integración de los servicios con Docker (`server` y `container`).
- Corrección de la configuración de widgets de Homepage.

#### Validado

- Monitoreo interno de:
  - Vaultwarden
  - Portainer
  - Homepage
  - Nginx Proxy Manager
  - Uptime Kuma

- Integración con Dozzle para visualización de logs.


## v1.0.0 - Julio 2026 - Foundation

### Added

- Debian 12 base platform
- Docker Engine & Docker Compose
- Homepage
- Portainer
- Nginx Proxy Manager
- Vaultwarden
- Internal PKI
- HTTPS
- Jarvis Deployment Standard (JDS)
- Jarvis Backup Standard (JBS)
- PKI Standard
- Security Architecture
- Automated backup framework
- Restore validation workflow
- Documentation framework
- Architecture Decision Records
- Lessons Learned

## Julio 2026

### Added

- Primer servicio desplegado: Portainer.
- Segundo servicio desplegado: Uptime Kuma.
- Se implementó el primer monitoreo interno del HomeLab.
