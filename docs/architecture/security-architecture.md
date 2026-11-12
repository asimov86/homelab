# Security Architecture

**Versión:** 1.0

**Estado:** Activo

**Autor:** Kenny Velandia

**Proyecto:** Jarvis HomeLab

**Última actualización:** Julio 2026

---

# Propósito

Este documento define la arquitectura de seguridad de la plataforma Jarvis.

Su objetivo es establecer los principios, componentes y decisiones que protegen la infraestructura, independientemente de los servicios desplegados.

No describe configuraciones particulares de un servicio específico.

---

# Alcance

Esta arquitectura aplica a toda la plataforma Jarvis.

Todo nuevo servicio incorporado deberá respetar los principios definidos en este documento.

---

# Principios de seguridad

La seguridad en Jarvis se basa en los siguientes principios.

## 1. La arquitectura precede a la implementación

Ningún servicio será desplegado sin definir previamente cómo será protegido.

---

## 2. Seguridad por defecto

Toda nueva implementación debe comenzar desde una configuración segura.

Las excepciones deberán estar justificadas y documentadas.

---

## 3. Menor superficie de ataque

Cada servicio expondrá únicamente los recursos estrictamente necesarios.

---

## 4. Mínimo privilegio

Cada componente tendrá únicamente los permisos necesarios para cumplir su función.

---

## 5. Defensa en profundidad

La protección de Jarvis no depende de un único mecanismo.

La seguridad se obtiene mediante múltiples capas independientes.

---

## 6. Recuperación garantizada

Todo dato importante debe poder recuperarse mediante un procedimiento documentado y previamente validado.

---

# Capas de seguridad

La plataforma se protege mediante varias capas.

```text
Usuarios
      │
      ▼
HTTPS
      │
      ▼
Reverse Proxy
      │
      ▼
Docker Network
      │
      ▼
Servicio
      │
      ▼
Persistencia
      │
      ▼
Backup
      │
      ▼
Restore Test
```

Cada capa reduce el impacto de una posible falla en otra capa.

---

# PKI interna

Jarvis utiliza una infraestructura de clave pública propia.

Componentes:

- Jarvis Root CA.
- Certificados por servicio.
- Claves privadas.
- Certificados confiados por los clientes.

Todos los certificados internos son emitidos por la Root CA de Jarvis.

---

# HTTPS

Todo acceso de usuarios a los servicios debe realizarse mediante HTTPS.

La terminación TLS se realiza exclusivamente en:

```text
Nginx Proxy Manager
```

Los servicios Docker no publican directamente certificados.

---

# Reverse Proxy

Nginx Proxy Manager constituye el único punto de entrada HTTP/HTTPS de la plataforma.

Funciones:

- Terminación TLS.
- Gestión de certificados.
- Publicación de servicios.
- Encaminamiento interno.

---

# Red Docker

Los servicios se comunican mediante redes Docker privadas.

No se publican puertos innecesarios hacia el host.

Siempre que sea posible se utilizará:

```yaml
expose:
```

en lugar de:

```yaml
ports:
```

---

## Comunicación entre contenedores

Jarvis adopta una arquitectura de doble resolución DNS.

### DNS interno de Docker

Utilizado por los contenedores conectados a la misma red Docker para resolver nombres de servicio.

Ejemplos:

- homepage
- portainer
- adguard-home
- uptime-kuma

### DNS de infraestructura

Administrado por AdGuard Home.

Utilizado por los clientes de la LAN para resolver dominios internos `*.jarvis.local`.

Ejemplos:

- homepage.jarvis.local
- vaultwarden.jarvis.local
- adguard.jarvis.local

Esta separación constituye la regla general de arquitectura. Las excepciones deberán justificarse y documentarse según ADR-003.


---

# Persistencia

Los datos persistentes se almacenan mediante volúmenes Docker.

Esto permite:

- desacoplar datos y contenedores;
- facilitar backups;
- simplificar restauraciones.

---

# Protección de secretos

Los siguientes elementos nunca forman parte del repositorio Git:

- claves privadas;
- CSR;
- certificados temporales;
- secretos;
- credenciales.

La protección se realiza mediante:

- `.gitignore`;
- permisos Linux;
- almacenamiento local.

---

# Backup y recuperación

Todos los servicios críticos implementan el Jarvis Backup Standard.

Los principios son:

- backups automáticos;
- validación mediante checksum;
- validación de integridad;
- restauraciones de prueba;
- retención;
- automatización.

Un backup no puede considerarse válido hasta haber demostrado una restauración satisfactoria.

---

# Registro y auditoría

Las operaciones relevantes deben generar registros suficientes para permitir el análisis posterior de incidentes.

Actualmente Jarvis utiliza:

- logs Docker;
- journalctl para tareas automatizadas mediante systemd.

---

# Dependencias

La arquitectura de seguridad se apoya en:

- PKI Standard
- Jarvis Backup Standard
- Jarvis Deployment Standard

---

# Relación con otros documentos

Esta arquitectura complementa:

- JDS
- JBS
- PKI Standard
- Documentación de cada servicio

---

# Estado de implementación

**Revisión:** noviembre de 2026

Esta sección distingue los principios y objetivos de la arquitectura
de las capacidades efectivamente verificadas en Jarvis.

| Componente | Estado | Observaciones |
|---|---|---|
| Docker y jarvis_network | Implementado | Red compartida y resolución interna por nombres de servicio. |
| AdGuard Home | Implementado | Resolución DNS para clientes de la LAN. |
| Nginx Proxy Manager | Implementado | Reverse proxy con hosts configurados. |
| PKI interna | Parcial | Root CA disponible; distribución de confianza pendiente. |
| HTTPS | Parcial | Existen accesos HTTP; TLS no está generalizado. |
| Backups automáticos | Planificado | Pendiente de implementación y restauración validada. |
| Proxmox | Planificado | Migración aún no ejecutada. |

Las secciones anteriores describen principios y estándares objetivo.
Su presencia en este documento no implica que todas las capacidades
se encuentren implementadas.

Para las decisiones de comunicación entre contenedores, consultar
`docs/decisions/ADR-003-container-communication.md`.

---

# Historial

| Versión | Fecha | Descripción |
|----------|-------|-------------|
| 1.0 | Julio 2026 | Primera arquitectura oficial de seguridad de la plataforma Jarvis. |
