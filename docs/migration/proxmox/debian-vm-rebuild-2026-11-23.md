# Jarvis — reconstrucción sobre Proxmox

**Corte del 23/11/2026.** La VM Debian está operativa y los siete servicios se reconstruyeron desde cero. El siguiente bloque de trabajo es el respaldo externo y la restauración aislada.

## Reconstrucción verificada

| Área | Resultado |
| --- | --- |
| Base Debian | Debian 13.8, SSH y QEMU Guest Agent activos en el invitado. |
| Almacenamiento | El volumen ext4 dedicado a datos se monta por UUID. Se verificó después de reiniciar y se probó persistencia entre contenedores. |
| Docker | Engine 29.10.0 y Compose v5.8.0. Docker y containerd activos y habilitados al arranque. |
| Versiones de imágenes | Los siete servicios se descargaron y arrancaron con imágenes fijadas por digest. Quedan pendientes el cotejo histórico y la prueba de reversión de versiones. |
| Acceso | DNS interno y acceso HTTPS comprobados desde Windows. El panel de Nginx Proxy Manager se conserva como acceso de administración por túnel. |
| PKI | Se adoptó una nueva CA interna y certificados individuales. Se validaron la cadena y el acceso de cliente en Windows. Quedan pendientes custodia externa, recuperación independiente, revocación y distribución a otros clientes. |

## Servicios

- Homepage carga la configuración versionada y presenta los enlaces HTTPS.
- Dozzle entrega eventos y logs. Se confirmó que rechaza solicitudes sin credenciales.
- Portainer autenticó al administrador y mostró el entorno Docker local.
- Uptime Kuma funciona detrás del proxy por WebSocket. Tiene seis monitores, incluidos DNS interno y enrutamiento del proxy. Falta una sonda externa a la VM.
- Vaultwarden arrancó con datos nuevos, se probó el alta por invitación y el inicio de sesión. El registro público y el panel administrativo están deshabilitados.
- AdGuard Home resuelve nombres internos y públicos por UDP y TCP.
- Nginx Proxy Manager termina TLS para las aplicaciones. Se validaron seis destinos por HTTPS.

Los detalles de recuperación, red y custodia se registran en el documento operativo privado del proyecto. Las opciones finales de arranque y la consulta del Guest Agent desde el hipervisor quedaron pendientes de revisión. El punto de retorno previo a Docker está visible en Proxmox.

## Retomar con la Fase H

1. Inventariar los datos, configuraciones, archivos de despliegue efectivos y material PKI. Preparar una copia consistente de los datos de las aplicaciones.
2. Confirmar el destino cifrado externo y el acceso independiente de recuperación. Revisar el respaldo histórico en modo lectura antes de decidir cómo reutilizarlo.
3. Ejecutar un respaldo manual, verificar la integridad y probar una restauración aislada. Solo después programar ejecución, retención y alertas según el [Jarvis Backup Standard](../../standards/JBS.md).

La Fase H aún no se inició. JAR-29, JAR-53 y JAR-56 conservan pendientes de validación.
