# 🗺️ MAPA DE BITÁCORAS

## ⚠️ IMPORTANTE - LEE ESTO PRIMERO
**Antes de continuar con cualquier tarea, DEBES leer `.bitacoras/actual.md` para obtener el contexto actual del proyecto.**

---

## 🚩 ESTADO ACTUAL
- **Tarea activa:** ⏸ Sin tarea activa — esperando instrucciones
- **Última completada:** #005 — Reforzar Reglas Agénticas (Stops, Builds, Aprobaciones) ✅
- **Branch actual:** `dev` (staging/desarrollo)
- **Deploy pendiente:** No hay deploys activos
- **Archivo de referencia rápida:** `actual.md`
- **Documento de visión:** PRD2.md (fuente de verdad del producto)
- **Plan de guerra:** PLAN_DE_GUERRA.md (54 issues, 6 milestones, daily battle plan)

---

## 📂 HISTORIAL DE TAREAS
- **#005 — Reforzar Reglas Agénticas (Stops, Builds, Aprobaciones)** (2026-07-15) ✅ — Protocolo de fases con stops en AGENTS.md, opencode.json, prompts, git-workflow, checklist-verify y feature-implementation skill. PR mergeado a dev.
- **#004 — SEC-04: Logging unificado [GROQ_*]** (2026-06-23) ✅ — 2 líneas migradas `[OPENAI_*]` → `[GROQ_*]` en `interview.resolvers.ts`, PR #73 mergeado a dev-2
- **#002 — GitHub Full Setup** (2026-06-14) ✅ — Org, repo, branch protection, labels, milestones, 54 issues, Projects board poblado
- **#001 — Configuración agéntica inicial** (2026-06-12) ✅ — AGENTS.md, opencode.json, reglas, skills, workflows, bitácoras

---

## 🛠️ REGLAS DE ORO (DE CUMPLIMIENTO OBLIGATORIO)

### 📋 PLANTILLA DE BITÁCORA (OBLIGATORIO SEGUIR)
> Todas las bitácoras DEBEN seguir la estructura definida en `00-plantilla.md`

**Ver plantilla completa:** [.bitacoras/00-plantilla.md](./00-plantilla.md)

---

### 📖 Documentación Obligatoria (LEER SIEMPRE)
> Estas son tus fuentes de verdad - NO NEGOCIABLE

1. **AGENTS.md** - Configuración del agente y reglas fundamentales
2. **.agent/rules/global-context/global-context.md** - Reglas globales del proyecto (Tech Stack, Arquitectura, Calidad)
3. **PRD2.md** - Product Requirements Document (visión del producto, backlog, roadmap)

### 🖼️ Design System
- **.agent/rules/design-system/index.md** - Tokens, colores, componentes
- **Regla:** Usar Tailwind `dark:` prefix para estilos oscuros
- **Regla:** Usar `cn()` para conditional classes

### 🔧 Git Workflow (CUMPLIMIENTO OBLIGATORIO)
- **.agent/workflows/git-workflow.md** - Flujo de trabajo completo
- **Regla:** NUNCA hacer cambios directo en `main` o `dev`
- **Regla:** SIEMPRE sincronizar con main y dev antes de crear rama
- **Regla:** Usar @git-branch-formatter para nombres de ramas
- **Regla:** Usar @git-commit-formatter para mensajes de commit
- **Regla:** NUNCA PR directamente a main - PRIMERO a dev

### 📋 Checklist de Verificación
- **.agent/checklist-verify.md** - Checklist obligatorio antes de cada tarea

### 🗂️ Prompts del Sistema
- **.opencode/prompts/build.txt** - Instrucciones para el agente build
- **.opencode/prompts/review.txt** - Instrucciones para el agente review

---

## 📊 FLUJO DE TRABAJO RECOMENDADO

```
1.  **TRIAGE INICIAL:** Determinar el ámbito de la tarea.
    *   **¿Es EXENTA?** (Cambios en `.gitignore`, configuraciones de IA como `.agent/`, `.opencode/` o archivos locales temporales).
        *   👉 **Acción:** Presentar Plan de Acción breve -> Obtener aprobación -> Ejecutar. (Fin del flujo).
    *   **¿Es TRACKEABLE?** (Código fuente en `apps/web/`, `apps/api/` o `packages/`, assets, DB o config de prod).
        *   👉 **Acción:** Continuar al paso 2.

2.  **INMERSIÓN DE CONTEXTO:**
    *   LEER `.bitacoras/index.md` (este archivo).
    *   LEER `.bitacoras/actual.md` para entender el estado de la misión.
    *   LEER `PRD2.md` para visión del producto y backlog.
    *   Consultar `.agent/rules/global-context/global-context.md` y `.agent/rules/design-system/index.md` para asegurar cumplimiento técnico y visual.

3.  **PREPARACIÓN DE ENTORNO (Git):**
    *   Sincronizar con `main` y `dev`.
    *   Crear rama desde `dev` usando `@git-branch-formatter`.

4.  **PLANIFICACIÓN Y EJECUCIÓN:**
    *   Presentar Plan de Acción detallado.
    *   Ejecutar **PRE-FLIGHT CHECK** antes de escribir código.
    *   Implementar cambios siguiendo los estándares de naming y arquitectura.

5.  **FINALIZACIÓN Y REGISTRO:**
    *   Realizar Commit usando `@git-commit-formatter`.
    *   Subir rama (Push) y preparar PR hacia `dev` (NUNCA a `main`).
    *   Actualizar `.bitacoras/actual.md` y crear/actualizar la bitácora correspondiente según `00-plantilla.md`.
```

---

*Actualizado: 2026-06-12*
*Configuración agéntica inicial completada*
