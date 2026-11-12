# Jarvis — Baseline pre-Proxmox (versión publicable)

**Corte de información:** 08/11/2026. **Estado:** inventario documentado; no es monitoreo en tiempo real. **Migración:** no ejecutada.

## Plataforma confirmada

- Equipo físico: MSI MPG B550 Gaming Plus, Ryzen 7 5700, 16 GiB DDR4.
- Sistema operativo: Debian 12 (Bookworm), Docker Engine y Docker Compose.
- Almacenamiento: Debian instalado en HDD SATA de 250 GB; Kingston KC3000 NVMe de 2 TB identificado y comprobado, reservado para una posible instalación de Proxmox.
- Red: router Omada ER605, DNS local con AdGuard Home y red compartida Docker `jarvis_network`.
- Acceso: SSH configurado; repositorio Git de infraestructura.

## Servicios observados

| Servicio | Función | Estado al 08/11/2026 |
|---|---|---|
| AdGuard Home | DNS LAN | En ejecución |
| Nginx Proxy Manager | Reverse proxy | En ejecución |
| Portainer | Administración Docker | En ejecución |
| Uptime Kuma | Monitoreo | En ejecución |
| Homepage | Panel de servicios | En ejecución |
| Dozzle | Logs | En ejecución |
| Vaultwarden | Gestión de credenciales | En ejecución |

Se observaron siete contenedores con política de reinicio `unless-stopped` y contador de reinicios cero en esa inspección; esto no garantiza disponibilidad histórica ni futura.

## Persistencia y seguridad

- Siete volúmenes Docker nombrados y una configuración Homepage montada desde el árbol del repositorio.
- PKI interna con CA raíz y certificado de Vaultwarden; distribución de confianza a clientes pendiente de verificar.
- HTTPS aplicado de manera parcial. No interpretar los principios de seguridad como capacidades completamente desplegadas.
- Los datos persistentes pueden contener credenciales; no subir bases SQLite, volúmenes, archivos `.key`, copias de seguridad ni configuraciones con secretos.
- Algunos servicios montan el socket Docker; revisar su exposición y permisos en una mejora posterior.

## Arquitectura objetivo (NO implementada)

- Instalar Proxmox VE en el NVMe, **sin sobrescribir el HDD Debian original**.
- Ejecutar Docker dentro de una VM Debian, no directamente en el host Proxmox.
- Diseñar IP, puente de red, almacenamiento y recursos de VM antes de instalar.
- Evitar que la resolución DNS del hipervisor dependa exclusivamente de un contenedor alojado en la VM.

## Bloqueantes previos a migración

- [ ] Respaldo externo cifrado y copia verificada fuera del servidor (JAR-29).
- [ ] Restauración aislada comprobada, incluidos datos persistentes y PKI (JAR-29).
- [ ] Diseño final de almacenamiento, red y VM aprobado (JAR-31).
- [ ] Procedimiento de rollback documentado y medios de acceso disponibles.

## Trazabilidad

Esta versión omite deliberadamente IPs, rutas sensibles, certificados, resultados operativos detallados y datos de recuperación. Las evidencias completas permanecen en almacenamiento privado. Ver también `ADR-003-container-communication.md` y la documentación de seguridad del proyecto.
