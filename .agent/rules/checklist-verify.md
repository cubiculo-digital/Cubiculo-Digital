# Checklist de Verificación - Reglas del Proyecto

Este archivo es la fuente de verdad para verificar que sigo las reglas del proyecto antes de cada tarea.

## REGLAS OBLIGATORIAS (En orden de ejecución)

### 1. PRE-FLIGHT CHECK (Antes de cualquier cosa)
- [ ] Ejecutar `git status` para confirmar la rama actual
- [ ] Si estoy en `main` o `dev`, DETENERME y seguir el Git Workflow
- [ ] NUNCA hacer cambios directos en main o dev

### 2. Lectura Obligatoria de Documentación
- [ ] Leer `AGENTS.md` - Configuración del agente
- [ ] Leer `.agent/rules/global-context/global-context.md` - Reglas globales del proyecto (Main Brain)
- [ ] Leer `.agent/rules/checklist-verify.md` - Verificación de reglas (este archivo)
- [ ] Leer `.agent/workflows/git-workflow.md` - Flujo de trabajo Git

### 2.5. Protocolo de Ejecución por Fases (NO NEGOCIABLE)
> Se aplica a TODA tarea con múltiples fases. No hay excepción.
- [ ] Dividir la tarea en fases atómicas (máximo 1-2 archivos por fase)
- [ ] Cada fase debe ser autónoma y verificable de forma independiente
- [ ] Después de CADA fase: STOP -> Build Check -> Commit -> Push -> Bitácora -> Esperar aprobación
- [ ] NO pasar a siguiente fase sin aprobación explícita del usuario
- [ ] NO dar la tarea por COMPLETADA sin aprobación explícita del usuario
- [ ] NO crear PR hasta que tarea esté COMPLETADA, bitácora archivada Y auto-mantenimiento post-flight ejecutado

### 3. Git Workflow (Para cualquier cambio de código)
- [ ] Paso 1: Sincronizar con main y dev
- [ ] Paso 2: Crear rama desde dev usando @git-branch-formatter
- [ ] Paso 3: Desarrollo (implementar cambios de UNA fase solamente)
- [ ] Paso 3.5: Build Check (sección 4.5) + STOP (esperar aprobación entre fases)
- [ ] Paso 4: Commit usando @git-commit-formatter
- [ ] Paso 5: Push a la rama remota
- [ ] Paso 6: Actualizar bitácora (DESPUÉS de push y ANTES de pedir aprobación)

### 3.1. Creación de Bitácora (TRACKEABLE)
- [ ] Usar `@git-branch-formatter` para nombre de rama
- [ ] Crear archivo `.bitacoras/###-nombre-tarea.md` con plantilla ANTES de escribir código
- [ ] El archivo debe existir en el sistema de archivos antes de cualquier cambio
- [ ] NO escribir código hasta que bitácora exista (regla NO negociable)

### 4. Reglas Técnicas
- [ ] Soporte para Dark/Light mode en todos los componentes
- [ ] Usar Tailwind `dark:` prefix para estilos oscuros
- [ ] Seguir naming conventions del proyecto
- [ ] Aplicar Design System (tokens, colores, tipografía)
- [ ] Verificar JWT expiry en mutations de auth
- [ ] Verificar auth en queries protegidas (users, me)
- [ ] Sin imports de OpenAI — solo Groq SDK
- [ ] fetchPolicy explícito en toda query GraphQL nueva

### 4.5. Pre-commit Checklist para TODA tarea (OBLIGATORIO)
> ⚠️ OBLIGATORIO para cualquier tarea, no solo feat/. Ejecutar antes de cada commit.
> El build check es BLOQUEANTE — no commit si falla.
- [ ] Build check: `pnpm run build` (o `build:api`/`build:web` según corresponda) — 0 errores (BLOQUEANTE)
- [ ] `pnpm exec tsc --noEmit` — 0 errors
- [ ] Tests nuevos escritos y pasando
- [ ] Sin secrets en el diff (revisar .env, API keys)
- [ ] Sin código comentado en archivos modificados
- [ ] Branch name sigue convención (@git-branch-formatter)
- [ ] PR description template seguido
- [ ] Reglas técnicas §4 verificadas (dark mode, JWT, auth, fetchPolicy)

### 5. Antes de crear/modificar archivos
- [ ] Verificar que es un cambio necesario (no especulativo)
- [ ] Asegurar que se cumple "Fullstack Integrity Check"
- [ ] Si es funcionalidad nueva: Schema GraphQL + Resolver + Query/Mutation + UI Component

### 6. Post-Flight — Auto-Mantenimiento (Paso 4.5 de AGENTS.md)
> ⚠️ OBLIGATORIO: Ejecutar DESPUÉS de que la bitácora se marque como COMPLETADO
> y ANTES del Pull Request (Paso 7). No saltar. No excepciones.

#### 6.1. Leer self-maintenance.md
- [ ] Leer `.agent/rules/global-context/self-maintenance.md`
- [ ] Aplicar la matriz de actualización línea por línea
- [ ] Revisar los indicadores de auto-mantenimiento

#### 6.2. Determinar si hay cambios
- [ ] Si hay cambios → actualizar archivo(s) correspondiente(s) según la matriz
- [ ] Si NO hay cambios → marcar explícitamente en la bitácora: "Sin cambios requeridos"

#### 6.3. Verificación de builds
- [ ] API: `pnpm run build:api` — 0 errores
- [ ] Web: `pnpm run build:web` — 0 errores

### 7. Pull Request (ÚLTIMO paso)
> ⚠️ Solo después de que la tarea esté COMPLETADA, bitácora archivada Y auto-mantenimiento (sección 6) ejecutado.
- [ ] Verificar que el PR base sea 'dev' (NUNCA main)
- [ ] NUNCA PR a main directamente
- [ ] PR debe ir de rama de trabajo a dev
- [ ] Luego de dev a main

## Notas
- Las secciones 1-5 deben ejecutarse ANTES y DURANTE cada tarea
- La sección **6 (Post-Flight)** debe ejecutarse después de marcar la tarea como COMPLETADO
  y ANTES del Pull Request (sección 7) — es de CUMPLIMIENTO OBLIGATORIO y NO NEGOCIABLE
- El orden de cierre es: COMPLETADO → Auto-Mantenimiento (sección 6) → PR (sección 7)
- Si alguna regla no está clara, consultar la documentación del proyecto
- Las reglas de Git workflow son de CUMPLIMIENTO OBLIGATORIO y NO NEGOCIABLE
