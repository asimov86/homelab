# Jarvis — reconstrucción sobre Proxmox

**Corte del 23/11/2026.** La VM Debian está operativa y los siete servicios se reconstruyeron desde cero. El primer respaldo externo y una restauración aislada de Vaultwarden están verificados. La automatización de producción sigue pendiente.

## Cómo se creó la VM Debian en Proxmox

1. Se cargó la ISO oficial Debian 13.8 amd64 netinst y se comprobó su SHA-256. La ISO se usó para el primer arranque del instalador.
2. Se creó una VM con firmware OVMF (UEFI) y máquina q35, 4 vCPU, 6144 MiB de RAM fijos y una interfaz VirtIO conectada al puente del entorno. Se seleccionó el controlador VirtIO SCSI single.
3. Se asignaron dos discos virtuales separados. El primero, de 48 GiB, se destinó al sistema. El segundo, de 100 GiB, se reservó para datos persistentes. Durante la instalación de Debian solo se particionó el disco del sistema, con EFI, raíz ext4 y swap.
4. Se instaló Debian sin escritorio, con servidor SSH y utilidades estándar. Al primer reinicio volvió a aparecer el instalador porque la ISO tenía prioridad. Se corrigió el orden para iniciar desde el disco del sistema y se verificó el arranque de Debian.
5. Se comprobó el acceso SSH verificando la huella de la VM. También se verificó el Guest Agent desde Proxmox y se conservó un snapshot previo a Docker. La preparación del disco de datos se hizo después de identificarlo, con autorización explícita y una comprobación del montaje por UUID tras reiniciar.

Para verificar una VM equivalente, usar `qm config <VMID>`, `qm status <VMID>` y `qm guest cmd <VMID> ping` desde Proxmox. Desde Debian, verificar `hostnamectl`, `lsblk -f` y `systemctl is-active ssh qemu-guest-agent`.

## Reconstrucción verificada

| Área | Resultado |
| --- | --- |
| Base Debian | Debian 13.8, SSH y QEMU Guest Agent activos en el invitado. |
| Almacenamiento | El volumen ext4 dedicado a datos se monta por UUID. Se verificó después de reiniciar y se probó persistencia entre contenedores. |
| Docker | Engine 29.10.0 y Compose v5.8.0. Docker y containerd activos y habilitados al arranque. |
| Versiones de imágenes | Los siete servicios se descargaron y arrancaron con imágenes fijadas por digest. Quedan pendientes el cotejo histórico y la prueba de reversión de versiones. |
| Acceso | DNS interno y acceso HTTPS comprobados desde Windows. El panel de Nginx Proxy Manager se conserva como acceso de administración por túnel. |
| PKI | Se adoptó una nueva CA interna y certificados individuales. Se validaron la cadena y el acceso de cliente en Windows. La raíz cifrada tiene una copia en un segundo disco físico con SHA-256 comprobado. Quedan pendientes desbloqueo de recuperación, revocación y distribución a otros clientes. |

## Servicios

- Homepage carga la configuración versionada y presenta los enlaces HTTPS.
- Dozzle entrega eventos y logs. Se confirmó que rechaza solicitudes sin credenciales.
- Portainer autenticó al administrador y mostró el entorno Docker local.
- Uptime Kuma funciona detrás del proxy por WebSocket. Tiene seis monitores, incluidos DNS interno y enrutamiento del proxy. Hay una sonda externa desde Windows, activa mientras la PC está encendida y con sesión iniciada.
- Vaultwarden arrancó con datos nuevos, se probó el alta por invitación y el inicio de sesión. El registro público y el panel administrativo están deshabilitados.
- AdGuard Home resuelve nombres internos y públicos por UDP y TCP.
- Nginx Proxy Manager termina TLS para las aplicaciones. Se validaron seis destinos por HTTPS.

Los detalles de recuperación, red y custodia se registran en el documento operativo privado del proyecto. Se verificaron el orden de arranque y la conexión del Guest Agent desde Proxmox. El inicio automático de la VM sigue deshabilitado. El punto de retorno previo a Docker está visible en Proxmox.

## Fase H — respaldo y restauración verificados

- El primer respaldo se hizo con una pausa de los servicios que escriben datos. Incluyó seis directorios persistentes y los archivos de despliegue efectivos. Tras reanudar los servicios, DNS y HTTPS respondieron.
- El repositorio Restic externo se verificó leyendo todos los paquetes. El archivo restaurado coincidió por SHA-256 con la captura. Las bases SQLite de Vaultwarden, Uptime Kuma y Nginx Proxy Manager superaron la verificación de integridad.
- Se arrancó Vaultwarden con su base restaurada y con la imagen fijada. El laboratorio usó un contenedor en memoria, sin red ni puertos publicados. El endpoint de salud respondió HTTP 200. Quedan pendientes la prueba de inicio de sesión en esa copia y las pruebas de arranque de los demás servicios.
- Las copias SQLite de Vaultwarden, Kuma y NPM también pasaron una prueba en memoria mientras los servicios estaban en ejecución.
- Se probó una transferencia cifrada por SFTP a una bandeja aislada y el guardado posterior en Restic local. El receptor verificó la firma y ambos hashes, rechazó un manifiesto alterado y recuperó el contenido de prueba sin pedir la contraseña. El importador se probó con datos ficticios en un repositorio temporal, incluyendo un reintento sin duplicados.

## Punto de pausa

1. Incorporar la exportación nativa de Portainer y definir si el respaldo diario de AdGuard incluye el historial y las estadísticas además de la configuración y los filtros. El respaldo manual ya contiene sus directorios persistentes.
2. Probar una captura real sin detener DNS y su importación y restauración antes de programar una tarea de producción. Acordar RPO, RTO, retención y alertas según el [Jarvis Backup Standard](../../standards/JBS.md).
3. Definir el destino cifrado para el respaldo completo de la VM en vivo y probar su restauración. El snapshot del hipervisor sigue siendo un punto de retorno local.
4. Verificar la recuperación de la clave raíz desde su segunda copia y decidir cuándo habilitar el inicio automático de la VM.
5. Completar la reversión de imágenes con datos restaurados. La guía y los siete [Compose portables](https://github.com/asimov86/homelab/blob/7c2c8027dc73adab84d983e29be9846fa31b2ec7/docker/README.md) están publicados para revisión.

La recuperación del respaldo histórico queda fuera de este corte. Los scripts y valores operativos privados se mantienen fuera de GitHub.
