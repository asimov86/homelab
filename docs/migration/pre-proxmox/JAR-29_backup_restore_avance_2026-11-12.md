# JAR-29 — Backup & Restore | Registro de avance

**Proyecto:** Jarvis — HomeLab & AI Platform  
**Fecha de corte de las operaciones:** 2026-11-12  
**Estado:** En progreso. **No existe todavía evidencia de un backup integral restaurable.**  
**Ticket:** [JAR-29 en Linear](https://linear.app/jarvis-homelab/issue/JAR-29/tk-0404-respaldar-datos-y-validar-una-restauracion-aislada)

> Documento público sanitizado: no contiene nombres de equipos, direcciones internas, usuarios de servicio, rutas de credenciales, claves, secretos, repositorios privados ni instrucciones específicas de acceso. Los detalles operativos están en un documento con acceso restringido.

## Objetivo

Preparar un respaldo consistente y cifrado del HomeLab antes de una eventual migración de Debian físico a Proxmox, preservando la posibilidad de restauración y reversión. El procedimiento base está descrito en [el runbook pre-Proxmox](pre-proxmox-backup-restore-runbook.md).

## Avances confirmados

- Inventario de **siete servicios Docker** y sus archivos Compose.
- Siete archivos Compose copiados a un área temporal restringida; comparados con los originales y validados con `docker compose config --quiet`.
- Referencias de imágenes Docker inventariadas. Las imágenes binarias **no** se exportaron.
- Copias transaccionales de tres bases SQLite mediante `.backup`, con `quick_check` en origen e `integrity_check` en destino: resultados satisfactorios.
- Preparación y comparación de archivos complementarios y configuración persistente de servicios.
- Repositorio remoto cifrado con Restic **inicializado** y acceso por SFTP verificado.
- Validación preliminar de resolución DNS interna y externa, previa a cualquier interrupción del servicio.

## Pendientes y bloqueantes

1. Aprobar una ventana de mantenimiento para copiar consistentemente los datos de DNS y administración de contenedores. **No se ha autorizado ni ejecutado una interrupción.**
2. Completar la captura consistente de todos los volúmenes, archivos complementarios, material PKI requerido y cambios locales fuera de Git.
3. Actualizar las copias de datos dinámicos antes de la captura final.
4. Crear el **primer snapshot Restic** en el destino externo. La consulta de snapshots confirmó que todavía no había ninguno.
5. Validar integridad del respaldo y realizar una **restauración aislada**, con evidencia funcional.
6. Diseñar y verificar automatización, retención, alertas y custodia de credenciales.

## Estado de cumplimiento

| Control | Estado |
|---|---|
| Inventario y Compose | Completado |
| Preparación de bases y configuraciones | Parcial, validaciones locales satisfactorias |
| Acceso a repositorio cifrado remoto | Validado |
| Captura completa consistente | Pendiente |
| Primer snapshot externo | No ejecutado |
| Restauración aislada | No ejecutada |
| Automatización y retención | Pendientes |

**Criterio de cierre:** no finalizar JAR-29 hasta contar con backup externo cifrado, controles de integridad, recuperación aislada probada, documentación y evidencias.

## Trazabilidad y separación de información

- **Público:** este registro de avance, el runbook y el ticket JAR-29.
- **Privado:** [Registro operativo de JAR-29 en Google Drive — acceso restringido](https://docs.google.com/document/d/1v3w5-dBuZbRmUnSN4thmWZ7FNlNT0CwzvS40exVq1hQ/edit). El enlace identifica el documento; **no concede acceso** a personas sin permisos de Drive. No copiar sus contenidos operativos a incidencias o repositorios públicos.
- **Reanudación:** paso 3.144, decisión sobre la ventana y autorización de una copia consistente del servicio DNS.

Última actualización documental: 2026-11-16. La fecha de corte técnico corresponde a la sesión registrada, no a una nueva ejecución.
