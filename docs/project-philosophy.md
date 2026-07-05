# Filosofía del proyecto HomeLab

## 1. Comprender antes de ejecutar

No se ejecutan comandos ni configuraciones sin entender qué hacen, por qué existen y qué problema resuelven.

## 2. Comprender, implementar y documentar

El flujo de trabajo del proyecto es:

1. Comprender el concepto.
2. Implementarlo.
3. Documentar la implementación y la decisión técnica.

## 3. Documentar decisiones, no solo configuraciones

La documentación debe explicar no solo qué se configuró, sino también por qué se eligió ese enfoque.

## 4. Construcción incremental

Cada servicio se incorpora de forma progresiva: diseño, implementación, prueba, documentación, commit y push.

## 5. Cada servicio es un pequeño proyecto

Cada servicio Docker tendrá, como mínimo:

```text
docker/<servicio>/
├── README.md
└── compose.yaml
