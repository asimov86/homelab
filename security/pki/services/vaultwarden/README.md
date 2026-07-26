# Vaultwarden Certificate

## Descripción

Certificado TLS utilizado por Vaultwarden.

Este certificado es presentado por Nginx Proxy Manager para establecer conexiones HTTPS hacia:

```text
https://vaultwarden.jarvis.local
```

---

## Emisor

```text
Jarvis Root CA
```

---

## Common Name (CN)

```text
vaultwarden.jarvis.local
```

---

## Subject Alternative Name (SAN)

```text
DNS:vaultwarden.jarvis.local
```

---

## Algoritmo

```text
RSA 4096
SHA-256
```

---

## Validez

1 año.

---

## Clave privada

La clave privada correspondiente:

```text
vaultwarden.key
```

no posee passphrase.

### Motivo

La terminación TLS es realizada por Nginx Proxy Manager.

Durante el inicio del servicio no existe interacción humana para ingresar una contraseña.

Por esta razón la clave privada debe permanecer sin cifrar.

La seguridad se garantiza mediante:

- permisos Linux;
- almacenamiento local;
- exclusión mediante `.gitignore`;
- acceso restringido al servidor.

---

## Renovación

Cuando el certificado expire:

1. generar un nuevo CSR;
2. firmarlo mediante Jarvis Root CA;
3. reemplazar el certificado en Nginx Proxy Manager.

No será necesario generar una nueva Root CA.

---

## Fingerprint

Pendiente.

Se completará una vez emitido el certificado.

Ejemplo:

```text
SHA256 Fingerprint:4E:8D:9B:08:D4:86:19:58:78:F8:75:BE:FB:02:19:7D:F7:E2:15:43:AC:25:E7:46:AD:AE:81:75:D3:BE:BB:1F
```

---

## Ubicación

```text
security/pki/services/vaultwarden/
```

Contenido:

```text
vaultwarden.key
vaultwarden.csr
vaultwarden.crt
README.md
```
---

## Historial

| Fecha | Descripción |
|--------|-------------|
| Julio 2026 | Primer certificado emitido para Vaultwarden. |
