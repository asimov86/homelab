# Security

## Objetivo

El directorio **security** concentra toda la documentación, herramientas y configuraciones relacionadas con la seguridad del HomeLab.

La seguridad se considera un componente transversal de la plataforma y no un servicio aislado.

A medida que el HomeLab evolucione, este directorio centralizará la infraestructura de seguridad, la documentación y los procedimientos asociados.

---

## Filosofía

La seguridad de Jarvis se basa en los siguientes principios:

- Seguridad por diseño (Security by Design).
- Mínimo privilegio.
- Infraestructura reproducible.
- Documentación completa.
- Automatización cuando sea posible.
- Gestión segura de credenciales.
- Cifrado de las comunicaciones.
- Versionado únicamente de configuraciones y documentación, nunca de secretos.

---

## Componentes

Actualmente este directorio incluye:

```text
security/

├── pki/
```

En futuras etapas se incorporarán componentes como:

```text
security/

├── pki/
├── vaultwarden/
├── ssh/
├── firewall/
├── wireguard/
├── hardening/
└── secrets/
```

---

## Objetivos futuros

La arquitectura de seguridad contemplará, entre otros aspectos:

- PKI interna.
- HTTPS para todos los servicios.
- Gestión centralizada de credenciales mediante Vaultwarden.
- Hardening del servidor Debian.
- Firewall.
- Acceso remoto seguro mediante VPN.
- Gestión de certificados.
- Políticas de backup y recuperación.

---

## Relación con la documentación

Este directorio complementa la documentación general ubicada en:

```text
docs/
```

En particular:

- architecture.md
- networking.md
- security-architecture.md (futuro)

---

## Estado

- [x] Estructura inicial creada.
- [ ] PKI implementada.
- [ ] Vaultwarden integrado.
- [ ] HTTPS para todos los servicios.
- [ ] Arquitectura de seguridad documentada.

---

## Historial

| Fecha | Descripción |
|--------|-------------|
| Julio 2026 | Creación del dominio Security dentro del HomeLab. |
