# Jarvis — Checklist de preparación y validación de migración

**Estado:** diagnóstico previo y diseño registrados. Instalación y corte pendientes.

## Estado del diseño previo al corte

- Se identificaron el HDD de Debian y su partición EFI, y el NVMe Kingston de 2 TB sin particiones. El servidor arranca en UEFI. Proxmox se instalará en el NVMe y se protegerá el HDD como vía de vuelta atrás.
- El NVMe reportó cero advertencias críticas y cero errores de integridad. Las dos entradas visibles del registro correspondieron a campos de comando inválidos. El HDD aprobó SMART y reportó cero sectores pendientes o reasignados, con errores ATA históricos posteriores a su última prueba extendida. Repetir esa prueba después de verificar el ciclo programado de respaldo.
- La VM Debian conservará la dirección de los servicios y el DNS de la LAN. Proxmox tendrá una dirección de administración propia, fuera del rango DHCP dinámico, y usará un DNS independiente de AdGuard. Verificar conflictos de IP antes de asignar la dirección y trasladar la reserva DHCP a la MAC de la VM durante el corte si corresponde.
- La propuesta de almacenamiento usa ext4 y LVM-thin. La VM empieza con 4 vCPU, 6 GiB de RAM, 48 GiB para el sistema y 100 GiB para datos. Aprobar la distribución final, la ventana de mantenimiento y el criterio de reversión antes de instalar.

## Antes de intervenir

- [ ] Confirmar inventario actual de hardware, discos, volúmenes, bind mounts y contenedores.
- [ ] Verificar capacidad y salud de discos, y distinguir inequívocamente HDD de origen y NVMe destino.
- [ ] Aprobar ventana de mantenimiento y prever interrupción de DNS/proxy durante el backup consistente.
- [ ] Ejecutar respaldo cifrado; comprobar SHA-256 en el destino externo.
- [ ] Realizar prueba de extracción y restauración aislada, sin afectar producción.
- [ ] Aprobar topología de red, IPs, DNS independiente del hipervisor, asignación de CPU/RAM/discos y rollback.

## Después de migrar (cuando se autorice)

- [ ] Confirmar acceso administrativo y red del hipervisor.
- [ ] Confirmar Debian VM y acceso SSH.
- [ ] Restaurar Compose, configuraciones, datos persistentes y PKI desde backup verificado.
- [ ] Validar contenedores, healthchecks, persistencia y política de reinicio.
- [ ] Verificar DNS LAN, reverse proxy, HTTPS, certificados y acceso a cada servicio.
- [ ] Ejecutar pruebas funcionales: login, consultas DNS, dashboard, logs y monitoreo.
- [ ] Registrar evidencias y desvíos sin publicar secretos.
- [ ] Conservar el HDD original sin modificar hasta aprobar formalmente el cierre.

## Criterio de cierre

La migración no se considera terminada por el simple arranque de contenedores: exige pruebas funcionales y de restauración, evidencias y aceptación explícita. Tickets relacionados: JAR-29, JAR-31 y JAR-35.
