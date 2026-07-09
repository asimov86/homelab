# Nginx Proxy Manager

## ¿Qué es?

Nginx Proxy Manager es una interfaz web para administrar Nginx como reverse proxy.

Permite publicar múltiples servicios internos utilizando nombres de host, HTTPS y certificados TLS, sin tener que recordar puertos individuales para cada aplicación.

---

## ¿Por qué lo elegimos?

Se eligió Nginx Proxy Manager porque:

- Facilita la administración de reglas de reverse proxy mediante interfaz web.
- Permite centralizar el acceso a los servicios del HomeLab.
- Simplifica la gestión de certificados HTTPS.
- Es ampliamente utilizado en entornos HomeLab.
- Permite aprender reverse proxy, host headers, DNS y TLS de forma práctica.

---

## Objetivo dentro del HomeLab

Nginx Proxy Manager será el punto de entrada HTTP/HTTPS para los servicios de Jarvis.

Permitirá pasar de accesos por IP y puerto:

```text
http://192.168.0.24:3000

https://homepage.jarvis.local
