# Jarvis — Checklist de preparación y validación de migración

**Estado:** procedimiento propuesto; no implica tareas ejecutadas.

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
