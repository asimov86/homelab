# ADR-003 — Estrategia de comunicación entre contenedores

## Estado

Aceptada

---

## Contexto

Durante la implementación de AdGuard Home, Nginx Proxy Manager y Uptime Kuma se observó una diferencia entre la resolución DNS utilizada por los clientes externos y la utilizada por los contenedores Docker.

Los clientes de la red utilizan AdGuard Home para resolver los dominios internos `*.jarvis.local`.

Sin embargo, los contenedores Docker utilizan el DNS interno provisto automáticamente por Docker para resolver el nombre de los servicios conectados a la misma red (`jarvis_network`).

Intentar utilizar dominios `*.jarvis.local` desde un contenedor produjo errores de resolución de nombres, mientras que utilizar el nombre del contenedor funcionó correctamente.

---

## Decisión

Se establece la siguiente regla de arquitectura para toda la plataforma Jarvis:

- La comunicación entre contenedores conectados a `jarvis_network` deberá realizarse, como regla general, mediante nombres de servicio resueltos por el DNS interno de Docker. Las excepciones deberán justificarse y documentarse.

Ejemplos:

```
http://homepage:3000
https://portainer:9443
http://vaultwarden:80
http://uptime-kuma:3001
http://adguard-home:3000
```

Los dominios:

```
*.jarvis.local
```

quedan reservados únicamente para el acceso desde clientes externos:

- PCs
- Notebooks
- Teléfonos móviles
- Tablets
- Navegadores

Estos dominios no deberán utilizarse para la comunicación entre contenedores.

---

## Justificación

Esta estrategia proporciona múltiples beneficios:

- Independencia de direcciones IP.
- Aprovechamiento del DNS interno de Docker.
- Mayor portabilidad de los servicios.
- Menor complejidad de configuración.
- Arquitectura desacoplada.
- Facilidad para escalar la plataforma.

---

## Consecuencias

### Positivas

- Los contenedores permanecen independientes de cambios de IP.
- La resolución de nombres es automática dentro de Docker.
- Los usuarios acceden siempre mediante dominios amigables.
- Nginx Proxy Manager continúa siendo el único punto de entrada de la plataforma.

### Consideraciones

Los servicios internos no podrán resolver dominios `*.jarvis.local` salvo que explícitamente se configure Docker para utilizar AdGuard Home como servidor DNS.

Esta configuración no forma parte de la arquitectura actual.

---

## Arquitectura

```text
                    Cliente
                        │
                        ▼
            homepage.jarvis.local
                        │
                        ▼
            Nginx Proxy Manager
                        │
─────────────────────────────────────────────
              jarvis_network
─────────────────────────────────────────────
        │                 │
        ▼                 ▼
 homepage:3000     adguard-home:3000
```

---

## Estado de implementación

- [x] Regla definida.
- [x] Aplicada en Nginx Proxy Manager.
- [x] Aplicada en Homepage.
- [x] Aplicada en Uptime Kuma.
