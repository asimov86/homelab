# Observability Architecture

**Versión:** 1.0

**Estado:** Activo

**Autor:** Kenny Velandia

**Proyecto:** Jarvis HomeLab

**Última actualización:** Julio 2026

---

# Propósito

Este documento define la arquitectura de observabilidad de la plataforma Jarvis.

Su objetivo es establecer cómo se supervisan la disponibilidad, los logs, la salud y, en futuras etapas, las métricas y alertas de la plataforma.

La observabilidad debe permitir responder rápidamente:

- si los servicios están disponibles;
- qué ocurrió cuando algo falla;
- qué componente requiere atención;
- si las tareas operativas críticas se ejecutaron correctamente.

---

# Alcance

Esta arquitectura aplica a los servicios, contenedores y tareas operativas de Jarvis.

La versión 1.0 contempla:

- disponibilidad mediante Uptime Kuma;
- consulta centralizada de logs mediante Dozzle;
- vista general y acceso mediante Homepage;
- logs de tareas automatizadas mediante `journalctl`.

Las métricas avanzadas y las alertas externas se incorporarán únicamente cuando exista una necesidad operativa real.

---

# Principios

## 1. La observabilidad debe responder preguntas

La plataforma no debe generar dashboards o métricas sin un propósito operativo.

Cada elemento debe ayudar a responder una pregunta concreta.

Ejemplos:

- ¿Vaultwarden está disponible?
- ¿El contenedor está saludable?
- ¿El backup se ejecutó?
- ¿Qué error ocurrió?
- ¿Qué capa de la arquitectura falló?

---

## 2. La arquitectura precede a la implementación

Antes de incorporar una nueva herramienta debe definirse:

- qué problema resuelve;
- qué información recopila;
- quién utiliza esa información;
- qué acción permite tomar.

---

## 3. Cada herramienta tiene una responsabilidad única

Las herramientas no deben duplicar responsabilidades innecesariamente.

| Herramienta | Responsabilidad |
|-------------|-----------------|
| Homepage | Vista general y acceso a los servicios |
| Uptime Kuma | Disponibilidad |
| Dozzle | Logs de contenedores |
| `journalctl` | Logs de tareas y servicios systemd |
| Prometheus | Recolección futura de métricas |
| Grafana | Visualización futura de métricas |
| Telegram o correo | Alertas futuras |

---

## 4. Lo importante primero

La observabilidad debe priorizar:

1. servicios críticos;
2. fallas que requieran intervención;
3. información útil para el diagnóstico;
4. tendencias de capacidad cuando sean necesarias.

---

## 5. Una alerta debe conducir a una acción

No se generarán alertas únicamente para informar.

Toda alerta futura deberá indicar, directa o indirectamente, una condición que requiera revisión o intervención.

---

## 6. La observabilidad acompaña a la operación

La información observada debe utilizarse para operar Jarvis, diagnosticar fallas y validar automatizaciones.

No se implementa observabilidad solo por interés visual.

---

# Capas de observabilidad

```text
                    Administrador
                         │
                         ▼
                      Homepage
                Vista general y acceso
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
    Uptime Kuma        Dozzle       journalctl
    Disponibilidad      Logs        Tareas systemd
          │              │              │
          └──────────────┼──────────────┘
                         ▼
                  Diagnóstico operativo
```

En futuras versiones:

```text
Servicios y Host
       │
       ▼
   Prometheus
       │
       ▼
     Grafana
       │
       ▼
 Métricas y tendencias
```

---

# Disponibilidad

Uptime Kuma es responsable de verificar si los servicios responden.

Para servicios importantes se contemplan dos niveles.

## Monitor interno

Ejemplo:

```text
http://vaultwarden:80/alive
```

Valida:

- DNS interno de Docker;
- `jarvis_network`;
- contenedor;
- aplicación.

## Monitor extremo a extremo

Ejemplo futuro:

```text
https://vaultwarden.jarvis.local
```

Validará además:

- resolución DNS local;
- Nginx Proxy Manager;
- HTTPS;
- certificado;
- experiencia real del usuario.

La coexistencia de ambos monitores permite identificar la capa afectada.

```text
Interno UP + Externo DOWN
        │
        ▼
Problema probable en DNS, proxy o TLS
```

---

# Logging

## Logs de contenedores

Dozzle permite consultar los logs de los contenedores Docker desde una interfaz centralizada.

Su responsabilidad es facilitar:

- inspección rápida;
- seguimiento en tiempo real;
- diagnóstico inicial;
- comparación entre contenedores.

Dozzle no reemplaza la persistencia de logs ni una futura plataforma centralizada.

## Logs de systemd

Las tareas automatizadas mediante systemd se revisan con:

```bash
journalctl
```

Ejemplo:

```bash
sudo journalctl \
  -u jbs-backup@vaultwarden.service \
  --no-pager
```

Esto permite validar:

- inicio y fin de tareas;
- códigos de error;
- ejecución de backups;
- reinicios de servicios;
- eventos operativos.

---

# Homepage

Homepage actúa como vista general y catálogo de servicios.

Los servicios se organizan por dominio funcional:

- Administración;
- Infraestructura;
- Seguridad;
- Monitoreo.

Homepage no reemplaza a las herramientas de observabilidad.

Su función es centralizar el acceso y proporcionar una vista operativa inicial.

---

# Criticidad

La observabilidad reutiliza los niveles de criticidad definidos en Jarvis.

## Nivel 1 — Crítico

La falla afecta datos sensibles o una capacidad esencial.

Ejemplos:

- Vaultwarden;
- Nginx Proxy Manager;
- backups críticos.

Requiere:

- monitor de disponibilidad;
- revisión de logs;
- healthcheck;
- futuras alertas.

## Nivel 2 — Importante

La falla degrada la administración o visibilidad, pero no compromete inmediatamente datos críticos.

Ejemplos:

- Portainer;
- Homepage;
- Uptime Kuma.

Requiere:

- disponibilidad;
- logs cuando corresponda.

## Nivel 3 — Auxiliar

La falla no afecta directamente la operación principal.

Ejemplo:

- Dozzle.

Requiere:

- disponibilidad básica.

---

# Flujo operativo

Cuando se detecta una falla:

```text
Alerta o servicio no disponible
             │
             ▼
       Revisar Uptime Kuma
             │
             ▼
Determinar si la falla es interna o externa
             │
             ▼
      Revisar logs en Dozzle
             │
             ▼
 Revisar journalctl si interviene systemd
             │
             ▼
       Identificar la causa
             │
             ▼
      Aplicar la corrección
             │
             ▼
       Confirmar recuperación
```

---

# Estado actual

## Implementado

- Homepage como vista general.
- Uptime Kuma para disponibilidad.
- Dozzle para logs Docker.
- Healthchecks de contenedores cuando la imagen los proporciona.
- `journalctl` para tareas JBS automatizadas.
- Monitor interno de Vaultwarden.
- Verificación automática de backups mediante logs y checksum.

## Pendiente por necesidad futura

- Métricas del host.
- Métricas de Docker.
- Prometheus.
- Grafana.
- Alertas por Telegram o correo.
- Script resumido `jarvis-health.sh`.
- Monitor extremo a extremo HTTPS para servicios críticos.

Estos elementos permanecen en backlog y no forman parte de la implementación actual.

---

# Criterios de aceptación

La arquitectura de observabilidad se considera aplicada cuando:

- los servicios críticos tienen monitor de disponibilidad;
- los logs pueden consultarse de forma centralizada;
- las tareas systemd generan registros verificables;
- Homepage refleja la organización funcional de la plataforma;
- existe un flujo claro de diagnóstico;
- no se incorporan herramientas sin una necesidad definida.

---

# Relación con otros documentos

Esta arquitectura complementa:

- Jarvis Deployment Standard;
- Jarvis Backup Standard;
- Security Architecture;
- README de Uptime Kuma;
- README de Dozzle;
- README de Homepage;
- documentación de cada servicio monitoreado.

---

# Matriz de Monitoreo

La siguiente matriz define la estrategia oficial de observabilidad para cada servicio de Jarvis.

Cada servicio puede disponer de hasta tres niveles de monitoreo:

- Monitoreo interno (Docker)
- Monitoreo externo (Reverse Proxy / HTTPS)
- Monitoreo público (Internet) — futuro

Además, cada servicio debe indicar si dispone de:

- Healthcheck Docker
- Logs accesibles desde Dozzle

La criticidad determina el nivel mínimo de observabilidad requerido.

---

| Servicio | Criticidad | Interno | Externo | Healthcheck | Logs | Estado |
|----------|------------|----------|----------|-------------|------|--------|
| Vaultwarden | Nivel 1 | ✅ | ⏳ | ✅ | ✅ | Operativo |
| Portainer | Nivel 2 | ✅ | ⏳ | ❌ | ✅ | Operativo |
| Homepage | Nivel 2 | ✅ | ⏳ | ✅ | ✅ | Operativo |
| Nginx Proxy Manager | Nivel 1 | ✅ | ⏳ | ❌ | ✅ | Operativo |
| Uptime Kuma | Nivel 2 | ✅ | ⏳ | ✅ | ✅ | Operativo |
| Dozzle | Nivel 3 | ⏳ | No aplica | ✅ | No aplica | Operativo |

---

## Significado de las columnas

### Criticidad

Nivel de importancia del servicio dentro de la plataforma.

- **Nivel 1** → Servicio crítico.
- **Nivel 2** → Servicio importante.
- **Nivel 3** → Servicio auxiliar.

---

### Interno

Monitoreo realizado desde `jarvis_network`.

Ejemplos:

- `http://portainer:9000/api/status`
- `http://vaultwarden:80/alive`

Valida:

- Docker DNS;
- red Docker;
- contenedor;
- aplicación.

---

### Externo

Monitoreo mediante Nginx Proxy Manager utilizando HTTPS.

Ejemplos futuros:

- `https://vaultwarden.jarvis.local`
- `https://portainer.jarvis.local`

Valida:

- resolución DNS;
- Reverse Proxy;
- certificados TLS;
- HTTPS;
- aplicación.

---

### Healthcheck

Indica si el servicio dispone de un **Docker Healthcheck** configurado y operativo.

Cuando existe, Docker puede informar el estado:

- `healthy`
- `starting`
- `unhealthy`

---

### Logs

Indica si los registros del servicio son accesibles desde Dozzle para diagnóstico operativo.

---

### Estado

Situación actual del monitoreo del servicio.

Valores habituales:

- Operativo
- Pendiente
- En implementación

---

## Política de implementación

Todo nuevo servicio incorporado a Jarvis deberá:

1. Definir su nivel de criticidad.
2. Incorporarse a esta matriz.
3. Contar con monitoreo interno cuando corresponda.
4. Contar con monitoreo externo cuando la arquitectura lo permita.
5. Disponer de Healthcheck siempre que la imagen Docker lo soporte.
6. Exponer sus logs para diagnóstico mediante Dozzle.
7. Actualizar esta matriz antes de considerarse completamente integrado.

---

## Roadmap de Observabilidad

### Implementado

- Monitoreo interno de Vaultwarden.
- Monitoreo interno de Portainer.
- Healthcheck de Vaultwarden.
- Healthcheck de Homepage.
- Healthcheck de Uptime Kuma.
- Healthcheck de Dozzle.
- Logs centralizados mediante Dozzle.

### Próximo objetivo

Implementar DNS interno de Jarvis para habilitar el monitoreo externo mediante:

- `https://vaultwarden.jarvis.local`
- `https://portainer.jarvis.local`
- `https://homepage.jarvis.local`
- `https://uptime.jarvis.local`

Posteriormente se incorporarán los monitores públicos para servicios expuestos a Internet.

---

# Historial de cambios

| Versión | Fecha | Descripción |
|---------|-------|-------------|
| 1.0 | Julio 2026 | Primera arquitectura oficial de observabilidad de Jarvis. |
