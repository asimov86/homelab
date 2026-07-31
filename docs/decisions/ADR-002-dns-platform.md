# ADR-002 — Plataforma DNS de Jarvis

## Estado

Aceptada

---

## Contexto

A medida que Jarvis evoluciona como plataforma de infraestructura, se requiere un servicio DNS centralizado que permita:

- Resolver dominios internos (`*.jarvis.local`).
- Centralizar la resolución DNS de todos los dispositivos de la red.
- Integrarse con el router Omada mediante DHCP.
- Reenviar consultas externas hacia servidores DNS públicos.
- Incorporar capacidades adicionales de seguridad y observabilidad.

Hasta el momento, la resolución de nombres internos depende del archivo `hosts` de cada equipo, lo que dificulta el mantenimiento y la escalabilidad.

---

## Decisión

Jarvis utilizará **AdGuard Home** como plataforma oficial de DNS para la infraestructura.

El servicio será desplegado como un contenedor Docker y formará parte de la plataforma principal de Jarvis.

---

## Justificación

Se selecciona AdGuard Home por las siguientes razones:

- Administración sencilla mediante interfaz web.
- Resolución de dominios internos.
- Forwarding automático hacia DNS públicos.
- Estadísticas detalladas de consultas.
- Integración con Docker.
- Compatibilidad con futuras listas de bloqueo.
- Capacidad para agregar una capa adicional de seguridad mediante filtrado DNS.
- Fácil integración con el router Omada.

---

## Consecuencias

### Positivas

- Eliminación del uso manual del archivo `hosts`.
- Resolución centralizada para toda la red.
- Mejor experiencia para nuevos dispositivos.
- Mayor visibilidad del tráfico DNS.
- Base para futuras políticas de seguridad.

### Consideraciones

Si Jarvis deja de estar disponible, el servicio DNS también dejará de responder.

Por este motivo se evaluarán estrategias de alta disponibilidad o DNS de respaldo en futuras versiones de la plataforma.

---

## Arquitectura

```text
                 Internet
                     │
                     ▼
                Router ISP
                     │
                     ▼
              TP-Link Omada
                 (DHCP)
                     │
          Entrega DNS = Jarvis
                     │
                     ▼
             AdGuard Home
                     │
        ┌────────────┴────────────┐
        ▼                         ▼
 *.jarvis.local           Dominios públicos
        │                         │
        ▼                         ▼
 Respuesta local        Cloudflare / Quad9
```

---

## Estado de implementación

- [x] Decisión arquitectónica tomada.
- [x] Servicio desplegado.
- [x] Integración con Docker.
- [x] Integración con Omada (DHCP entregando AdGuard como DNS).
- [x] Migración de dominios internos (`*.jarvis.local`).
- [x] Validación completa de la resolución DNS interna.
