# Sprint 4 - Migración de la infraestructura de red hacia Omada ER605

> **Estado:** En progreso  
> **Sprint:** Sprint 4 - Infraestructura Base  
> **Fecha de inicio:** Julio 2026  
> **Última actualización:** 30/07/2026  
> **Autor:** Kenny Velandia

---

# Resumen

Este documento registra el proceso completo de migración de la infraestructura de red del HomeLab hacia una arquitectura administrada por el TP-Link Omada ER605.

Se documentan las decisiones de arquitectura, configuraciones realizadas, problemas encontrados durante la migración, metodología de diagnóstico utilizada y las lecciones aprendidas.

El objetivo es disponer de una referencia técnica que permita comprender el razonamiento detrás de cada decisión y facilitar futuras ampliaciones de la infraestructura.

---

# Índice

1. Introducción
2. Objetivos del Sprint
3. Resultado esperado
4. Arquitectura inicial
5. Limitaciones detectadas
6. Decisión de arquitectura
7. Proceso de migración
   - 7.1 Instalación del ER605
   - 7.2 Creación de la nueva subred
   - 7.3 Configuración DHCP
   - 7.4 Reserva DHCP
   - 7.5 Reconfiguración de Jarvis
   - 7.6 Validación
   - 7.7 AdGuard Home
   - 7.8 Distribución del DNS
   - 7.9 Dominios internos
   - 7.10 Nginx Proxy Manager
   - 7.11 Arquitectura Reverse Proxy
   - 7.12 Docker Network
   - 7.13 Política de publicación
8. Troubleshooting
9. Lecciones aprendidas
10. Estado final del Sprint
11. Próximos pasos

---

# Introducción

Hasta este sprint, el servidor **Jarvis** utilizaba la infraestructura de red proporcionada por el router del proveedor de Internet.

Si bien esta configuración permitía comenzar el proyecto, presentaba diversas limitaciones propias de una red doméstica:

- Acceso a los servicios mediante direcciones IP.
- Ausencia de un DNS interno.
- Dependencia del DHCP del router del ISP.
- Infraestructura poco preparada para crecer.
- Configuración distribuida entre distintos componentes.

Con el crecimiento del HomeLab surgió la necesidad de independizar completamente la administración de la red y comenzar a utilizar una infraestructura similar a la empleada en entornos profesionales.

Para ello se decidió incorporar un **TP-Link Omada ER605**, convirtiéndolo en el gateway principal de la red local.

Este sprint no consistió únicamente en reemplazar un router.

El verdadero objetivo fue construir una infraestructura preparada para soportar:

- DNS interno.
- Reverse Proxy.
- HTTPS mediante una PKI propia.
- NAS.
- Virtualización.
- Servicios expuestos de forma segura.
- Crecimiento futuro mediante dispositivos Omada.

Al finalizar este sprint todos los servicios del HomeLab quedarían accesibles mediante nombres de dominio internos (`*.jarvis.local`), eliminando la dependencia del acceso mediante direcciones IP.

---

# Objetivos del Sprint

Los objetivos definidos para este sprint fueron:

- Incorporar el TP-Link Omada ER605 como gateway principal.
- Independizar la infraestructura del router del ISP.
- Implementar una nueva subred administrada por el HomeLab.
- Configurar DHCP centralizado.
- Configurar reservas DHCP para equipos críticos.
- Implementar AdGuard Home como servidor DNS.
- Resolver los servicios mediante nombres personalizados.
- Incorporar Nginx Proxy Manager como Reverse Proxy.
- Preparar la infraestructura para HTTPS mediante una PKI interna.
- Establecer las bases para futuras ampliaciones de la red.

---

# Resultado esperado

Al finalizar este sprint la infraestructura debería cumplir los siguientes objetivos:

- Todos los servicios accesibles mediante nombres de dominio.
- Infraestructura independiente del router del ISP.
- Administración centralizada del direccionamiento IP.
- Resolución DNS interna mediante AdGuard Home.
- Reverse Proxy completamente funcional.
- Base preparada para HTTPS interno.
- Arquitectura preparada para futuras ampliaciones del HomeLab.

---

# Contenido del documento

Este documento describe:

1. Arquitectura inicial.
2. Diseño de la nueva infraestructura.
3. Decisiones de arquitectura.
4. Configuración realizada.
5. Migración de la red.
6. Configuración del DNS.
7. Configuración del Reverse Proxy.
8. Troubleshooting completo.
9. Lecciones aprendidas.
10. Estado final del sprint.

---

# Arquitectura inicial

Antes de iniciar este sprint, el HomeLab utilizaba la infraestructura de red proporcionada por el router del proveedor de Internet.

Toda la administración de la red dependía del equipamiento del ISP, incluyendo el direccionamiento IP, el servicio DHCP y la conectividad de los dispositivos de la red local.

El servidor **Jarvis** y la computadora principal se encontraban conectados a esta red y los distintos servicios Docker eran accesibles directamente mediante la dirección IP del servidor y el puerto correspondiente.

La topología inicial era la siguiente:

                           INTERNET
                               │
                               │
                     ┌──────────────────┐
                     │  Router del ISP  │
                     │ 192.168.0.1/24   │
                     └────────┬─────────┘
                              │
        ┌─────────────────────┴────────────────────┐
        │                                          │
┌──────────────────┐                    ┌─────────────────────┐
│   PC Principal   │                    │       Jarvis        │
│ 192.168.0.x      │                    │   192.168.0.24      │
└──────────────────┘                    └─────────┬───────────┘
                                                  │
                                          Docker Containers
                                                  │
                     ┌──────────┬──────────┬──────────┬──────────┐
                     │Homepage  │Portainer │Dozzle    │...       │
                     └──────────┴──────────┴──────────┴──────────┘

Acceso:
http://192.168.0.24:3000
http://192.168.0.24:9000
http://192.168.0.24:9999

---

## Características de la infraestructura

- Red administrada completamente por el router del ISP.
- DHCP proporcionado por el ISP.
- Sin servidor DNS interno.
- Acceso a los servicios mediante dirección IP y puerto.
- Sin Reverse Proxy.
- Sin certificados internos.
- Sin una infraestructura preparada para escalar.

---

# Limitaciones detectadas

A medida que el HomeLab fue creciendo comenzaron a aparecer limitaciones propias de una infraestructura doméstica administrada por el router del proveedor de Internet.

Si bien esta configuración era suficiente para comenzar el proyecto, no resultaba adecuada para una infraestructura orientada al aprendizaje y la simulación de entornos profesionales.

Durante la planificación del crecimiento del HomeLab se identificaron las siguientes limitaciones:

- Dependencia total del router del ISP para la administración de la red.
- Acceso a los servicios utilizando direcciones IP y puertos.
- Ausencia de un servidor DNS interno.
- Imposibilidad de utilizar nombres de dominio personalizados.
- Falta de una base para implementar certificados HTTPS internos.
- Escasa capacidad para segmentar o expandir la infraestructura de red.
- Administración distribuida entre distintos dispositivos sin un punto central de control.

Estas limitaciones motivaron el rediseño completo de la infraestructura de red y la incorporación de un gateway administrado por el propio HomeLab.

---

# Decisión de arquitectura

Luego de analizar las limitaciones de la infraestructura existente, se decidió independizar completamente la red del HomeLab del router proporcionado por el proveedor de Internet.

Para ello se incorporó un **TP-Link Omada ER605**, que pasó a convertirse en el gateway principal de la red local.

Esta decisión no tuvo como objetivo reemplazar el router del ISP, sino trasladar al HomeLab la responsabilidad de administrar la infraestructura de red.

El router del proveedor quedó limitado exclusivamente a proporcionar la conexión hacia Internet, mientras que todas las funciones relacionadas con la red interna pasaron a ser administradas por el ER605.

Entre los principales beneficios obtenidos se encuentran:

- Independencia del equipamiento del ISP.
- Administración centralizada del direccionamiento IP.
- Implementación de un servidor DNS interno.
- Posibilidad de utilizar nombres de dominio personalizados.
- Base para incorporar HTTPS mediante una PKI propia.
- Integración futura con el ecosistema Omada.
- Preparación para la incorporación de VLANs y segmentación de red.
- Infraestructura escalable para futuras ampliaciones del HomeLab.

Esta decisión representa uno de los cambios arquitectónicos más importantes realizados hasta el momento dentro del proyecto.

---

# Proceso de migración

La migración de la infraestructura de red se realizó de forma incremental con el objetivo de minimizar el impacto sobre los servicios existentes y permitir la validación de cada cambio antes de continuar con el siguiente.

En lugar de modificar múltiples componentes simultáneamente, se adoptó una estrategia basada en pequeñas etapas, verificando el correcto funcionamiento de la infraestructura al finalizar cada una de ellas.

Las principales etapas de la migración fueron las siguientes:

1. Instalación física del TP-Link Omada ER605.
2. Configuración inicial del gateway.
3. Creación de una nueva red local independiente.
4. Configuración del servicio DHCP.
5. Reserva de dirección IP para el servidor Jarvis.
6. Reconfiguración de la interfaz de red del servidor.
7. Validación de la conectividad.
8. Implementación de AdGuard Home como servidor DNS.
9. Configuración de las reglas DNS para los servicios internos.
10. Configuración de Nginx Proxy Manager como Reverse Proxy.
11. Validación completa de la infraestructura.

Cada una de estas etapas se documenta en las siguientes secciones.

---

## 1. Instalación del TP-Link Omada ER605

Como primer paso se incorporó un TP-Link Omada ER605 para asumir la administración de la red interna del HomeLab.

La conexión física quedó definida de la siguiente manera:

```text
Internet
    │
Router ISP
    │
Puerto WAN (ER605)
    │
TP-Link Omada ER605
    │
Puerto LAN
    │
Switch / Red Local
    │
Servidor Jarvis
```

En esta etapa el router del ISP continuó proporcionando la conexión a Internet, mientras que el ER605 comenzó a administrar exclusivamente la red local.

De esta forma quedaron claramente separadas las responsabilidades de ambos dispositivos:

| Dispositivo | Función |
|-------------|----------|
| Router ISP | Acceso a Internet |
| TP-Link ER605 | Administración de la red local |

---

## 2. Creación de la nueva subred

Una de las primeras decisiones de diseño consistió en crear una nueva subred completamente independiente de la utilizada por el router del proveedor de Internet.

Se definió la siguiente configuración para la nueva LAN administrada por el ER605:

| Parámetro | Valor |
|-----------|-------|
| Red | 192.168.10.0/24 |
| Gateway | 192.168.10.1 |
| Máscara | 255.255.255.0 |
| DHCP | Administrado por el ER605 |

Esta nueva red permitió aislar completamente la infraestructura del HomeLab de la red del ISP.

A partir de este momento, todos los dispositivos conectados al HomeLab comenzarían a recibir direcciones IP pertenecientes a la red **192.168.10.0/24**, mientras que el router del proveedor permanecería únicamente como salida hacia Internet.

### ¿Por qué se eligió la red 192.168.10.0/24?

Inicialmente se detectó un conflicto potencial al utilizar la misma subred que el router del ISP (`192.168.0.0/24`).

En lugar de mantener ambas infraestructuras dentro del mismo segmento de red, se decidió adoptar una nueva subred exclusiva para el HomeLab.

Esta decisión aporta varias ventajas:

- Evita conflictos de direccionamiento.
- Facilita el diagnóstico de problemas de red.
- Separa claramente la infraestructura propia de la infraestructura del proveedor.
- Simplifica futuras migraciones.
- Prepara la infraestructura para incorporar VLANs y segmentación de red.

---

## 3. Configuración del servicio DHCP

Una vez creada la nueva subred, el TP-Link Omada ER605 pasó a ser el encargado de asignar automáticamente las direcciones IP a los dispositivos conectados a la red local.

Centralizar el servicio DHCP en el gateway permitió administrar desde un único punto aspectos como:

- Asignación de direcciones IP.
- Puerta de enlace predeterminada.
- Servidores DNS entregados a los clientes.
- Reservas DHCP para equipos críticos.

Esta decisión simplifica la administración de la red y facilita futuras modificaciones sin necesidad de reconfigurar manualmente cada dispositivo.

---

## 4. Reserva DHCP para el servidor Jarvis

Dado que el servidor constituye el núcleo de la infraestructura del HomeLab, se decidió asignarle siempre la misma dirección IP mediante una reserva DHCP configurada en el ER605.

La reserva garantiza que, independientemente de los reinicios del servidor o del router, Jarvis reciba siempre la misma dirección IP.

La configuración quedó definida de la siguiente manera:

| Equipo | Dirección IP |
|---------|--------------|
| Jarvis | 192.168.10.24 |

Esta decisión evita depender de configuraciones IP estáticas en el sistema operativo y mantiene la administración del direccionamiento completamente centralizada en el gateway.

---

## 5. Reconfiguración del servidor Jarvis

Una vez configurada la nueva infraestructura de red, fue necesario adaptar la configuración de red del servidor Debian para que comenzara a operar dentro de la nueva subred administrada por el ER605.

En lugar de asignar una dirección IP estática directamente en el sistema operativo, se optó por mantener la interfaz configurada mediante DHCP y delegar completamente la administración del direccionamiento al gateway.

Esta decisión permitió centralizar la administración de la red y evitar configuraciones duplicadas entre el servidor y el router.

La configuración quedó definida de la siguiente manera:

| Componente | Configuración |
|------------|---------------|
| Sistema Operativo | Debian 12 |
| Interfaz | Configurada mediante DHCP |
| Dirección IP asignada | 192.168.10.24 |
| Asignación | Reserva DHCP en el ER605 |

Esta arquitectura ofrece varias ventajas:

- Administración centralizada del direccionamiento IP.
- Mayor facilidad para reemplazar hardware en el futuro.
- Eliminación de configuraciones IP manuales dentro del sistema operativo.
- Menor riesgo de conflictos de direccionamiento.

Una vez aplicada la configuración, se verificó que el servidor obtuviera correctamente la dirección IP reservada y recuperara la conectividad con el resto de la infraestructura.

---

## 6. Validación de conectividad

Finalizada la reconfiguración del servidor, se realizaron distintas verificaciones para asegurar el correcto funcionamiento de la nueva infraestructura.

Entre las comprobaciones realizadas se incluyeron:

- Obtención correcta de la dirección IP mediante DHCP.
- Comunicación con el gateway del ER605.
- Acceso a Internet.
- Resolución de nombres de dominio públicos.
- Comunicación entre los distintos servicios Docker.
- Acceso remoto mediante SSH desde la estación de trabajo.

Estas validaciones permitieron confirmar que la migración de la red se había realizado correctamente antes de continuar con la implementación del servidor DNS interno.

---

## 7. Implementación de AdGuard Home como servidor DNS

Una vez validada la nueva infraestructura de red, el siguiente paso consistió en incorporar un servidor DNS interno.

Para este propósito se eligió **AdGuard Home**, ejecutándose como un contenedor Docker dentro del servidor Jarvis.

Además de sus funciones de filtrado y bloqueo de publicidad, AdGuard Home ofrece un servidor DNS completo, permitiendo administrar la resolución de nombres dentro de la red local.

Esta funcionalidad permitió abandonar el acceso a los servicios mediante direcciones IP y comenzar a utilizar nombres de dominio personalizados.

### Objetivos

La incorporación de AdGuard Home tuvo los siguientes objetivos:

- Centralizar la resolución DNS de toda la red.
- Implementar nombres de dominio internos.
- Facilitar el acceso a los servicios.
- Preparar la infraestructura para HTTPS interno.
- Centralizar futuras reglas DNS del HomeLab.

A partir de este momento, todos los clientes de la red comenzaron a utilizar AdGuard Home como servidor DNS principal.
---

## 8. Configuración del DHCP para distribuir el DNS

Una vez instalado AdGuard Home, fue necesario modificar la configuración del servicio DHCP del ER605.

En lugar de distribuir el propio gateway como servidor DNS, el ER605 pasó a entregar la dirección IP del servidor Jarvis a todos los clientes de la red.

La configuración quedó definida de la siguiente manera:

| Parámetro | Valor |
|-----------|-------|
| Servidor DNS | 192.168.10.24 |

Con esta modificación, cualquier dispositivo que obtuviera su configuración mediante DHCP comenzaría a utilizar automáticamente AdGuard Home para resolver nombres de dominio.

Esta decisión permitió centralizar completamente la resolución DNS de la infraestructura desde un único punto.

---

## 9. Implementación de dominios internos

Con el servidor DNS operativo, se crearon las primeras reglas de resolución interna utilizando el dominio:

```text
jarvis.local
```

Se definieron registros DNS para los principales servicios del HomeLab.

| Dominio | Destino |
|----------|----------|
| homepage.jarvis.local | 192.168.10.24 |
| portainer.jarvis.local | 192.168.10.24 |
| vaultwarden.jarvis.local | 192.168.10.24 |
| uptime.jarvis.local | 192.168.10.24 |
| dozzle.jarvis.local | 192.168.10.24 |
| npm.jarvis.local | 192.168.10.24 |

Todos los registros apuntan al servidor Jarvis, siendo posteriormente Nginx Proxy Manager el encargado de dirigir cada solicitud hacia el contenedor correspondiente.

Este cambio representó un paso importante hacia una infraestructura similar a la utilizada en entornos empresariales, donde los servicios se identifican mediante nombres de dominio en lugar de direcciones IP y puertos.

---

## 10. Implementación de Nginx Proxy Manager

Una vez implementado el servidor DNS interno, el siguiente paso consistió en centralizar el acceso a todos los servicios del HomeLab mediante un Reverse Proxy.

Para ello se incorporó **Nginx Proxy Manager (NPM)** como punto único de entrada hacia los distintos servicios Docker.

Su función principal consiste en recibir las solicitudes realizadas a los dominios internos y redirigirlas automáticamente al contenedor correspondiente.

De esta manera, los usuarios acceden siempre mediante un nombre de dominio, sin necesidad de conocer la dirección IP ni el puerto utilizado por cada servicio.

### Objetivos

- Centralizar el acceso a los servicios.
- Ocultar los puertos internos de las aplicaciones.
- Simplificar la incorporación de nuevos servicios.
- Preparar la infraestructura para HTTPS.
- Mantener una arquitectura limpia y escalable.

---

## 11. Arquitectura del Reverse Proxy

Se adoptó una arquitectura basada en un único punto de entrada para todos los servicios publicados.

En esta arquitectura únicamente **Nginx Proxy Manager** expone puertos hacia la red local.

El resto de los contenedores permanecen accesibles únicamente desde la red interna de Docker.

La comunicación se realiza de la siguiente forma:

```text
                     Usuario
                         │
                         ▼
            homepage.jarvis.local
                         │
                         ▼
                 AdGuard Home (DNS)
             Resuelve → 192.168.10.24
                         │
                         ▼
             Nginx Proxy Manager
                         │
                         ▼
         Docker Network (jarvis_network)
                         │
      ┌──────────┬──────────┬──────────┬──────────┐
      │          │          │          │          │
 Homepage   Portainer  Vaultwarden  Dozzle  Uptime Kuma
```

Esta arquitectura presenta múltiples ventajas:

- Un único punto de acceso para todos los servicios.
- Menor superficie de exposición de la infraestructura.
- Configuración simplificada.
- Incorporación sencilla de nuevos servicios.
- Preparación para HTTPS mediante certificados internos.

---

## 12. Red Docker compartida

Para permitir la comunicación entre Nginx Proxy Manager y el resto de los servicios se creó una red Docker compartida denominada:

```text
jarvis_network
```

Todos los contenedores que deben ser accesibles mediante el Reverse Proxy se conectan a esta red.

Gracias a ello, Nginx Proxy Manager puede comunicarse directamente con cada contenedor utilizando su nombre dentro de Docker, sin necesidad de utilizar direcciones IP.

Esta decisión aporta varias ventajas:

- Independencia de las direcciones IP de los contenedores.
- Mayor portabilidad de la infraestructura.
- Configuración más simple de los Proxy Hosts.
- Menor acoplamiento entre los servicios.

---

## 13. Política de publicación de puertos

Como parte de la estandarización de la infraestructura se definió una política para la publicación de servicios Docker.

La regla general adoptada es la siguiente:

- **Nginx Proxy Manager** publica los puertos necesarios hacia la red local.
- El resto de los servicios utilizan únicamente la directiva `expose` dentro de Docker Compose.

Esta decisión evita que múltiples aplicaciones publiquen puertos directamente sobre el servidor y concentra todo el acceso externo en un único componente.

Entre los principales beneficios se encuentran:

- Mayor seguridad.
- Menor riesgo de conflictos de puertos.
- Configuración homogénea para todos los servicios.
- Escalabilidad a medida que el HomeLab crezca.

---

# Arquitectura final
                               INTERNET
                                   │
                                   │
                      ┌────────────────────────┐
                      │     Router del ISP     │
                      │      192.168.0.1       │
                      └───────────┬────────────┘
                                  │
                               WAN│
                     ┌────────────▼────────────┐
                     │ TP-Link Omada ER605     │
                     │ Gateway 192.168.10.1    │
                     │ DHCP + Routing          │
                     └────────────┬────────────┘
                                  │
                     LAN 192.168.10.0/24
                                  │
            ┌─────────────────────┴────────────────────┐
            │                                          │
     PC Principal                               Servidor Jarvis
    192.168.10.x                               192.168.10.24
                                                      │
                                                Docker Engine
                                                      │
                                              jarvis_network
                                                      │
             ┌────────────────────────────────────────┼─────────────────────────────────────────┐
             │                                        │                                         │
      AdGuard Home                         Nginx Proxy Manager                       Otros Servicios
      DNS interno                          Reverse Proxy                     Homepage · Portainer
                                                                         Vaultwarden · Dozzle
                                                                          Uptime Kuma · etc.

---

# Troubleshooting de la migración

Durante la migración se presentaron distintos incidentes que fueron resueltos mediante un proceso sistemático de diagnóstico.

En lugar de aplicar cambios al azar, cada hipótesis fue validada antes de continuar con la siguiente.

Esta metodología permitió identificar las causas reales de cada inconveniente y comprender el funcionamiento de la infraestructura.

Las siguientes secciones documentan cada uno de los incidentes encontrados.

---

## Incidente 1 - Los dominios internos no resolvían correctamente

### Síntoma

Luego de configurar AdGuard Home y crear los registros DNS, algunos equipos continuaban sin resolver correctamente los dominios internos del HomeLab.

En determinados casos se seguía accediendo mediante direcciones IP o la resolución de nombres era inconsistente.

### Hipótesis inicial

Se plantearon distintas posibilidades:

- Error en la configuración de AdGuard Home.
- Configuración incorrecta del DHCP.
- Caché DNS del sistema operativo.
- Configuración incorrecta del ER605.

### Diagnóstico

Se revisó la configuración entregada por el servidor DHCP del ER605 y se comprobó qué servidor DNS estaban utilizando los clientes.

Durante esta revisión se detectó que el gateway continuaba anunciándose a sí mismo como servidor DNS en lugar de entregar la dirección IP del servidor Jarvis.

### Causa raíz

El servicio DHCP del ER605 aún distribuía su propia dirección como servidor DNS.

Como consecuencia, los clientes nunca consultaban a AdGuard Home para resolver los dominios internos.

### Solución

Se modificó la configuración DHCP del ER605 para distribuir como servidor DNS:

```

192.168.10.24

```

correspondiente al servidor Jarvis donde se ejecuta AdGuard Home.

Tras renovar la configuración DHCP de los clientes, la resolución DNS comenzó a funcionar correctamente.

---

## Incidente 2 - Windows continuaba resolviendo la dirección IP antigua

### Síntoma

Aun después de corregir la configuración DNS, algunos dominios seguían resolviendo hacia la antigua dirección IP del servidor.

### Diagnóstico

Se revisó la configuración local del equipo cliente.

Durante la investigación se detectó que el archivo:

```text
C:\Windows\System32\drivers\etc\hosts
```

contenía una entrada creada durante etapas anteriores del proyecto.

Esta entrada asociaba el dominio interno con la dirección IP anterior del servidor.

### Causa raíz

El archivo `hosts` tiene prioridad sobre cualquier servidor DNS configurado.

Mientras existiera dicha entrada, Windows nunca consultaría a AdGuard Home.

### Solución

Se eliminó la entrada obsoleta del archivo `hosts`.

Una vez realizado este cambio, el sistema comenzó a resolver correctamente los dominios utilizando el servidor DNS interno.

---

## Incidente 3 - Homepage seguía utilizando enlaces con la dirección IP anterior

### Síntoma

Aunque los dominios internos ya resolvían correctamente, algunos accesos desde Homepage continuaban abriendo servicios utilizando la dirección IP antigua del servidor.

### Diagnóstico

Se revisó la configuración del contenedor Homepage.

Se comprobó que varios accesos rápidos habían sido configurados manualmente utilizando la dirección IP anterior de Jarvis.

### Causa raíz

Homepage no obtenía automáticamente las direcciones desde el servidor DNS.

Los enlaces configurados manualmente seguían apuntando a la infraestructura anterior.

### Solución

Se actualizó la configuración de Homepage reemplazando las direcciones IP por los nuevos dominios internos.

De esta manera, Homepage pasó a depender completamente del DNS interno del HomeLab.

---

# Lecciones aprendidas

La migración de la infraestructura de red permitió obtener aprendizajes técnicos y metodológicos que servirán como base para la evolución del HomeLab.

Entre los principales aprendizajes se destacan:

- Diseñar una arquitectura antes de comenzar a implementar reduce significativamente la cantidad de cambios posteriores.
- Centralizar la administración de la red simplifica el mantenimiento y mejora la escalabilidad.
- Un servidor DNS interno resulta fundamental para construir una infraestructura profesional.
- Utilizar nombres de dominio mejora la experiencia de uso y desacopla los servicios de las direcciones IP.
- Concentrar el acceso a los servicios mediante un Reverse Proxy simplifica la administración y reduce la superficie de exposición.
- Documentar el proceso de diagnóstico resulta tan importante como documentar la solución final.
- Validar cada cambio antes de continuar permitió detectar problemas de forma temprana y evitar incidentes más complejos.

Este sprint marcó la transición desde una infraestructura doméstica hacia una arquitectura modular, mantenible y preparada para crecer.

---

# Estado final del Sprint

Al finalizar este sprint se alcanzaron los siguientes objetivos:

- ✅ Incorporación del TP-Link Omada ER605 como gateway principal.
- ✅ Creación de una nueva subred independiente para el HomeLab.
- ✅ Configuración centralizada del servicio DHCP.
- ✅ Reserva DHCP para el servidor Jarvis.
- ✅ Migración del servidor a la nueva infraestructura de red.
- ✅ Implementación de AdGuard Home como servidor DNS.
- ✅ Configuración de dominios internos (`*.jarvis.local`).
- ✅ Implementación de Nginx Proxy Manager como Reverse Proxy.
- ✅ Definición de una arquitectura basada en una red Docker compartida.
- ✅ Estandarización de la publicación de servicios mediante Nginx Proxy Manager.
- ✅ Resolución de los incidentes detectados durante la migración.
- ✅ Documentación completa del proceso de migración.

La infraestructura quedó preparada para continuar con la siguiente etapa del proyecto: la implementación de HTTPS interno mediante una PKI propia y, posteriormente, la construcción del NAS y del sistema de copias de seguridad.

---

# Próximos pasos

Con la infraestructura de red estabilizada, las siguientes etapas del HomeLab serán:

1. Implementación de HTTPS interno mediante una PKI propia.
2. Validación de todos los servicios utilizando HTTPS.
3. Documentación de la infraestructura PKI.
4. Construcción del NAS.
5. Implementación de la estrategia de backups.
6. Incorporación de nuevos servicios Docker sobre la arquitectura definida.

Cada una de estas etapas será documentada siguiendo la misma metodología utilizada durante este sprint.

---

