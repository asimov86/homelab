# Vaultwarden

## ¿Qué es?

Vaultwarden es una implementación alternativa, liviana y compatible con los clientes de Bitwarden.

Permite alojar en infraestructura propia una bóveda de credenciales, contraseñas, notas seguras, tarjetas, identidades y otros secretos.

---

## ¿Por qué lo elegimos?

Se eligió Vaultwarden porque:

- Es compatible con los clientes oficiales de Bitwarden.
- Consume menos recursos que el servidor oficial de Bitwarden.
- Está pensado para entornos self-hosted y HomeLab.
- Permite mantener las credenciales dentro de la infraestructura propia.
- Se integra correctamente con Docker y Reverse Proxy.
- Agrega una capacidad transversal de gestión segura de credenciales para los futuros servicios de Jarvis.

---

## Objetivo dentro del HomeLab

Vaultwarden será el gestor central de credenciales y secretos personales utilizados en Jarvis.

Permitirá almacenar de forma organizada:

- Contraseñas.
- Credenciales de aplicaciones.
- Tokens.
- API keys.
- Notas seguras.
- Accesos administrativos.
- Credenciales de servicios futuros.

---

## Arquitectura del servicio

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
       Vaultwarden:80 (HTTP interno)
                │
                ▼
              /data
                │
      ┌─────────┼──────────┐
      ▼         ▼          ▼
   SQLite   Adjuntos   Configuración
```

El tráfico entre el navegador y Nginx Proxy Manager utilizará HTTPS.

Dentro de la red Docker, Nginx Proxy Manager se comunicará con Vaultwarden mediante HTTP en el puerto interno 80.

---

## Imagen

```text
vaultwarden/server:latest
```

La imagen es mantenida por el proyecto Vaultwarden y es compatible con múltiples arquitecturas.

---

## Acceso previsto

| Parámetro | Valor |
|-----------|-------|
| Protocolo externo | HTTPS |
| Dominio | `vaultwarden.jarvis.local` |
| Puerto interno | `80` |
| Red Docker | `jarvis_network` |

---

## Persistencia

Vaultwarden almacena sus datos en:

```text
/data
```

Se utilizará un volumen Docker administrado:

```text
vaultwarden_data
```

Dentro de este volumen se almacenarán, entre otros:

- Base de datos SQLite.
- Configuración interna.
- Adjuntos.
- Claves generadas por la aplicación.
- Datos de usuarios y organizaciones.

La eliminación del contenedor no elimina el volumen.

---

## Seguridad

Vaultwarden administra información altamente sensible.

Por esta razón se aplicarán las siguientes medidas:

- Acceso únicamente mediante HTTPS.
- Publicación exclusiva detrás de Nginx Proxy Manager.
- Sin exposición directa de puertos hacia el host.
- Registro de usuarios deshabilitado después de crear la cuenta inicial.
- Backups periódicos del volumen.
- Contraseña maestra robusta.
- Revisión cuidadosa antes de habilitar acceso remoto.

> La contraseña maestra no debe almacenarse dentro del mismo Vaultwarden como único respaldo.

---

## Decisiones técnicas

### Reverse Proxy

Vaultwarden no publicará directamente su puerto hacia la LAN.

Se utilizará:

```yaml
expose:
  - "80"
```

Nginx Proxy Manager será el único punto de entrada.

---

### HTTPS obligatorio

La bóveda web requiere un contexto seguro para utilizar las funciones criptográficas del navegador.

Por este motivo, Vaultwarden será el primer servicio de Jarvis cuyo despliegue no se considerará completo hasta tener HTTPS configurado.

---

### Persistencia mediante volumen Docker

Se utiliza un volumen Docker porque los datos internos de Vaultwarden:

- No se editarán manualmente.
- Deben permanecer desacoplados del contenedor.
- Deben incluirse en una futura estrategia de backup y recuperación.

---

### Registro inicial

Durante la configuración inicial se permitirá la creación del primer usuario.

Una vez creado, se configurará:

```text
SIGNUPS_ALLOWED=false
```

para impedir nuevos registros abiertos.

---

### Política de reinicio

Se utilizará:

```yaml
restart: unless-stopped
```

El servicio se iniciará automáticamente después de reinicios del servidor, salvo que haya sido detenido manualmente.

---

## Relación con otros servicios

### Depende de

- Docker Engine.
- `jarvis_network`.
- Nginx Proxy Manager.
- Resolución local del dominio.
- HTTPS válido o confiable para los clientes.

### Será accesible desde

- Navegadores.
- Clientes oficiales de Bitwarden.
- Homepage.

### Será monitoreado por

- Uptime Kuma.

### Sus logs serán visibles desde

- Dozzle.

---

## Estado

- [ ] Servicio desplegado.
- [ ] Persistencia configurada.
- [ ] Conectividad interna validada.
- [ ] Proxy Host configurado.
- [ ] HTTPS configurado.
- [ ] Primer usuario creado.
- [ ] Registro público deshabilitado.
- [ ] Integración con Homepage.
- [ ] Monitoreo con Uptime Kuma.
- [ ] Backup documentado.
- [ ] Recuperación documentada.

---

## Lessons Learned

Pendiente.

Esta sección se completará durante la implementación y validación del servicio.

---

## Historial

| Fecha | Descripción |
|-------|-------------|
| Julio 2026 | Inicio de la implementación de Vaultwarden. |
