# JAR-29 — Validación del respaldo programado

**Fecha:** 23 de noviembre de 2026  
**Estado:** respaldo programado y presencia del snapshot en ambos destinos verificados. JAR-29 sigue en progreso.

## Resultado

- La tarea programada verificó la copia intermedia y terminó correctamente. Restic procesó 51 archivos y guardó un snapshot nuevo.
- En Windows se comprobó que el identificador completo de ese snapshot coincidía en el repositorio principal y en la copia protegida en otro disco físico.
- La restauración aislada previa utilizó otro snapshot. La comprobación de este ciclo verificó la presencia del nuevo snapshot en ambos destinos. La tarea de copia protegida de Windows se ejecutó a las 07:00:01 y terminó con código `0`.

## Pendientes

- Confirmar que la credencial de recuperación esté disponible con el servidor fuera de servicio.
- Definir cómo conservar el punto de restauración validado durante la migración. Mantener la retención en simulación hasta resolverlo.
- Implementar y probar la retención, la verificación periódica y los avisos por fallos o ausencia de un snapshot nuevo.
- Revisar el SMART extendido del disco original y completar las comprobaciones previas a la ventana de migración.

[Registro del 12 de noviembre](JAR-29_backup_restore_avance_2026-11-12.md) · [Runbook de respaldo y restauración](pre-proxmox-backup-restore-runbook.md) · [Checklist de migración](pre-proxmox-checklist.md)
