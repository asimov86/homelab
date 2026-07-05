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

### Etapa 1 - Base del servidor

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

### Etapa 2 - Primeros servicios Docker

- [ ] Desplegar Portainer
- [ ] Documentar Portainer
- [ ] Desplegar Uptime Kuma
- [ ] Documentar Uptime Kuma

### Etapa 3 - Red y acceso

- [ ] Definir estrategia de red
- [ ] Configurar proxy reverso
- [ ] Definir acceso interno/externo
- [ ] Evaluar VPN

### Etapa 4 - NAS y almacenamiento

- [ ] Definir arquitectura NAS
- [ ] Definir discos de datos
- [ ] Configurar compartidos
- [ ] Diseñar estrategia de backups

### Etapa 5 - Servicios personales

- [ ] Desplegar Vaultwarden
- [ ] Desplegar Nextcloud
- [ ] Desplegar Immich
- [ ] Desplegar Paperless

### Etapa 6 - Virtualización

- [ ] Evaluar migración a Proxmox
- [ ] Diseñar arquitectura VM Docker
- [ ] Diseñar arquitectura NAS virtualizada
- [ ] Crear laboratorio Windows Server

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
