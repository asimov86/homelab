# Despliegue reproducible de servicios Jarvis

Los Compose requieren valores del entorno. Proporcionarlos mediante un archivo privado con la opción `--env-file`, o mediante variables de entorno de la sesión.

| Variable | Uso | Ejemplo para laboratorio |
| --- | --- | --- |
| `JARVIS_DOCKER_NETWORK` | Red Docker externa compartida. Crear antes de desplegar. | `app_network` |
| `JARVIS_APPDATA_ROOT` | Directorio absoluto del volumen de datos del host. Crear los subdirectorios requeridos por cada Compose. | `/mnt/appdata` |
| `JARVIS_SERVICE_DOMAIN` | Sufijo DNS de los servicios, sin protocolo. Lo usan Homepage y Vaultwarden. | `lab.example` |
| `JARVIS_PROXY_ADMIN_URL` | Enlace de administración que muestra Homepage. Opcional. | `http://localhost:8181` |
| `JARVIS_TZ` | Zona horaria de Vaultwarden. Opcional. | `UTC` |

Desde el directorio de cada servicio, validar con `docker compose --env-file <archivo-privado> config --quiet` y revisar las imágenes con `docker compose --env-file <archivo-privado> config --images`. Antes de iniciar Homepage, copiar el contenido versionado de su directorio `config` al directorio persistente indicado por su Compose. Para una reinstalación, conservar el nombre de proyecto de cada servicio y verificar los volúmenes existentes antes de aplicar la configuración. Las publicaciones efectivas de producción se controlan mediante un override guardado fuera del repositorio. Mantener los puertos de administración en loopback.

## Reversión de una imagen

1. Registrar los digests y la configuración efectivos. Obtener un respaldo consistente de los datos antes de cambiar versiones.
2. En un entorno aislado, restaurar una copia de los datos y probar el digest previo. Si la versión nueva cambió el formato de los datos, usar el respaldo anterior a la actualización para la prueba.
3. Tras validar la compatibilidad, seleccionar el digest previo para el servicio afectado, ejecutar Compose para ese servicio y verificar arranque, persistencia y acceso. Si también hay que restaurar datos de producción, coordinar la interrupción y aplicar el procedimiento de [JBS](../docs/standards/JBS.md).

Los digests fijados de esta reconstrucción se descargaron y arrancaron en Jarvis. Falta cotejarlos con el inventario histórico y realizar una prueba de reversión con datos restaurados.
