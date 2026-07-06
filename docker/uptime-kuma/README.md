# Uptime Kuma

## ¿Qué es?

Uptime Kuma es una plataforma de monitoreo de disponibilidad (uptime monitoring) de código abierto que permite supervisar servicios, aplicaciones, sitios web, APIs y equipos de infraestructura mediante una interfaz web sencilla e intuitiva.

---

## ¿Por qué lo elegimos?

### Decisión técnica

Se eligió Uptime Kuma porque:

- Permite monitorear la disponibilidad de los servicios del HomeLab.
- Es una solución liviana, moderna y de código abierto.
- Posee una interfaz web intuitiva.
- Permite generar alertas mediante múltiples canales de notificación.
- Es una de las herramientas de monitoreo más utilizadas en entornos HomeLab.

---

## Objetivo dentro del HomeLab

Uptime Kuma será la plataforma encargada de supervisar continuamente la disponibilidad de todos los servicios desplegados en **Jarvis**.

Permitirá detectar rápidamente caídas de servicios, medir tiempos de respuesta y visualizar el estado general de la infraestructura.

---

## Versión

| Componente | Versión |
|------------|----------|
| Uptime Kuma | 1.x |

> Se utiliza la última versión estable de la rama principal (`:1`).

---

## Acceso

| Parámetro | Valor |
|-----------|-------|
| Protocolo | HTTP |
| URL | http://192.168.0.24:3001 |
| Usuario | Configurado durante la primera ejecución |

---

## Docker Compose

El servicio se encuentra definido mediante el archivo:

```text
compose.yaml
```

Toda la infraestructura del servicio se administra mediante Docker Compose.

---

## Persistencia

Uptime Kuma utiliza un volumen Docker administrado para almacenar:

- Usuarios.
- Configuración.
- Monitores.
- Historial de disponibilidad.
- Configuración de notificaciones.
- Certificados y datos internos.

Volumen utilizado:

```text
uptime_kuma_data
```

Este volumen permanece disponible aunque el contenedor sea eliminado y recreado.

---

## Seguridad

Actualmente el acceso al servicio se realiza mediante HTTP.

En una etapa posterior del proyecto se publicará detrás de un Reverse Proxy (Nginx Proxy Manager) utilizando HTTPS y certificados TLS.

---

## Decisiones técnicas

### Uso de `container_name`

Se define explícitamente:

```yaml
container_name: uptime-kuma
```

Esto facilita la administración manual mediante comandos como:

```bash
docker logs uptime-kuma
docker restart uptime-kuma
docker stop uptime-kuma
```

---

### Uso de una versión fija

Se utiliza la etiqueta:

```text
:1
```

correspondiente a la rama estable principal de Uptime Kuma.

Esto permite recibir actualizaciones menores compatibles sin adoptar automáticamente cambios de una futura versión mayor.

---

### Política de reinicio

Se utiliza:

```yaml
restart: unless-stopped
```

De esta forma el servicio vuelve a iniciarse automáticamente después de un reinicio del servidor, excepto cuando el administrador lo haya detenido manualmente.

---

### Estrategia de persistencia

Para este servicio se decidió utilizar un volumen Docker administrado.

Esta decisión forma parte de la estrategia híbrida adoptada para el HomeLab:

- Volúmenes Docker para datos internos de las aplicaciones.
- Bind mounts para servicios cuyos archivos deban administrarse directamente desde el sistema operativo.

---

## Monitoreos configurados

Actualmente se encuentra configurado el monitoreo de:

| Servicio | Estado |
|----------|--------|
| Portainer | ✅ Operativo |

Configuración utilizada:

- Tipo: HTTP(s)
- Intervalo: 60 segundos
- Verificación SSL: Ignorar certificado local

---

## Estado

- [x] Servicio desplegado.
- [x] Servicio operativo.
- [x] Acceso validado desde otro equipo de la red.
- [x] Persistencia configurada.
- [x] Primer monitor configurado (Portainer).
- [ ] Procedimiento de actualización documentado.
- [ ] Procedimiento de backup documentado.

---

## Lessons Learned

### LL-001

El primer servicio monitoreado del HomeLab fue Portainer.

Esto permitió validar correctamente:

- Conectividad HTTPS.
- Mapeo de puertos.
- Resolución mediante IP local.
- Ignorar certificados autofirmados durante la etapa inicial del proyecto.

---

### LL-002

El estado **Healthy** mostrado por Docker indica que el contenedor superó correctamente el *Health Check* definido por la imagen.

Esto proporciona una validación adicional del correcto funcionamiento del servicio.

---

## Referencias

- Docker Compose
- Docker Engine
- Uptime Kuma

---

## Historial

| Fecha | Descripción |
|--------|-------------|
| Julio 2026 | Primer despliegue de Uptime Kuma dentro del HomeLab. |
| Julio 2026 | Se configuró el monitoreo del servicio Portainer. |
