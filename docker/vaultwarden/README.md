# Vaultwarden

**Versión:** 1.0

**Estado:** Activo

**Autor:** Kenny Velandia

**Proyecto:** Jarvis HomeLab

**Última actualización:** Julio 2026

---

# Propósito

Vaultwarden es el gestor central de credenciales y secretos del HomeLab Jarvis.

Permite almacenar de forma segura contraseñas, notas seguras, identidades, tarjetas, tokens, API Keys y demás información sensible dentro de una infraestructura completamente administrada por el propio HomeLab.

---

# Alcance

Este documento describe la implementación de Vaultwarden dentro de la plataforma Jarvis.

No describe el funcionamiento interno de los siguientes estándares, ya que cada uno posee su propia documentación oficial:

- Jarvis Deployment Standard (JDS)
- Jarvis Backup Standard (JBS)
- PKI Standard
- Security Architecture

---

# ¿Qué es?

Vaultwarden es una implementación alternativa, liviana y compatible con los clientes oficiales de Bitwarden.

Permite alojar en infraestructura propia una bóveda de credenciales, contraseñas, notas seguras, tarjetas, identidades y otros secretos.

---

# ¿Por qué lo elegimos?

Vaultwarden fue seleccionado porque:

- Es compatible con los clientes oficiales de Bitwarden.
- Consume considerablemente menos recursos que el servidor oficial.
- Está diseñado para entornos Self-Hosted y HomeLab.
- Permite mantener toda la información sensible dentro de la infraestructura propia.
- Se integra naturalmente con Docker y Reverse Proxy.
- Constituye un servicio transversal para el resto de la plataforma Jarvis.

---

# Objetivo dentro del HomeLab

Vaultwarden será el repositorio central de credenciales utilizado por toda la plataforma.

Entre la información almacenada se incluyen:

- Contraseñas.
- Credenciales administrativas.
- Tokens.
- API Keys.
- Notas seguras.
- Identidades.
- Credenciales de futuros servicios.
- Secretos utilizados por la infraestructura.

---

# Arquitectura del servicio

```text
             Cliente / Navegador / App Bitwarden
                           │
                           ▼
            https://vaultwarden.jarvis.local
                           │
                           ▼
                Nginx Proxy Manager
                 Terminación TLS/HTTPS
                           │
                           ▼
                    jarvis_network
                           │
                           ▼
                Vaultwarden :80 (HTTP)
                           │
                           ▼
                     Docker Volume
                           │
            ┌──────────────┼──────────────┐
            ▼              ▼              ▼
         SQLite       Adjuntos      Configuración
                           │
                           ▼
                Jarvis Backup Standard
```

Todo el tráfico externo utiliza HTTPS.

Dentro de Docker la comunicación permanece en HTTP sobre la red privada `jarvis_network`.

---

# Imagen

```text
vaultwarden/server:latest
```

---

# Acceso

| Parámetro | Valor |
|-----------|-------|
| Protocolo | HTTPS |
| Dominio | `vaultwarden.jarvis.local` |
| Puerto interno | `80` |
| Red Docker | `jarvis_network` |

---

# Persistencia

Vaultwarden almacena toda su información en:

```text
/data
```

La persistencia se realiza mediante el volumen Docker:

```text
vaultwarden_vaultwarden_data
```

En dicho volumen se almacenan:

- Base de datos SQLite.
- Configuración.
- Adjuntos.
- Claves criptográficas.
- Información de usuarios.
- Organizaciones.

La eliminación del contenedor no elimina el volumen.

---

# Seguridad

Vaultwarden administra uno de los activos más sensibles de Jarvis.

Por ello se aplican las siguientes medidas:

- HTTPS obligatorio.
- Terminación TLS exclusivamente mediante Nginx Proxy Manager.
- Sin publicación directa de puertos al host.
- Certificado emitido por la PKI interna (Jarvis Root CA).
- Registro público deshabilitado después de crear el primer usuario.
- Persistencia mediante volumen Docker.
- Backups automáticos diarios.
- Restauraciones verificadas.
- Exclusión de claves privadas mediante `.gitignore`.

> La contraseña maestra nunca debe almacenarse únicamente dentro del propio Vaultwarden.

---

# Decisiones técnicas

## Reverse Proxy

Vaultwarden nunca publica puertos directamente hacia la LAN.

Docker utiliza:

```yaml
expose:
  - "80"
```

Toda la publicación HTTPS es responsabilidad de Nginx Proxy Manager.

---

## HTTPS obligatorio

Vaultwarden requiere un contexto seguro para utilizar correctamente las funciones criptográficas del navegador.

Por este motivo HTTPS forma parte del diseño del servicio y no constituye una característica opcional.

---

## Persistencia

Los datos se almacenan en un volumen Docker administrado porque:

- permanecen desacoplados del ciclo de vida del contenedor;
- no requieren edición manual;
- pueden respaldarse mediante JBS;
- facilitan futuras restauraciones.

---

## Registro inicial

Durante la instalación inicial se permitió crear el primer usuario.

Posteriormente se estableció:

```text
SIGNUPS_ALLOWED=false
```

para impedir registros abiertos.

---

## Política de reinicio

Se utiliza:

```yaml
restart: unless-stopped
```

garantizando el reinicio automático después de reiniciar el servidor.

---

# Implementación de estándares

Vaultwarden implementa los siguientes estándares oficiales de Jarvis:

- Jarvis Deployment Standard (JDS)
- Jarvis Backup Standard (JBS)
- PKI Standard
- Security Architecture

Cada estándar posee su propia documentación y evolución independiente.

---

# Relación con otros servicios

## Depende de

- Docker Engine
- jarvis_network
- Nginx Proxy Manager
- Homepage
- PKI interna
- Jarvis Backup Standard

---

## Será accesible desde

- Navegadores.
- Clientes oficiales de Bitwarden.
- Homepage.

---

## Será monitoreado por

- Uptime Kuma.

---

## Sus logs serán visibles desde

- Dozzle.

---

# Operación

## Iniciar el servicio

```bash
docker compose up -d
```

---

## Estado

```bash
docker ps
```

---

## Logs

```bash
docker logs vaultwarden
```

---

## Backup manual

```bash
./backups/scripts/backup-service.sh vaultwarden
```

---

## Restauración de prueba

```bash
./backups/scripts/restore-service.sh --test vaultwarden <backup>
```

---

# Estado de implementación

- [x] Servicio desplegado.
- [x] Persistencia configurada.
- [x] Conectividad interna validada.
- [x] Proxy Host configurado.
- [x] HTTPS configurado.
- [x] Primer usuario creado.
- [x] Registro público deshabilitado.
- [x] Integración con Homepage.
- [ ] Monitoreo con Uptime Kuma.
- [ ] Visualización mediante Dozzle.
- [x] Backup automático.
- [x] Restauración validada.
- [x] Automatización mediante systemd.

---

# Lessons Learned

- La terminación TLS debe realizarse exclusivamente en Nginx Proxy Manager.
- Un volumen Docker desacopla correctamente los datos del ciclo de vida del contenedor.
- Un backup no puede considerarse confiable hasta validar una restauración.
- Systemd ofrece una integración más robusta que cron para automatizar tareas del HomeLab.
- La documentación debe seguir los mismos principios de arquitectura utilizados para el desarrollo del software.

---

# Historial

| Versión | Fecha | Descripción |
|----------|-------|-------------|
| 1.0 | Julio 2026 | Primera versión oficial de Vaultwarden integrada a la plataforma Jarvis, incluyendo HTTPS, PKI, Homepage, JBS y automatización mediante systemd. |
