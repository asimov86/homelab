# Lessons Learned

Este documento registra problemas reales encontrados durante el desarrollo del HomeLab, su causa raíz y la solución aplicada.

---

# LL-001 - Docker: Permission denied al ejecutar docker ps

## Problema

```text
permission denied while trying to connect to the docker API at unix:///var/run/docker.sock
```

## Causa

El usuario pertenecía al grupo `docker`, pero la sesión actual todavía no había cargado la nueva pertenencia al grupo.

## Solución

Ejecutar:

```bash
newgrp docker
```

o cerrar la sesión SSH y volver a ingresar.

## Aprendizaje

Los cambios de pertenencia a grupos normalmente se aplican al iniciar una nueva sesión.

## LL-002 - DNS interno de Docker vs DNS de infraestructura

Durante la integración de AdGuard Home con Uptime Kuma se comprobó que los contenedores conectados a `jarvis_network` utilizan el DNS interno de Docker para resolver los nombres de otros servicios de esa red.

Este mecanismo es independiente de la resolución de dominios `*.jarvis.local` que AdGuard Home proporciona a los clientes de la LAN.

### Aprendizaje

- Como regla general, los contenedores de `jarvis_network` deben comunicarse mediante nombres de servicio Docker.
- Los dominios `*.jarvis.local` se utilizan para el acceso de clientes de la LAN.
- Las excepciones a esta estrategia deben justificarse y documentarse.

Esta separación reduce dependencias innecesarias entre los servicios Docker y la resolución DNS de la infraestructura.

La decisión arquitectónica correspondiente está documentada en `docs/decisions/ADR-003-container-communication.md`.
