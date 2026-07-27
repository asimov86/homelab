# Dozzle

**Versión:** 1.0

**Estado:** Activo

**Autor:** Kenny Velandia

**Proyecto:** Jarvis HomeLab

**Última actualización:** Julio 2026

---

# ¿Qué es?

Dozzle es una interfaz web ligera para visualizar en tiempo real los logs de los contenedores Docker.

Permite consultar el estado operativo de los servicios sin necesidad de acceder por SSH ni ejecutar comandos sobre el servidor.

---

# Objetivo dentro de Jarvis

Dozzle constituye la capa de visualización de logs de la plataforma.

Su finalidad es facilitar el diagnóstico operativo durante la administración diaria del HomeLab.

No reemplaza un sistema centralizado de logs, sino que proporciona una vista inmediata del estado de los contenedores.

---

# Arquitectura

```text
Administrador
      │
      ▼
https://dozzle.jarvis.local
      │
      ▼
Nginx Proxy Manager
      │
      ▼
jarvis_network
      │
      ▼
Dozzle
      │
      ▼
Docker Socket (solo lectura)
      │
      ▼
Contenedores Docker
```

---

# Despliegue

Imagen Docker:

```text
amir20/dozzle:v10.6.12
```

Configuración principal:

- Docker Compose.
- `restart: unless-stopped`.
- Integrado a `jarvis_network`.
- Acceso únicamente mediante Nginx Proxy Manager.
- Docker Socket montado en modo solo lectura.

---

# Seguridad

Dozzle no publica puertos directamente hacia el host.

El acceso se realiza exclusivamente mediante el Reverse Proxy.

El socket Docker se monta como:

```text
/var/run/docker.sock:ro
```

Esto evita modificaciones sobre Docker desde Dozzle.

---

# Observabilidad

Dozzle forma parte de la arquitectura de observabilidad definida para Jarvis.

Responsabilidad:

- visualizar logs;
- facilitar el diagnóstico;
- inspeccionar eventos de los contenedores.

No realiza monitoreo activo ni genera alertas.

---

# Relación con otros servicios

Depende de:

- Docker Engine.
- jarvis_network.
- Nginx Proxy Manager.

Complementa:

- Uptime Kuma.
- Homepage.

---

# Estado

- [x] Servicio desplegado.
- [x] Integrado a jarvis_network.
- [x] Healthcheck configurado.
- [x] Visible desde Homepage.
- [x] Integrado a Uptime Kuma.
- [x] Acceso mediante HTTPS.
- [x] Documentado.

---

# Historial

| Fecha | Descripción |
|--------|-------------|
| Julio 2026 | Incorporación oficial a la plataforma Jarvis y actualización a la versión 10.6.12. |
