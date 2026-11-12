# Jarvis — Runbook de auditoría pre-Proxmox

**Estado:** procedimiento propuesto, no ejecutado por este documento.
**Referencia de inventario:** 08/11/2026.
**Objetivo:** producir evidencias reproducibles y sanitizadas antes de autorizar una migración.

## Reglas de ejecución

- Ejecutar desde una sesión SSH en el Debian actual, sin privilegios elevados salvo necesidad explícita.
- No copiar salidas completas a GitHub: pueden incluir IPs, rutas internas, usuarios, tokens o datos privados.
- Guardar evidencias completas en almacenamiento privado; registrar en GitHub únicamente fecha, resultado y hallazgos no sensibles.
- Los comandos siguientes son de consulta; no instalan, reinician ni modifican servicios.

## 1. Sistema y hardware

```bash
hostnamectl
uname -a
free -h
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS,MODEL
findmnt /
df -h
```

**Comprobar:** SO y kernel, RAM, raíz en HDD de origen, identificación inequívoca del NVMe de destino. Nunca inferir el disco de instalación solo por el nombre `/dev/sdX` o `/dev/nvmeXnY`.

## 2. Docker y persistencia

```bash
docker version
docker compose version
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
docker network ls
docker volume ls
docker ps -aq | xargs -r docker inspect --format '{{.Name}}: {{json .Mounts}}'
```

**Comprobar:** siete servicios esperados, imágenes y versiones, redes, volúmenes y bind mounts. La inspección de mounts puede mostrar rutas privadas: no publicarla sin sanitizar. No usar `docker inspect` completo en evidencias públicas: puede incluir variables de entorno sensibles.

## 3. Configuración declarativa

Desde la raíz del repositorio:

```bash
git status --short
git branch --show-current
git remote -v
find docker -name 'compose.yaml' -type f -print
```

Validar individualmente cada archivo Compose con `docker compose -f RUTA/compose.yaml config --quiet` después de inspeccionar la ruta. **No publicar** la salida de `docker compose config` sin revisarla: puede resolver secretos y variables de entorno.

## 4. Red, DNS y acceso

```bash
ip -brief address
ip route
ss -lntup
```

**Comprobar:** IP y gateway de referencia, puertos publicados, dependencia de AdGuard Home y Nginx Proxy Manager. Registrar el estado de resolución de `*.jarvis.local` desde un cliente de la LAN y la resolución de nombres de servicio dentro de la red Docker, sin publicar datos privados. El DNS del futuro hipervisor debe funcionar independientemente de la VM Docker.

## 5. Seguridad y Git

```bash
git status --short
git ls-files -- security/pki/root-ca/
git check-ignore -v security/pki/root-ca/jarvis-root-ca.key
```

**Comprobar:** claves privadas no versionadas; reglas de exclusión activas. La exclusión de Git **no equivale** a cifrado ni garantiza ausencia de secretos en otros archivos o en el historial.

## Evidencia y aceptación

Registrar fecha, operador, versión del procedimiento, comandos ejecutados, resultados y desvíos. Mantener el detalle sensible en almacenamiento privado. Esta auditoría se considera **completada** únicamente cuando las evidencias actuales se revisan y se documentan los hallazgos; no implica que el backup o la migración estén aprobados.

**Referencias:** `pre-proxmox-baseline.md`, `pre-proxmox-checklist.md`, ADR-003, JAR-16, JAR-29 y JAR-31.
