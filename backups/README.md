# Respaldos y recuperación

## Jarvis

Un envío real cifrado y firmado a la bandeja SFTP de Windows se completó manualmente. También se comprobó el acceso a la copia aislada de Vaultwarden tras corregir el acceso por HTTPS. El 26 de noviembre de 2026 se confirmó la programación del envío diario a las **20:00 de Buenos Aires**. La importación en Windows quedó acordada cada **8 horas**, con una retención de **7 diarios, 4 semanales y 6 mensuales**.

1. Después de las 20:00, comprobar el resultado de `jarvis-daily-backup.service` y confirmar la llegada del respaldo a Windows.
2. Después de la siguiente ejecución del importador, comprobar que el respaldo nuevo aparece en los snapshots de Restic.

Estas dos verificaciones del nuevo horario siguen pendientes al cierre de esta revisión.

## TrueNAS

Los datasets `datos/Personal`, `datos/Compartido` y `datos/Fotos` tienen tareas de snapshots diarias a las **02:00 de Buenos Aires**, con **14 días de retención**. Tras la primera ejecución, comprobar un snapshot `auto-` nuevo en cada dataset. Los snapshots residen en el mismo pool `datos` y una pérdida del disco también los afectaría.

[Guía de restauración](docs/restore-guide.md) · [Política de retención](docs/retention-policy.md)
