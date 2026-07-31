# Infraestructura de Red

> **Estado:** En construcción  
> **Última actualización:** 30/07/2026  
> **Sprint actual:** Sprint 4 - Infraestructura Base  
> **Autor:** Kenny Velandia & ChatGPT

---

# Introducción

La infraestructura de red constituye uno de los pilares fundamentales del HomeLab.

Su objetivo es proporcionar una plataforma estable, segura y escalable sobre la cual operar todos los servicios del laboratorio, independizando la administración de la red del equipamiento provisto por el proveedor de Internet.

En esta sección se documentan las decisiones de arquitectura, configuraciones realizadas, procedimientos de migración, incidentes relevantes y las lecciones aprendidas durante la evolución de la infraestructura.

Esta documentación permitirá comprender no solamente **qué fue configurado**, sino también **por qué se tomó cada decisión**, facilitando futuras ampliaciones, tareas de mantenimiento y resolución de problemas.

---

# Objetivos

- Documentar la arquitectura de red del HomeLab.
- Registrar las decisiones de arquitectura adoptadas.
- Mantener procedimientos reproducibles.
- Registrar incidentes y su resolución.
- Centralizar toda la documentación relacionada con networking.
- Servir como referencia para futuras ampliaciones del laboratorio.

---

# Componentes de la infraestructura

Actualmente la infraestructura de red está compuesta por:

- TP-Link Omada ER605
- AdGuard Home
- Nginx Proxy Manager
- Docker Network (`jarvis_network`)
- DNS interno (`*.jarvis.local`)

En futuras etapas se incorporarán:

- HTTPS interno mediante PKI
- Access Point Omada
- Omada Controller
- VLANs
- VPN
- Exposición segura de servicios
- Firewall avanzado

---

# Documentación disponible

| Documento | Descripción |
|------------|-------------|
| sprint-04-er605-migration.md | Migración completa hacia la nueva infraestructura de red. |
| troubleshooting/ | Registro de incidentes, diagnósticos y soluciones. |

---

# Filosofía

La infraestructura de red del HomeLab se documenta siguiendo los mismos principios definidos para el resto del proyecto:

- Comprender antes de implementar.
- Documentar cada decisión técnica.
- Mantener una arquitectura modular.
- Priorizar la reproducibilidad.
- Registrar tanto las soluciones como el proceso de diagnóstico.

La documentación forma parte del proyecto y evoluciona junto con la infraestructura.
