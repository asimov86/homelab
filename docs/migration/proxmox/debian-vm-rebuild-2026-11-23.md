# Jarvis — Proxmox y reconstrucción Debian VM (23/11/2026)

**Estado:** Proxmox instalado y VM Debian 13 creada. Docker y recuperación de servicios pendientes.  
**Seguimiento:** [JAR-32](https://linear.app/jarvis-homelab/issue/JAR-32/tk-0502-instalar-proxmox-en-nvme-preservando-hdd), [JAR-33](https://linear.app/jarvis-homelab/issue/JAR-33/tk-0503-crear-vm-debian-e-instalar-docker), [JAR-34](https://linear.app/jarvis-homelab/issue/JAR-34/tk-0504-restaurar-servicios-y-datos-desde-backup), [JAR-29](https://linear.app/jarvis-homelab/issue/JAR-29/tk-0404-respaldar-datos-y-validar-una-restauracion-aislada).  
**Registro operativo restringido:** [Google Drive — JAR-29](https://docs.google.com/document/d/1v3w5-dBuZbRmUnSN4thmWZ7FNlNT0CwzvS40exVq1hQ/edit). Contiene los detalles de red, identificación de equipos, acceso y custodia. **No duplicarlos en este repositorio.**

## Objetivo y decisión de migración

Se decidió una **reconstrucción limpia** de los servicios Docker usando los Compose, scripts y documentación versionados, sin convertir el backup Restic histórico en un requisito para levantar la infraestructura nueva.

- Vaultwarden: no se requiere preservar contenido de una bóveda anterior; reinstalación limpia autorizada conceptualmente, pendiente de implementación.
- Uptime Kuma: los monitores existentes de contenedores pueden recrearse; no se exige preservar historial.
- AdGuard Home, Nginx Proxy Manager y PKI: requieren especial cuidado con la resolución DNS de LAN, los proxy hosts, certificados y claves antiguas. La documentación no sustituye el material criptográfico.
- El HDD Debian histórico **se mantiene físicamente desconectado e intacto** como vía de recuperación.
- JAR-29 continúa abierto hasta validar el nuevo esquema de respaldos y una restauración real.

## Infraestructura confirmada

| Componente | Resultado verificado |
| --- | --- |
| Hipervisor | Proxmox VE 9.2.32 |
| Kernel PVE | 7.0.14-30-pve |
| Almacenamiento físico PVE | Kingston KC3000 NVMe 2 TB |
| Almacenamiento PVE | `local` y `local-lvm` activos |
| Red | Puente `vmbr0` operativo |
| VM | ID `100`, nombre `jarvis` |
| Firmware / chipset | OVMF (UEFI), q35 |
| CPU y memoria VM | 4 vCPU, 6144 MiB RAM, balloon=0 |
| Controlador | VirtIO SCSI single |
| Disco sistema | `scsi0`, 48 GiB, local-lvm |
| Disco datos | `scsi1`, 100 GiB, local-lvm, aún sin particionar |
| Imagen ISO | Debian 13.8 amd64 netinst; SHA-256 comprobado |
| SO invitado | Debian 13 instalado y shell operativa |
| Paquetes seleccionados | SSH server y utilidades estándar, sin escritorio |
| SSH | Servicio `ssh` activo en Debian |
| Red de invitado | IP temporal por DHCP; plan de dirección definitiva en registro privado |
| Guest Agent | Habilitado como opción VM; instalación y funcionamiento en Debian **no verificados** |
| Arranque automático | `onboot=0` al crear VM |
| Otras VMs | Ninguna antes de crear Jarvis |

### Instalación y almacenamiento

El instalador formateó **únicamente** el disco virtual de 48 GiB como ESP, ext4 y swap. El disco virtual de datos de 100 GiB quedó fuera de la operación. Al primer reinicio se mostró otra vez el instalador porque el orden inicial priorizaba la ISO; se indicó retirar la ISO y dar prioridad al disco, y después se verificó un shell Debian funcional. Aún falta inspeccionar la configuración final de arranque.

La creación de la VM fue verificada mediante `qm config 100` y `qm status 100` (estado inicial detenido); en el huésped se comprobó dirección DHCP y `systemctl is-active ssh` respondió `active`.

## Próxima ejecución delegable a Codex

1. **Preflight solo lectura:** confirmar el acceso SSH desde el equipo de administración, huella de clave SSH, `hostnamectl`, distribución Debian, `lsblk -f`, interfaces, rutas, configuración de arranque y estado del QEMU agent.
2. **Base Debian:** actualizar APT, instalar herramientas y `qemu-guest-agent`; verificar el servicio y si se requiere reinicio.
3. **Disco de datos:** identificar de forma inequívoca el disco virtual de 100 GiB. Diseñar partición/filesystem/montaje persistente, verificar que esté vacío y **pedir autorización antes de formatearlo**.
4. **Docker:** instalar Docker Engine y plugin Docker Compose en la VM (no en el host Proxmox); validar acceso, seguridad y redes.
5. **Código:** clonar `asimov86/homelab`, auditar Compose, rutas/hosts obsoletos y versiones de imagen flotantes antes de desplegar ([JAR-53](https://linear.app/jarvis-homelab/issue/JAR-53/fijar-versionesdigests-de-imagenes-docker-antes-de-restaurar-jarvis)).
6. **Reconstrucción gradual:** Dozzle, Homepage, Portainer; Uptime Kuma con monitores nuevos, Vaultwarden con bóveda vacía; luego AdGuard Home y NPM mediante pruebas y cambio DNS/proxy controlado.
7. **PKI y acceso:** revisar política de certificados y confianza ([JAR-56](https://linear.app/jarvis-homelab/issue/JAR-56/formalizar-confianza-de-jarvis-root-ca-y-custodia-de-claves)); no asumir recuperación de la CA privada.
8. **Pruebas y JBS:** pruebas funcionales por servicio, persistencia, DNS, HTTPS; configurar y probar nuevos respaldos y restauración; documentar resultados en fuentes apropiadas.
9. **Ambientes:** evaluar DEV/TEST efímeros cuando el baseline PROD sea estable.

## Límites de ejecución

- No formatear discos, cambiar DNS/IP/DHCP de la LAN, alterar PKI ni publicar servicios sin preflight, revisión y autorización correspondiente.
- No modificar el HDD histórico ni instalar Docker en el hipervisor.
- No publicar secretos, certificados/llaves privadas, bases de datos, rutas privadas o topología interna detallada en GitHub/Linear. Consultar el documento restringido de Drive.
- No publicar cambios de código, tickets o documentos sin aprobación cuando se trate de etapas futuras no cubiertas por la autorización actual.
- **Estado real, no supuestos:** ni Docker ni los siete servicios se han instalado todavía en la nueva VM.

## Fuentes de verdad

- **GitHub:** código, Compose, estándares, ADR, runbooks y evidencias técnicas saneadas.
- **Linear:** tareas, dependencias, estados, criterios de aceptación y progreso.
- **Drive restringido:** procedimientos operativos internos, IP, dispositivos, acceso y custodia. **Las contraseñas y claves privadas no se escriben en documentos.**

La metodología sigue: **Diseñar → Implementar → Probar → Documentar → Cerrar**.
