# Jarvis — HomeLab

Proyecto personal de infraestructura para aprender, diseñar, implementar y documentar una plataforma de servicios basada en Linux, Docker, redes, almacenamiento y virtualización.

## Objetivos

- Aprender y aplicar Docker y Docker Compose.
- Construir un HomeLab ordenado, seguro y documentado.
- Versionar la infraestructura mediante Git y GitHub.
- Implementar servicios personales mediante contenedores.
- Diseñar una arquitectura NAS para almacenamiento y respaldos.
- Evolucionar hacia Proxmox como plataforma de virtualización.

## Estado de la infraestructura

**Última revisión documentada:** noviembre de 2026.

| Componente | Estado |
|---|---|
| Debian 12 | Implementado |
| SSH | Implementado |
| Docker Engine y Docker Compose | Implementado |
| Git y conexión SSH con GitHub | Implementado |
| Red Docker `jarvis_network` | Implementado |
| DNS interno mediante AdGuard Home | Implementado |
| Reverse proxy mediante Nginx Proxy Manager | Implementado |
| PKI interna | Parcial |
| HTTPS para todos los servicios | Parcial |
| Backups externos y restauración validada | Pendiente |
| NAS | Pendiente |
| Proxmox | Pendiente |

Los estados representan la última auditoría conocida, no una verificación en tiempo real.

## Servicios Docker

Servicios confirmados en funcionamiento durante la última auditoría:

| Servicio | Función |
|---|---|
| Portainer | Administración de contenedores Docker |
| Uptime Kuma | Monitoreo de disponibilidad |
| Homepage | Dashboard del HomeLab |
| Dozzle | Visualización de logs |
| Vaultwarden | Gestión de credenciales |
| Nginx Proxy Manager | Reverse proxy |
| AdGuard Home | DNS y filtrado de consultas |

Los servicios se ejecutan en Docker sobre Debian 12 y comparten la red `jarvis_network`.

## Arquitectura actual

```text
Clientes de la LAN
        |
        +---- DNS: AdGuard Home
        |
        +---- HTTP/HTTPS
                 |
                 v
         Nginx Proxy Manager
                 |
                 v
          jarvis_network
                 |
        +--------+--------+
        |        |        |
     Homepage  Portainer  Otros servicios
```

Los contenedores conectados a la misma red utilizan, como regla general, nombres de servicio Docker para comunicarse.

Los clientes de la LAN utilizan dominios internos `*.jarvis.local`.

Las excepciones deben justificarse y documentarse.

Consultar `docs/decisions/ADR-003-container-communication.md`.

## Próximos pasos

- Completar y validar los respaldos externos de Jarvis.
- Verificar un procedimiento de restauración.
- Finalizar el diseño de Proxmox.
- Migrar Docker a una máquina virtual Debian, preservando el disco original como alternativa de recuperación.
- Diseñar e implementar el almacenamiento NAS.
- Continuar mejorando seguridad, observabilidad y documentación.

Estas actividades son pendientes; no deben interpretarse como implementadas.

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
