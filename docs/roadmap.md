# Roadmap HomeLab

Este roadmap registra dos dimensiones del proyecto:

1. Lo que construimos.
2. Lo que aprendemos.

## Filosofía del proyecto

- No crear carpetas vacías “por las dudas”.
- Crear cada carpeta cuando nazca un servicio real.
- Cada servicio tendrá su propia documentación.
- Cada servicio tendrá su propio `compose.yaml`.
- Cada servicio tendrá su propio commit.
- Mantener un historial de Git claro y fácil de leer.
- Documentar tanto la infraestructura construida como los conceptos aprendidos.

## Construcción de infraestructura

### Etapa 1 - Base del servidor original

- [x] Instalar Debian 12
- [x] Configurar acceso SSH
- [x] Instalar Docker Engine
- [x] Configurar permisos de Docker para el usuario
- [x] Verificar Docker Compose
- [x] Instalar y configurar Git
- [x] Configurar conexión SSH con GitHub
- [x] Crear repositorio GitHub
- [x] Crear estructura inicial del proyecto
- [x] Agregar `.gitignore`

### Etapa 2 - Servicios base del HomeLab

- [x] Desplegar Homepage
- [x] Desplegar Portainer
- [x] Desplegar Vaultwarden
- [x] Desplegar Uptime Kuma
- [x] Desplegar Dozzle

### Etapa 3 - Infraestructura de red

- [x] Diseñar la arquitectura de red
- [x] Incorporar TP-Link Omada ER605
- [x] Configurar nueva subred
- [x] Configurar DHCP centralizado
- [x] Implementar AdGuard Home
- [x] Configurar DNS interno
- [x] Implementar Nginx Proxy Manager
- [x] Crear `jarvis_network`
- [x] Documentar la migración

### Etapa 4 - NAS y almacenamiento

- [x] Desplegar TrueNAS en la VM 101 y crear el pool ZFS `datos` sobre el HDD de 8 TB.
- [x] Configurar compartidos SMB y tareas diarias de snapshots.
- [ ] Comprobar la primera ejecución automática de snapshots.
- [ ] Agregar un segundo disco para redundancia, tentativamente en junio de 2027.

### Etapa 5 - Servicios personales

- [x] Desplegar el piloto de PiGallery2.
- [ ] Instalar el AP Omada y probar HTTPS, PhotoSync y etiquetas de personas con digiKam desde el piloto.
- [ ] Evaluar Immich tras ampliar el host a 32 GiB de RAM.
- [ ] Desplegar Nextcloud.
- [ ] Desplegar Paperless.

### Etapa 6 - Virtualización

- [x] Migrar Jarvis a Proxmox (VM 100, Debian 13).
- [x] Desplegar el NAS virtualizado (VM 101, TrueNAS).
- [ ] Crear laboratorio Windows Server.

## Conceptos aprendidos

### Linux

- [x] Directorios y rutas básicas
- [x] Uso de `sudo`
- [x] Usuarios y grupos
- [x] Permisos básicos
- [x] Uso de `newgrp`
- [x] Comandos básicos: `ls`, `cd`, `mkdir`, `cat`, `pwd`

### SSH

- [x] Acceso remoto por SSH
- [x] Claves públicas y privadas
- [x] Archivo `authorized_keys`
- [x] Autenticación SSH con GitHub

### Git y GitHub

- [x] Configuración de identidad Git
- [x] Repositorio local
- [x] Repositorio remoto
- [x] Rama `main`
- [x] `git status`
- [x] `git add`
- [x] `git commit`
- [x] `git push`
- [x] Uso de `.gitignore`

### Docker

- [x] Docker Engine
- [x] Docker Compose
- [x] Imágenes
- [x] Contenedores
- [x] Volúmenes
- [x] Redes
- [ ] `compose.yaml`
- [ ] Variables de entorno
- [ ] Logs
- [ ] Actualización de contenedores

### Infraestructura

- [ ] Reverse proxy
- [ ] DNS
- [ ] Certificados TLS
- [ ] Backups
- [ ] NAS
- [ ] Monitoreo
- [ ] Virtualización
