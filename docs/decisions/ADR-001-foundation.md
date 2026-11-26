# Architecture Decisions

Este documento registra decisiones técnicas importantes del proyecto HomeLab.

## ADR-001 - Usar Debian 12 como sistema base

### Decisión

Debian 12 fue el sistema operativo del servidor original. Tras la migración a Proxmox, Jarvis funciona en la VM 100 con Debian 13.8. Esta decisión describe la plataforma original.

### Motivo

Debian ofrece estabilidad, bajo consumo de recursos, amplia documentación y excelente compatibilidad con Docker.

### Estado

Aceptada.

---

## ADR-002 - Usar Docker Compose para definir servicios

### Decisión

Los servicios Docker se definirán mediante archivos `compose.yaml`.

### Motivo

Docker Compose permite declarar infraestructura como código, versionar la configuración y recrear servicios de forma ordenada.

### Estado

Aceptada.

---

## ADR-003 - Versionar el HomeLab en GitHub

### Decisión

El proyecto HomeLab se versiona en un repositorio GitHub.

### Motivo

Permite documentar la evolución del proyecto, mantener historial de cambios y usar el repositorio como portfolio técnico.

### Estado

Aceptada.

---

## ADR-004 - Cada servicio tendrá su propia carpeta

### Decisión

Cada servicio Docker tendrá su propia carpeta dentro de `docker/`.

### Motivo

Mejora la organización, facilita la documentación, el mantenimiento y los commits por servicio.

### Estado

Aceptada.
