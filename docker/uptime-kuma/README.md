# Uptime Kuma

**Versión:** 1.0

**Estado:** Activo

**Autor:** Kenny Velandia

**Proyecto:** Jarvis HomeLab

**Última actualización:** Julio 2026

---

# ¿Qué es?

Uptime Kuma es la plataforma de monitoreo utilizada por Jarvis para verificar la disponibilidad y el estado operativo de los servicios que componen la infraestructura.

Permite realizar verificaciones periódicas, registrar históricos de disponibilidad y visualizar el estado general de la plataforma desde una única interfaz.

---

# Objetivo dentro de Jarvis

Uptime Kuma constituye la capa de monitoreo de la plataforma.

Su función es detectar de forma temprana la indisponibilidad de los servicios críticos y proporcionar una visión centralizada del estado operativo de Jarvis.

---

# Arquitectura

```text
Administrador
      │
      ▼
https://uptime.jarvis.local
      │
      ▼
Nginx Proxy Manager
      │
      ▼
jarvis_network
      │
      ▼
Uptime Kuma
      │
      ├────────► Vaultwarden
      ├────────► Portainer
      ├────────► Homepage
      └────────► Nginx Proxy Manager
```

---

# Despliegue

Imagen Docker:

```text
louislam/uptime-kuma:1
```

Configuración principal:

- Docker Compose.
- `restart: unless-stopped`.
- Integrado a `jarvis_network`.
- Acceso mediante Nginx Proxy Manager.
- Persistencia mediante volumen Docker.

---

# Seguridad

El servicio no expone puertos directamente para administración fuera de la arquitectura prevista.

El acceso se realiza mediante HTTPS utilizando Nginx Proxy Manager.

Los monitores internos utilizan exclusivamente la red Docker `jarvis_network`.

---

# Observabilidad

Uptime Kuma implementa la estrategia oficial de observabilidad definida para Jarvis.

Actualmente monitorea:

- Vaultwarden
- Portainer
- Homepage
- Nginx Proxy Manager
- Uptime Kuma

En el futuro incorporará:

- Monitoreo externo mediante DNS interno.
- Monitoreo público para servicios expuestos a Internet.
- Alertas automáticas.

---

# Relación con otros servicios

Depende de:

- Docker Engine.
- jarvis_network.
- Nginx Proxy Manager.

Complementa:

- Dozzle.
- Homepage.

---

# Estado

- [x] Servicio desplegado.
- [x] Persistencia configurada.
- [x] Integrado a jarvis_network.
- [x] Acceso mediante HTTPS.
- [x] Monitoreo interno operativo.
- [x] Documentado.

---

# Historial

| Fecha | Descripción |
|--------|-------------|
| Julio 2026 | Incorporación oficial como plataforma de monitoreo de Jarvis. |
