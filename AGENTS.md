# Cubículo Digital — OpenCode Agent Config

## 🚨 PROTOCOLO DE INICIO Y GESTIÓN DE MEMORIA

**Antes de realizar cualquier acción, DEBES ejecutar este proceso lógico de triaje, lectura y sincronización de bitácora:**

### 1. Clasificación del Ámbito (Triaje)
Identifica la categoría de la tarea:
*   **ÁMBITO EXENTO:** Cambios en `.gitignore`, configuraciones de IA (`.agent/`, `.opencode/`, `AGENTS.md`) o pruebas locales.
*   **ÁMBITO TRACKEABLE:** Código fuente (`apps/web/`, `apps/api/`, `packages/`), assets, documentación oficial o producción.

### 1.5. VERIFICACIÓN OBLIGATORIA (Antes de proceder)
> Esta verificación es DE CUMPLIMIENTO OBLIGATORIO - NO PUEDES SALTARLA

Para **cualquier tarea** (Exenta o Trackeable):

1. **PRE-FLIGHT CHECK:**
   - [ ] Ejecutar `git status` para confirmar la rama actual
   - [ ] Si existe PR abierto, verificar que la base sea `dev` (NUNCA `main`)

2. **LECTURA OBLIGATORIA:**
   - [ ] Leer `.bitacoras/index.md` (contexto del proyecto)
   - [ ] Leer `.bitacoras/actual.md` (tarea activa)
   - [ ] Leer `.agent/rules/checklist-verify.md` (verificación de reglas)
   - [ ] Si la tarea es de tipo `feat/`, leer `.agent/skills/feature-implementation/SKILL.md` (proceso de implementación)

3. **INICIALIZACIÓN DE BITÁCORA (Solo para TRACKEABLE):**
   - [ ] Usar `@git-branch-formatter` para nombre de rama
   - [ ] Crear archivo `.bitacoras/###-nombre-tarea.md` ANTES de escribir código
   - [ ] Usar plantilla de `00-plantilla.md`
   - [ ] NO escribir ninguna línea de código hasta que la bitácora exista

4. **PROCEDER** solo después de completar los pasos anteriores.

---

### 2. Ejecución y Sincronización Viva

#### 🟢 SI LA TAREA ES "EXENTA":
1. **Omitir Workflow:** No crear ramas de Git ni bitácoras.
2. **Validación:** Presentar el **"Prompt de Verificación (Tarea Exenta)"** con el plan de acción.
3. **Ejecución:** Proceder tras aprobación. No requiere actualizar memoria histórica.

#### 🔴 SI LA TAREA ES "TRACKEABLE" (Bitácora Viva):
1. **Lectura Obligatoria:** Leer `.bitacoras/index.md` y `.bitacoras/actual.md` antes de proponer nada.
2. **Inicialización Activa:** Al aprobarse el plan, inicializar/actualizar `.bitacoras/actual.md` con estado `🟡 EN CURSO`.
3. **Actualización en Tiempo Real:** DEBES editar el archivo `actual.md` tras cada hito completado (marcando checks `[x]` y actualizando el `## 🚦 PUNTO DE CONTROL`). No esperes al final de la sesión.
4. **Cierre:** Al finalizar, cambiar estado a `✅ COMPLETADO`, archivar el contenido y limpiar `actual.md`, al limpiar `actual.md` DEBES MANTENER el formato de `.bitacoras/00-plantilla.md` (NO NEGOCIABLE).

4.5. **AUTO-MANTENIMIENTO (Post-Flight):** Tras marcar la tarea como `✅ COMPLETADO`, ejecutar el protocolo definido en `.agent/rules/global-context/self-maintenance.md`. Si la tarea implicó cambios arquitectónicos (nuevos patrones, stack, rutas, reglas), actualizar los archivos de configuración del agente correspondientes ANTES del paso 5.

5. **Workflow:** Seguir estrictamente Git Workflow y estándares de naming.

---

## 🧠 REGLA DE EFICIENCIA Y RAZONAMIENTO ESTRATÉGICO

**Para maximizar la productividad y el aprendizaje, sigue estas directrices:**

1. **Sin Preámbulos:** No confirmes lecturas ni saludes. Si es **Trackeable**, lee en silencio y actúa.
2. **Razonamiento Cognitivo:** Antes de cambios complejos, usa el bloque `> [Pensamiento Técnico]`. Explica el *porqué* estratégico, patrones elegidos o riesgos. Aporta aprendizaje, no obviedades.
3. **Comunicación Estructurada:** Prioriza tablas, listas y bloques de código. La información debe ser escaneable.
4. **Concisión Técnica Senior:** Lenguaje directo. Cero explicaciones de conceptos básicos (React, Git, etc.) a menos que se solicite.
5. **Edición Silenciosa:** Actualiza la bitácora `actual.md` sin anunciar cada edición, a menos que el progreso cambie el plan aprobado.

---

## 🛠️ SOURCES OF TRUTH & TOOLS

### 📖 Rules & Standards
- **Global Context:** `.agent/rules/global-context/global-context.md` (Master Rules).
- **Design System:** `.agent/rules/design-system/index.md` (Cargar siempre para `apps/web/`).
- **Git Workflow:** `.agent/workflows/git-workflow.md` (Cumplimiento NO negociable).
- **API & Schema:** `.agent/rules/global-context/api-schema.md` (GraphQL + Prisma).
- **Infra & Deploy:** `.agent/rules/global-context/infra-deploy.md` (Docker, Vercel, Redis).
- **Product Vision:** `.agent/rules/global-context/product-vision.md` (Visión, personas, costos).
- **Product Roadmap:** `.agent/rules/global-context/product-roadmap.md` (Backlog, milestones).
- **Refactor Plan:** `.agent/rules/global-context/refactor-plan.md` (Fases activas, dependencias).
- **Feature Standards:** `.agent/skills/feature-implementation/SKILL.md` (Skill para nuevas features).

### 🤖 Agents & Skills
- **Plan Agent:** Para análisis y desglose (sin escritura).
- **Build Agent:** Para implementación. Incluye `code-reviewer` automáticamente.
- **Tools:**
  - `@git-branch-formatter` (Uso obligatorio para ramas).
  - `@git-commit-formatter` (Uso obligatorio para commits).
  - `@feature-implementation` (Proceso completo para nuevas features — cargar en tareas `feat/`).
