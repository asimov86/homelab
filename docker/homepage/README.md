# Homepage

## ¿Qué es?

Homepage es un dashboard moderno y altamente configurable que permite centralizar el acceso a todos los servicios del HomeLab mediante una única interfaz web.

Además de actuar como página de inicio de la infraestructura, permite integrar información proveniente de distintos servicios mediante widgets y paneles de estado.

---

## ¿Por qué lo elegimos?

### Decisión técnica

Se eligió Homepage porque:

- Centraliza el acceso a todos los servicios del HomeLab.
- Posee una interfaz moderna y altamente configurable.
- Permite integrarse con múltiples aplicaciones mediante widgets.
- Utiliza archivos YAML para toda su configuración.
- Es una de las soluciones más utilizadas por la comunidad HomeLab.
- Facilita el crecimiento del laboratorio sin depender de recordar direcciones IP o puertos.

---

## Objetivo dentro del HomeLab

Homepage será el punto de entrada principal del HomeLab.

Desde este dashboard accederemos a todos los servicios desplegados en **Jarvis**, visualizando además información relevante sobre el estado general de la infraestructura.

---

## Versión

| Componente | Versión |
|------------|----------|
| Homepage | latest (v1.13.2 al momento del despliegue) |

---

## Acceso

| Parámetro | Valor |
|-----------|-------|
| Protocolo | HTTP |
| URL | http://192.168.0.24:3000 |

Homepage fue configurado como el **Centro de Operaciones de Jarvis**, centralizando el acceso a los servicios del HomeLab.

> En una etapa posterior el acceso se realizará mediante HTTPS utilizando Nginx Proxy Manager.

---

## Docker Compose

El servicio se encuentra definido mediante el archivo:

```text
compose.yaml
```

Toda la infraestructura del servicio se administra mediante Docker Compose.

---

## Persistencia

Homepage almacena toda su configuración mediante archivos YAML.

Por esta razón se decidió utilizar un **Bind Mount** en lugar de un volumen Docker administrado.

Los archivos permanecerán dentro del propio repositorio del HomeLab.

Actualmente los siguientes archivos forman parte de la configuración versionada del servicio:

- settings.yaml
- services.yaml
- widgets.yaml
- bookmarks.yaml

Estructura prevista:

```text
homepage/
│
├── compose.yaml
├── README.md
└── config/
    ├── settings.yaml
    ├── services.yaml
    ├── widgets.yaml
    ├── bookmarks.yaml
    ├── docker.yaml
    └── custom.css
```

Esta decisión permite:

- Versionar toda la configuración en Git.
- Comparar cambios entre versiones.
- Realizar backups simples.
- Editar la configuración desde cualquier editor.
- Mantener la documentación junto al código.

---

## Seguridad

Actualmente Homepage será accesible únicamente dentro de la red local.

En una etapa posterior será publicado mediante Nginx Proxy Manager utilizando HTTPS y certificados TLS.

---

## Decisiones técnicas

### Uso de `container_name`

Se define explícitamente:

```yaml
container_name: homepage
```

Esto facilita la administración manual mediante comandos como:

```bash
docker logs homepage
docker restart homepage
docker stop homepage
```

---

### Estrategia de persistencia

Este servicio utiliza un **Bind Mount**.

Es el primer servicio del HomeLab donde aplicamos la estrategia híbrida de persistencia adoptada para el proyecto.

La elección se debe a que Homepage basa toda su configuración en archivos YAML que deseamos:

- Editar manualmente.
- Versionar.
- Respaldar.
- Mantener dentro del repositorio Git.

---

### Configuración basada en archivos

Toda la configuración del servicio se administra mediante archivos YAML versionados dentro del repositorio Git del HomeLab.

Actualmente se utilizan:

- settings.yaml
- services.yaml
- widgets.yaml
- bookmarks.yaml

Esta característica facilita la automatización, el versionado y el mantenimiento del HomeLab.

---

### Política de reinicio

Se utiliza:

```yaml
restart: unless-stopped
```

De esta forma Homepage volverá a iniciarse automáticamente después de un reinicio del servidor, excepto cuando el administrador lo haya detenido manualmente.

---

## Estado

## Estado

- [x] Servicio desplegado.
- [x] Servicio operativo.
- [x] Configuración inicial realizada.
- [x] Dashboard personalizado.
- [x] Integración con Portainer.
- [x] Integración con Uptime Kuma.
- [x] Widgets de recursos del servidor.
- [ ] Widget de Docker pendiente de configuración.
- [ ] Procedimiento de actualización documentado.
- [ ] Procedimiento de backup documentado.

---

## Lessons Learned

## Lessons Learned

### LL-001

Homepage utiliza archivos YAML para toda su configuración.

Esto permite administrar el dashboard como código (Configuration as Code), versionando todos los cambios mediante Git.

---

### LL-002

Homepage incorpora validación del encabezado HTTP Host.

Para permitir el acceso desde la red local fue necesario configurar la variable de entorno:

```text
HOMEPAGE_ALLOWED_HOSTS
---

### LL-003

Los archivos de configuración existentes deben reemplazarse completamente cuando se adopta una nueva configuración.

Mantener contenido anterior puede generar errores YAML como:

```text
expected a single document in the stream

---

## Arquitectura

Homepage constituye el punto central de acceso al HomeLab.

Actualmente integra los siguientes servicios:

- Homepage
- Portainer
- Uptime Kuma

En futuras etapas incorporará:

- Nginx Proxy Manager
- Nextcloud
- Paperless
- Immich
- Jellyfin
- NAS

---

## Referencias

- Docker Compose
- Docker Engine
- Homepage

---

## Historial

| Fecha | Descripción |
|--------|-------------|
| Julio 2026 | Inicio de la implementación del servicio Homepage. |
| Julio 2026 | Se personalizó el dashboard inicial del HomeLab. |
| Julio 2026 | Se integraron Portainer y Uptime Kuma. |
