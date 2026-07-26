# Jarvis PKI Standard

**Versión:** 1.0

**Estado:** Activo

**Autor:** Kenny Velandia

**Proyecto:** Jarvis HomeLab

**Última actualización:** Julio 2026

---

# Propósito

El Jarvis PKI Standard define la infraestructura de clave pública utilizada por la plataforma Jarvis para proporcionar autenticidad, confidencialidad y confianza entre los servicios y sus clientes.

Su objetivo es estandarizar la emisión, administración y utilización de certificados digitales dentro del HomeLab.

---

# Alcance

Este estándar aplica a todos los servicios publicados mediante HTTPS dentro de Jarvis.

Todo nuevo servicio accesible por los usuarios deberá utilizar certificados emitidos por la PKI interna o por el mecanismo que la plataforma adopte oficialmente en el futuro.

---

# Principios

## 1. Una única autoridad certificadora

Jarvis mantiene una única Root CA propia.

Toda la confianza interna deriva de esta autoridad.

---

## 2. Un certificado por servicio

Cada servicio publicado dispone de su propio certificado.

Nunca se reutilizan certificados entre servicios.

---

## 3. Claves privadas protegidas

Las claves privadas:

- nunca se almacenan en Git;
- permanecen únicamente en el servidor;
- se protegen mediante permisos Linux.

---

## 4. Terminación TLS centralizada

Toda la terminación TLS se realiza mediante:

```text
Nginx Proxy Manager
```

Los servicios Docker permanecen comunicándose mediante HTTP dentro de la red privada.

---

## 5. Automatización futura

La arquitectura permite incorporar mecanismos automáticos de renovación sin modificar los servicios existentes.

---

# Arquitectura

```text
                    Jarvis Root CA
                           │
        ┌──────────────────┼──────────────────┐
        ▼                  ▼                  ▼
 Vaultwarden         Próximo Servicio    Próximo Servicio
        │                  │                  │
        ▼                  ▼                  ▼
 Certificado       Certificado       Certificado
        │
        ▼
Nginx Proxy Manager
        │
        ▼
Cliente HTTPS
```

---

# Componentes

La PKI de Jarvis se organiza en los siguientes componentes:

- Root CA
- Certificados de servidor
- Claves privadas
- Solicitudes CSR
- Plantillas OpenSSL
- Certificados instalados en clientes

---

# Organización del repositorio

```text
security/
└── pki/
    ├── root-ca/
    ├── services/
    ├── templates/
    └── README.md
```

Cada servicio dispone de su propio directorio.

---

# Estructura por servicio

```text
services/
└── vaultwarden/
    ├── README.md
    ├── vaultwarden.crt
    ├── vaultwarden.cnf
    └── vaultwarden-ext.cnf
```

Las claves privadas y los CSR permanecen excluidos del repositorio mediante `.gitignore`.

---

# Emisión de certificados

El ciclo oficial es:

```text
Crear clave privada
        │
        ▼
Generar CSR
        │
        ▼
Firmar mediante Root CA
        │
        ▼
Instalar certificado
        │
        ▼
Configurar Nginx Proxy Manager
        │
        ▼
Distribuir confianza
```

---

# Distribución de confianza

La Root CA debe instalarse en los dispositivos que accederán a los servicios internos.

Actualmente se contempla:

- Windows
- Dispositivos móviles
- Navegadores

---

# Renovación

Los certificados poseen una vigencia definida.

Cuando expire un certificado:

1. generar un nuevo CSR;
2. firmarlo nuevamente mediante la Root CA;
3. reemplazar el certificado en Nginx Proxy Manager.

La Root CA no requiere regenerarse durante este proceso.

---

# Protección de secretos

Nunca se almacenan en Git:

- claves privadas;
- CSR;
- certificados temporales;
- secretos asociados.

La protección se implementa mediante:

- `.gitignore`;
- permisos Linux;
- almacenamiento local.

---

# Integración con otros estándares

PKI Standard complementa:

- JDS
- JBS
- Security Architecture

---

# Lessons Learned

- Una PKI propia simplifica la administración de múltiples servicios internos.
- Centralizar TLS en Nginx Proxy Manager reduce la complejidad de cada contenedor.
- Mantener un certificado por servicio facilita futuras renovaciones y revocaciones.
- Separar certificados públicos y claves privadas dentro del repositorio mejora la seguridad y la mantenibilidad.

---

# Historial

| Versión | Fecha | Descripción |
|----------|-------|-------------|
| 1.0 | Julio 2026 | Primera versión oficial del PKI Standard de Jarvis. |
