# Portainer

## ¿Qué es?

Portainer es una plataforma de administración para Docker que proporciona una interfaz web para gestionar contenedores, imágenes, volúmenes, redes y otros recursos.

---

## ¿Por qué lo elegimos?

### Decisión técnica

Elegimos Portainer porque:

- Simplifica la administración de Docker mediante una interfaz web intuitiva.
- Permite visualizar y administrar contenedores, imágenes, redes y volúmenes.
- Facilita el aprendizaje mientras continuamos utilizando la terminal.
- Es una de las herramientas de administración de Docker más utilizadas por la comunidad.
- Será la herramienta principal para administrar todos los servicios Docker del HomeLab.

---

## Objetivo dentro del HomeLab

Portainer será la plataforma principal para administrar la infraestructura Docker del servidor **Jarvis**.

Su función es simplificar la administración diaria sin reemplazar el uso de la terminal, permitiendo aprender tanto la interfaz gráfica como los comandos de Docker.

---

## Versión

| Componente | Versión |
|------------|----------|
| Portainer Community Edition | 2.39.0 |

---

## Acceso

| Parámetro | Valor |
|-----------|-------|
| Protocolo | HTTPS |
| URL | https://192.168.0.24:9443 |
| Usuario inicial | admin |

> **Nota:** Durante la primera ejecución Portainer solicita configurar la contraseña del usuario administrador.

---

## Docker Compose

El servicio se encuentra definido mediante el archivo:

```text
compose.yaml
```

Toda la infraestructura del servicio se administra mediante Docker Compose.

---

## Persistencia

Portainer utiliza un volumen Docker administrado para almacenar:

- Usuarios.
- Configuración.
- Endpoints.
- Preferencias.
- Información de la plataforma.

Volumen utilizado:

```text
portainer_data
```

Este volumen permanece disponible incluso si el contenedor es eliminado y recreado.

---

## Seguridad

Portainer accede a Docker Engine mediante el socket de Docker:

```text
/var/run/docker.sock
```

Esto permite administrar contenedores, imágenes, redes y volúmenes directamente desde la interfaz web.

> **Importante:** El acceso al socket de Docker concede privilegios elevados sobre Docker Engine. Solo debe otorgarse a aplicaciones plenamente confiables.

---

## Decisiones técnicas

### Uso de `container_name`

Se define explícitamente:

```yaml
container_name: portainer
```

Esto facilita la administración manual del HomeLab mediante comandos como:

```bash
docker logs portainer
docker restart portainer
docker stop portainer
```

En escenarios donde sea necesario escalar múltiples instancias del servicio, esta decisión deberá reevaluarse.

---

### Uso de una versión fija

Se utiliza la versión:

```text
2.39.0
```

en lugar de `latest`.

Esto permite:

- Reproducibilidad.
- Mayor estabilidad.
- Evitar actualizaciones inesperadas.
- Conocer exactamente qué versión se encuentra desplegada.

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

Dentro del HomeLab se adoptará una estrategia híbrida:

- Volúmenes Docker para servicios donde no sea necesario acceder directamente a los archivos.
- Bind mounts para servicios cuyos datos deban respaldarse o administrarse directamente desde el sistema operativo.

---

## Estado

- [x] Servicio desplegado.
- [x] Servicio operativo.
- [x] Acceso validado desde otro equipo de la red.
- [x] Persistencia configurada.
- [ ] Procedimiento de actualización documentado.
- [ ] Procedimiento de backup documentado.

---

## Lessons Learned

### LL-001

El comando:

```bash
docker compose config
```

permite validar la sintaxis y la configuración del archivo `compose.yaml` antes de desplegar el servicio.

Se incorpora como buena práctica para todos los servicios del HomeLab.

---

## Referencias

- Docker Compose
- Docker Engine
- Portainer Community Edition

---

## Historial

| Fecha | Descripción |
|--------|-------------|
| Julio 2026 | Primer despliegue del servicio dentro del HomeLab. |
