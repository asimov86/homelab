# Jarvis — HomeLab

Proyecto personal de infraestructura para aprender, diseñar, implementar y documentar una plataforma de servicios basada en Linux, Docker, redes, almacenamiento y virtualización.

## Objetivos

- Aprender y aplicar Docker y Docker Compose.
- Construir un HomeLab ordenado, seguro y documentado.
- Versionar la infraestructura mediante Git y GitHub.
- Implementar servicios personales mediante contenedores.
- Diseñar una arquitectura NAS para almacenamiento y respaldos.
- Operar y ampliar el laboratorio sobre Proxmox.

## Estado de la infraestructura

**Última revisión documentada:** 28 de noviembre de 2026.

| Componente | Estado |
|---|---|
| Proxmox VE | Operativo, con las VM 100 y 101 conectadas a `vmbr0` |
| VM 100 · Jarvis | Debian 13.8, 4 GiB de RAM, SSH y Docker Compose |
| Red local | Omada ER605 con DHCP para `192.168.10.0/24` |
| DNS y HTTPS interno | AdGuard Home, Nginx Proxy Manager y PKI interna para los servicios web publicados |
| VM 101 · TrueNAS | TrueNAS 25.10.8, 8 GiB de RAM, SMB y pool ZFS `datos` sobre un HDD de 8 TB sin redundancia |
| Respaldos de Jarvis | Envío cifrado y firmado a Windows y repositorio Restic. Primer envío de las 20:00 e importación a Restic verificados el 26 de noviembre |
| Snapshots de TrueNAS | Tres tareas diarias a las 02:00, con 14 días de retención. Primera ejecución pendiente de comprobar |
| Wi‑Fi de la LAN | Omada EAP620 HD operativo en Standalone. Carga SMB desde Android probada. Certificado y programación pendientes |

## Servicios Docker

Servicios de Jarvis (VM 100):

| Servicio | Función |
|---|---|
| Portainer | Administración de contenedores Docker |
| Uptime Kuma | Monitoreo de disponibilidad |
| Homepage | Dashboard del HomeLab |
| Dozzle | Visualización de logs |
| Vaultwarden | Gestión de credenciales |
| Nginx Proxy Manager | Reverse proxy |
| AdGuard Home | DNS y filtrado de consultas |
| PiGallery2 | Galería piloto que lee fotos de TrueNAS por SMB |

## Arquitectura actual

```text
Internet / router ISP
        |
   Omada ER605 ─── PC Windows (cliente SMB y repositorio Restic)
        |
  Proxmox VE · vmbr0
        ├── VM 100 Jarvis · 192.168.10.24 · DNS, HTTPS y aplicaciones Docker
        └── VM 101 TrueNAS · 192.168.10.101 · SMB y almacenamiento ZFS
```

Los clientes resuelven los dominios internos `*.jarvis.local` mediante AdGuard. Nginx Proxy Manager dirige el tráfico HTTPS hacia las aplicaciones web. Los clientes SMB se conectan directamente a TrueNAS.

- [Red y acceso a los servicios](docs/network/README.md)
- [Respaldos y verificación](backups/README.md)
- [Hoja de ruta](docs/roadmap.md)

## Estructura del repositorio

```text
homelab/
├── docs/          # Arquitectura, estándares y decisiones
├── docker/        # Definiciones y configuraciones de servicios
├── scripts/       # Scripts de administración
├── diagrams/      # Diagramas de infraestructura
├── backups/       # Estructura de documentación de respaldos
├── README.md
└── CHANGELOG.md
```

La estructura representa la organización prevista del repositorio y no garantiza que todos los directorios existan actualmente.

## Metodología

Jarvis sigue un proceso incremental:

**Diseñar → Implementar → Probar → Documentar → Cerrar**

Los cambios de infraestructura deben contar con documentación, validaciones y criterios de finalización.
