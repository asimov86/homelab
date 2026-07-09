# Dozzle

## ¿Qué es?

Dozzle es una herramienta web liviana para visualizar logs de contenedores Docker en tiempo real.

Permite consultar los logs de los servicios del HomeLab desde una interfaz web, sin necesidad de ejecutar manualmente `docker logs` para cada contenedor.

---

## ¿Por qué lo elegimos?

Se eligió Dozzle porque:

- Permite visualizar logs de contenedores Docker en tiempo real.
- Es liviano y simple de desplegar.
- No requiere una base de datos externa.
- Complementa a Uptime Kuma y Portainer.
- Facilita el diagnóstico de errores en servicios del HomeLab.

---

## Objetivo dentro del HomeLab

Dozzle será la herramienta principal para visualizar logs de los contenedores de **Jarvis**.

Su rol dentro de la plataforma será ayudar en tareas de operación, troubleshooting y observabilidad básica.

---

## Arquitectura

```text
Cliente
   │
   ▼
dozzle.jarvis.local
   │
   ▼
Nginx Proxy Manager
   │
   ▼
jarvis_network
   │
   ▼
Dozzle
   │
   ▼
Docker Socket
   │
   ▼
Logs de contenedores
```

--

## Seguridad

Dozzle necesita acceso al socket de Docker:

/var/run/docker.sock

Este acceso le permite consultar contenedores y leer logs.

Para reducir privilegios, el socket se monta en modo solo lectura:

/var/run/docker.sock:/var/run/docker.sock:ro
