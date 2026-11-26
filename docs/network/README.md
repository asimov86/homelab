# Infraestructura de red

**Última revisión documentada:** 26 de noviembre de 2026.

El router del ISP da salida a Internet. El Omada ER605 administra el DHCP de la LAN `192.168.10.0/24` y conecta el host de Proxmox. Las VM llegan a la LAN por el puente `vmbr0`.

| Nodo | Función |
|---|---|
| Jarvis · VM 100 | Reserva DHCP `192.168.10.24`. AdGuard Home resuelve los nombres internos y Nginx Proxy Manager publica aplicaciones web por HTTPS. |
| TrueNAS · VM 101 | Reserva DHCP `192.168.10.101`. El alias `nas.jarvis.local` apunta al NAS. Los clientes acceden a SMB directamente. |
| PC Windows | Cliente HTTPS y SMB. Recibe los respaldos cifrados de Jarvis para importarlos a Restic. |

El Wi-Fi del router ISP está en la red aguas arriba del ER605. El **Omada EAP620 HD** se conectará a un puerto LAN del ER605 para dar acceso inalámbrico a la LAN. Al instalarlo, confirmar desde un celular una dirección `192.168.10.x`, acceso HTTPS a `fotos.jarvis.local` y una subida de prueba por PhotoSync al NAS. Las VLAN siguen en planificación.

[Registro histórico de la migración al ER605](2026-07-sprint-04-network-migration.md)
