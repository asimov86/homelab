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
