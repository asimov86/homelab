# Infraestructura de red

**Última revisión documentada:** 28 de noviembre de 2026.

El router del ISP da salida a Internet. El Omada ER605 administra el DHCP de la LAN `192.168.10.0/24` y conecta el host de Proxmox. Las VM llegan a la LAN por el puente `vmbr0`.

| Nodo | Función |
|---|---|
| Jarvis · VM 100 | Reserva DHCP `192.168.10.24`. AdGuard Home resuelve los nombres internos y Nginx Proxy Manager publica aplicaciones web por HTTPS. |
| TrueNAS · VM 101 | Reserva DHCP `192.168.10.101`. El alias `nas.jarvis.local` apunta al NAS. Los clientes acceden a SMB directamente. |
| PC Windows | Cliente HTTPS y SMB. Recibe los respaldos cifrados de Jarvis para importarlos a Restic. |

El Wi-Fi del router ISP está aguas arriba del ER605. El **Omada EAP620 HD** opera en Standalone en el puerto LAN 5 (VLAN 1 sin etiqueta, PVID 1). Un Android accedió a TrueNAS por IP, abrió la pantalla de PiGallery2 y envió fotos por SMB con FolderSync. La confianza HTTPS en Android, la persistencia tras resincronizar y la programación siguen pendientes. Las VLAN adicionales siguen en planificación.

[Manual para configurar cada celular Android](../runbooks/android-fotos-truenas.md)

[Registro histórico de la migración al ER605](2026-07-sprint-04-network-migration.md)
