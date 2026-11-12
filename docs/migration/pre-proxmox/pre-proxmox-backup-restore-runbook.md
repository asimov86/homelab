# Jarvis — Runbook de respaldo y restauración pre-Proxmox

**Estado:** diseño documental; **backup y restauración no ejecutados ni validados** por este documento.
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
