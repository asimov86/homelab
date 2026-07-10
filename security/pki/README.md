# Public Key Infrastructure (PKI)

## ¿Qué es una PKI?

Una **Public Key Infrastructure (PKI)** es una infraestructura que permite emitir, administrar y validar certificados digitales.

Su objetivo principal es garantizar la identidad de los servicios y permitir comunicaciones seguras mediante TLS/HTTPS.

En Jarvis construiremos una PKI propia para la red interna del HomeLab.

---

## Objetivo

La PKI permitirá emitir certificados para todos los servicios internos de Jarvis utilizando una Autoridad Certificadora (CA) propia.

Esto permitirá acceder mediante HTTPS sin advertencias del navegador una vez instalada la CA raíz en los equipos clientes.

---

## Arquitectura

```text
                 Jarvis Root CA
                        │
        ┌───────────────┼────────────────┐
        ▼               ▼                ▼
 Homepage          Vaultwarden      Nextcloud
        ▼               ▼                ▼
 Certificado     Certificado      Certificado
        │               │                │
        └───────────────┴────────────────┘
               Firmados por
                Jarvis Root CA
```

---

## Estructura

```text
pki/

├── README.md
├── root-ca/
├── certs/
├── private/
├── csr/
├── scripts/
└── docs/
```

---

## Descripción de cada directorio

### root-ca/

Contendrá la Autoridad Certificadora raíz.

Aquí residirá la identidad principal de la PKI.

---

### certs/

Almacenará los certificados emitidos para los distintos servicios.

---

### private/

Contendrá las claves privadas.

Estas claves son el activo más sensible de toda la infraestructura.

Nunca deberán versionarse en Git.

---

### csr/

Solicitudes de firma de certificados (Certificate Signing Requests).

---

### scripts/

Scripts utilizados para automatizar la creación de certificados.

---

### docs/

Documentación específica de la PKI.

Ejemplos:

- Emisión de certificados.
- Renovación.
- Revocación.
- Instalación en Windows.
- Instalación en Linux.
- Instalación en Android.
- Troubleshooting.

---

## Filosofía

La PKI será un componente permanente del HomeLab.

No se generarán certificados manualmente para cada servicio.

Todos los certificados deberán ser emitidos por la misma Autoridad Certificadora.

Esto permitirá mantener una infraestructura consistente, mantenible y fácilmente escalable.

---

## Relación con otros servicios

La PKI será utilizada por:

- Homepage
- Vaultwarden
- Nextcloud
- Immich
- Gitea
- Grafana
- Paperless
- n8n
- OpenWebUI
- Servicios futuros

---

## Decisiones arquitectónicas

### Autoridad Certificadora propia

Se utilizará una Root CA interna denominada:

```text
Jarvis Root CA
```

---

### HTTPS obligatorio

Todo servicio publicado mediante Nginx Proxy Manager deberá utilizar HTTPS.

---

### Versionado

El repositorio almacenará:

- Documentación.
- Scripts.
- Procedimientos.

No almacenará:

- Claves privadas.
- Certificados emitidos.
- CSR generados.

Estos archivos serán excluidos mediante el `.gitignore` principal del proyecto.

---

## Roadmap

- [ ] Crear Root CA.
- [ ] Emitir certificado para Homepage.
- [ ] Emitir certificado para Vaultwarden.
- [ ] Configurar HTTPS en Nginx Proxy Manager.
- [ ] Instalar la Root CA en Windows.
- [ ] Migrar el resto de los servicios a HTTPS.

---

## Lessons Learned

Pendiente.

Esta sección se completará durante la implementación de la PKI.

---

## Historial

| Fecha | Descripción |
|--------|-------------|
| Julio 2026 | Inicio del proyecto PKI para Jarvis. |
