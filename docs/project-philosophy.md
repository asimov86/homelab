# Filosofía del proyecto HomeLab

Este proyecto no busca únicamente construir un HomeLab funcional.

Su objetivo es aprender infraestructura de forma consciente, documentar el proceso y construir una base de conocimiento reutilizable que permita comprender no solo **qué** se hizo, sino también **por qué** se tomó cada decisión.

---

# 1. Comprender antes de ejecutar

No se ejecutan comandos, configuraciones o herramientas sin comprender:

- Qué hacen.
- Por qué existen.
- Qué problema resuelven.
- Qué impacto tienen sobre la infraestructura.

El objetivo es aprender los conceptos, no memorizar comandos.

---

# 2. Comprender → Implementar → Documentar

Todo cambio sigue el mismo ciclo:

```text
Comprender
      ↓
Implementar
      ↓
Documentar
```

La documentación acompaña al desarrollo; no se deja para el final.

---

# 3. Documentar decisiones, no solo configuraciones

No alcanza con registrar qué se configuró.

También debe documentarse:

- Por qué se eligió una solución.
- Qué alternativas fueron consideradas.
- Qué ventajas y desventajas tiene la decisión.
- Qué problema resuelve.

Las decisiones técnicas son tan importantes como la configuración.

---

# 4. Construcción incremental

La infraestructura se construye paso a paso.

Cada servicio sigue el siguiente proceso:

```text
Diseñar
      ↓
Implementar
      ↓
Probar
      ↓
Documentar
      ↓
Commit
      ↓
Push
```

No se agregan múltiples servicios simultáneamente.

---

# 5. Cada servicio es un pequeño proyecto

Cada servicio Docker tendrá su propio espacio dentro del repositorio.

Como mínimo:

```text
docker/<servicio>/
├── README.md
└── compose.yaml
```

Opcionalmente, cuando el servicio lo requiera:

```text
├── CHANGELOG.md
└── assets/
```

Cada servicio debe poder entenderse de forma independiente.

---

# 6. Git cuenta la historia del proyecto

Cada commit representa una única idea.

Los mensajes deben ser claros y descriptivos.

Ejemplos:

```text
Add .gitignore
Deploy Portainer
Document Portainer
Configure reverse proxy
Deploy Nextcloud
```

El historial de Git debe poder leerse como un libro que narra la evolución del HomeLab.

---

# 7. El Roadmap tiene dos dimensiones

El proyecto registra tanto:

## Lo que construimos

- Infraestructura
- Servicios
- Automatizaciones

Como también:

## Lo que aprendemos

- Conceptos
- Tecnologías
- Buenas prácticas
- Lecciones incorporadas

El conocimiento adquirido es tan importante como la infraestructura implementada.

---

# 8. El repositorio debe explicarse solo

Cualquier persona debería poder comprender el proyecto sin haber participado en su construcción.

La documentación debe permitir entender:

- Qué hace el proyecto.
- Cómo está organizado.
- Cómo desplegarlo.
- Cómo mantenerlo.
- Por qué se tomaron determinadas decisiones.

El repositorio debe funcionar como un portfolio técnico y una fuente de conocimiento.

---

# 9. La documentación debe acompañar al proyecto, no retrasarlo

La documentación agrega valor cuando facilita comprender y mantener la infraestructura.

No debe convertirse en un obstáculo para avanzar.

Si una mejora documental no aporta valor inmediato, se registra como una idea y se implementa cuando corresponda.

El objetivo es mantener un equilibrio entre documentación e implementación.

---

# 10. Automatizar cuando el conocimiento esté consolidado

La automatización es una consecuencia del conocimiento, no un reemplazo del aprendizaje.

Primero se comprende el proceso.

Luego se automatiza.

Nunca se automatiza algo que todavía no se entiende.

---

# 11. Volvamos al HomeLab

La planificación y la documentación son importantes, pero el objetivo principal es construir el laboratorio.

Si en algún momento el proyecto se desvía hacia un exceso de planificación o documentación, utilizaremos la frase:

```text
Volvamos al HomeLab
```

como recordatorio para volver a la implementación de servicios e infraestructura.

La documentación debe acompañar el crecimiento del HomeLab, nunca reemplazarlo.


------------------------------------

"Construimos para aprender, documentamos para recordar y versionamos para evolucionar"
