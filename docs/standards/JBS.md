# Jarvis Backup Standard (JBS)

**Versión:** 1.0

**Estado:** Activo

**Autor:** Kenny Velandia

**Proyecto:** Jarvis HomeLab

**Última actualización:** Julio 2026

---

# Propósito

El Jarvis Backup Standard (JBS) define la estrategia oficial de respaldo y recuperación utilizada por todos los servicios de la plataforma Jarvis.

Su objetivo es garantizar la integridad, disponibilidad y recuperabilidad de la información almacenada en la infraestructura.

---

# Alcance

Este estándar aplica a todos los servicios que administren información persistente.

Cada servicio deberá implementar JBS mediante su correspondiente archivo de configuración.

---

# Principios

## 1. La arquitectura precede a la implementación

Antes de desplegar un servicio deberá definirse su estrategia de backup.

---

## 2. Todo backup debe poder restaurarse

Un archivo de backup no constituye una garantía.

La garantía existe únicamente cuando la restauración ha sido validada.

---

## 3. Automatización

Todos los backups deberán ejecutarse automáticamente.

No dependerán de tareas manuales.

---

## 4. Integridad verificable

Todo backup deberá validarse mediante:

- SHA-256
- Integridad Zstandard
- Validación TAR

---

## 5. Recuperación controlada

Las restauraciones deberán realizarse siguiendo procedimientos documentados.

---

# Arquitectura

```text
Servicio
     │
     ▼
Volumen Docker
     │
     ▼
Backup Engine
     │
     ▼
Compresión
     │
     ▼
Checksum
     │
     ▼
Validación
     │
     ▼
Retención
     │
     ▼
Restore Test
```

---

# Componentes

El framework JBS está compuesto por:

## Librerías

- logger.sh
- compression.sh
- checksum.sh
- retention.sh

---

## Scripts

- backup-service.sh
- restore-service.sh
- validate-backup.sh

---

## Configuración

Cada servicio posee un archivo propio:

```text
backups/config/<servicio>.conf
```

---

# Flujo de backup

1. Leer configuración.
2. Validar dependencias.
3. Validar Docker.
4. Detener servicio.
5. Crear backup.
6. Reiniciar servicio.
7. Generar checksum.
8. Validar backup.
9. Aplicar retención.

---

# Flujo de restauración

1. Validar backup.
2. Restaurar sobre volumen temporal o productivo.
3. Verificar archivos esenciales.
4. Reiniciar servicio.
5. Confirmar operación.

---

# Retención

La política de retención es configurable por servicio.

Actualmente JBS soporta:

- Daily
- Weekly
- Monthly

---

# Automatización

La ejecución automática se realiza mediante systemd.

Componentes:

- jbs-backup@.service
- jbs-backup@.timer

---

# Configuración por servicio

Cada servicio define:

- contenedor;
- volumen;
- nivel de criticidad;
- RPO;
- RTO;
- política de retención;
- horario;
- frecuencia de pruebas.

---

# Principios de diseño

JBS fue construido siguiendo:

- DRY (Don't Repeat Yourself)
- Configuración por servicio
- Framework reutilizable
- Librerías independientes
- Logging uniforme
- Validación obligatoria
- Recuperación comprobable

---

# Relación con otros estándares

JBS complementa:

- JDS
- PKI Standard
- Security Architecture

---

# Historial

| Versión | Fecha | Descripción |
|----------|-------|-------------|
| 1.0 | Julio 2026 | Primera versión oficial del Jarvis Backup Standard. |
