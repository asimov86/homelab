# Jarvis — Runbook de respaldo y restauración pre-Proxmox

**Estado:** respaldo remoto Restic y restauración de archivos aislada validados el 17/11/2026; recuperación funcional y automatización pendientes.
**Ticket de ejecución:** JAR-29.
**Propósito:** preservar el HomeLab antes de instalar Proxmox en el NVMe, manteniendo intacto el HDD Debian original.

## Alcance del respaldo

- Repositorio y archivos Compose, incluyendo configuraciones no versionadas necesarias para reconstruir servicios.
- Volúmenes Docker persistentes de AdGuard Home, Vaultwarden, Portainer, Uptime Kuma y Nginx Proxy Manager, y cualquier otro volumen identificado en el inventario actual.
- Bind mounts, incluida la configuración de Homepage.
- Material PKI requerido para recuperación: CA raíz, certificados y claves privadas, con protección reforzada.
- Inventario de imágenes, versiones, redes, montajes y dependencias; instrucciones de restauración.

No asumir que un archivo Compose contiene los datos persistentes. Confirmar el inventario de volúmenes y montajes **antes** de crear la copia.

## Controles obligatorios

1. **Destino externo:** preparar almacenamiento fuera de Jarvis (por ejemplo, PC de escritorio). No considerar un backup en el mismo HDD como respaldo externo.
2. **Cifrado:** generar un archivo cifrado con un mecanismo autenticado y una contraseña o clave fuerte que no se guarde junto al archivo. No incluir secretos ni claves de descifrado en GitHub.
3. **Consistencia:** coordinar una ventana de mantenimiento. Detener de forma controlada los contenedores con bases SQLite antes de copiar sus volúmenes, o usar un mecanismo de backup transaccional comprobado. Evitar copiar bases activas sin garantías de consistencia.
4. **Transferencia:** usar SFTP/SSH u otro transporte cifrado; no FTP sin cifrado.
5. **Integridad:** calcular SHA-256 del archivo cifrado en origen y destino; comprobar que coincidan. Un hash coincidente **no prueba** que el respaldo sea restaurable.
6. **Custodia:** proteger especialmente la clave privada de la CA y los datos de Vaultwarden. Limitar acceso, definir retención y no publicar rutas de custodia.

## Secuencia propuesta (requiere aprobación operativa)

1. Confirmar inventario actualizado, capacidad del destino y ventana de indisponibilidad aceptada.
2. Verificar que el script de respaldo esté revisado, sea idempotente cuando corresponda y no incluya secretos en logs.
3. Realizar una prueba en modo simulación si el script la admite.
4. Detener temporalmente los servicios que requieran consistencia, generar el respaldo cifrado y reanudar servicios.
5. Comprobar funcionamiento básico de los siete contenedores y DNS de la LAN.
6. Transferir la copia cifrada al destino externo por canal seguro y comparar hashes.
7. Restaurar en un **entorno aislado**, sin sobrescribir volúmenes productivos ni reutilizar puertos/IP de producción.
8. Validar arranque, datos persistentes, acceso, certificados y servicios; documentar fallas y correcciones.
9. Conservar el HDD original sin modificar hasta la aceptación formal de la migración.

## Pruebas mínimas de restauración

| Componente | Prueba esperada |
|---|---|
| Docker Compose | Configuración válida y servicios recreables |
| Vaultwarden | Datos accesibles en entorno aislado y certificados válidos |
| AdGuard Home | Configuración recuperada y consultas DNS de prueba |
| Nginx Proxy Manager | Hosts y certificados recuperados, sin exponerlos a producción |
| Uptime Kuma | Monitores y configuración persistentes |
| Portainer | Configuración y acceso restaurados |
| Homepage y Dozzle | Configuración y visualización operativas |
| PKI | Certificados verificables; claves privadas custodiadas de forma segura |

## Criterios de aceptación

- Archivo cifrado disponible fuera del servidor, hash de origen y destino coincidente.
- Descifrado y extracción de prueba satisfactorios en entorno aislado.
- Restauración de datos y validación funcional documentadas.
- Evidencia privada, responsables y fecha registrados; ninguna clave ni base de datos publicada.
- Aprobación explícita antes de modificar el NVMe o comenzar la migración.

**Importante:** este runbook **no contiene un script de backup listo para producción** ni autoriza parar contenedores. La implementación y validación del procedimiento pertenecen a JAR-29. Consultar también `pre-proxmox-checklist.md` y JAR-31/JAR-35.


## Evidencia de ejecución JAR-29 — 17/11/2026

- **Confirmado:** snapshot Restic cifrado `739abea8`, 53 archivos; comprobación `restic check --read-data` sin errores; restauración de archivos en un destino aislado; tres bases SQLite restauradas con `PRAGMA integrity_check = ok`; siete Compose y material crítico presente. No se restauraron ni iniciaron servicios de producción en esta prueba.
- **JBS v1.0:** existe un respaldo local automático de Vaultwarden mediante systemd, copia consistente de volumen detenido, archivo `tar.zst`, SHA-256 y retención de siete copias diarias. Retenciones semanal y mensual definidas pero no activas en el flujo revisado.
- **Pendiente:** automatizar la preparación validada del staging, autenticación SSH/SFTP desatendida y segura, retención remota, monitoreo y recuperación funcional aislada de servicios. El próximo paso exacto es **3.149.47 — inventario de mounts Docker**, aún no ejecutado.
- **Trazabilidad:** [JAR-29 en Linear](https://linear.app/jarvis-homelab/issue/JAR-29/tk-0404-respaldar-datos-y-validar-una-restauracion-aislada). [Registro operativo privado en Google Drive — acceso restringido](https://docs.google.com/document/d/1v3w5-dBuZbRmUnSN4thmWZ7FNlNT0CwzvS40exVq1hQ/edit).

**Límite de divulgación:** los detalles de autenticación SFTP/SSH, rutas de custodia, procedimientos internos de recuperación y evidencias operativas sensibles se mantienen exclusivamente en el documento privado. No publicar contraseñas, claves privadas, certificados privados ni bases de datos en GitHub.


## Continuidad JAR-29 — sesión 17/11/2026

**Estado: preparado, no desplegado.** Se completó inventario de volúmenes y persistencia de siete servicios; se identificó staging existente con copias SQLite que requieren actualización consistente antes del siguiente snapshot Restic. La restauración aislada de archivos fue validada, pero no la restauración funcional de servicios.

### AdGuard Home

- Decisión aprobada: recuperación funcional (configuración, DNS, clientes, reglas y fuentes de filtros); historial de consultas, estadísticas y sesiones no son obligatorios.

- AdGuard presta DNS principal a la LAN: no detener el contenedor para generar respaldos. El DNS secundario no garantiza continuidad ni filtrado.

- Se verificó versión, autenticación de API, inventario de archivos y ausencia de valores configurados en cinco referencias externas examinadas. El YAML es el componente principal. Pendiente: captura sin corte DNS, comprobación de estabilidad, validación y restauración funcional aislada.

### Portainer

- Portainer CE 2.39.0 opera detrás de proxy inverso en una red Docker interna, sin publicación directa de puerto administrativo. La API interna responde.

- La UI ofrece respaldo nativo de configuración (no incluye contenedores ni datos). Su descarga falló por validación CSRF de origen según logs; no se ha confirmado un respaldo exitoso.

- El binario admite el parámetro trusted-origins. Se preparó exclusivamente el cambio declarativo para el dominio interno específico en Compose; copia previa creada, validación docker compose config exitosa y diff de solo dos líneas. **El contenedor no se recreó ni reinició.**

- Usuario autorizó recreación controlada para mañana, no hoy. Al reanudar: revisar estado, autorización y rollback; aplicar solo Portainer, verificar UI y respaldo, revertir si falla. No desactivar CSRF, no cambiar proxy global ni eliminar volúmenes.

### Staging / Restic

- Diseño propuesto: preflight, bloqueo exclusivo, captura consistente SQLite mediante Online Backup API, AdGuard sin parada, Portainer mediante exportación oficial validada o alternativa consistente, validación, manifiesto y publicación atómica de generación. No implementado todavía.

- Pendientes: nuevo snapshot actualizado, automatización segura SSH/SFTP, retención, monitoreo y restauración funcional aislada. **JAR-29 sigue abierto.**

- Detalles de red, rutas, evidencias operativas y custodia solo en [registro privado](https://docs.google.com/document/d/1v3w5-dBuZbRmUnSN4thmWZ7FNlNT0CwzvS40exVq1hQ/edit). No publicar secretos.
