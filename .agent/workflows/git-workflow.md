---
description: Flujo de trabajo profesional de Git (sincronización, ramas y commits estandarizados)
---

# Flujo de Trabajo de Git (Git Workflow)

Este workflow define los pasos estandarizados y obligatorios para trabajar de forma segura en el proyecto. Asegura que el entorno remoto y local estén siempre sincronizados y que las convenciones de nomenclatura (ramas y mensajes) se respeten utilizando nuestras skills.

## 0. PRE-FLIGHT CHECK (Regla Cero Estricta)
*Antes de realizar CUALQUIER cambio en el código o crear archivos, DEBES validar tu entorno:*
1. Ejecuta `git status` para confirmar en qué rama te encuentras.
2. Si estás en `main` o `dev`, **DETENTE OBLIGATORIAMENTE**. NO puedes editar ni hacer commits. Ve directamente al Paso 1.

## 1. Sincronización Inicial
*Antes de empezar a codificar o modificar configuraciones, debes sincronizar tu entorno local con el remoto.*

1. Haz checkout y actualiza la rama de producción (`main`):
   ```bash
   git checkout main
   git pull origin main
   ```
2. Limpia referencias remotas obsoletas (ejecutado desde `main`):
   ```bash
   git fetch --prune
   ```
3. Haz checkout y actualiza la rama de desarrollo (`dev`):
   ```bash
   git checkout dev
   git pull origin dev
   ```

## 2. Creación de la Rama de Trabajo
*Todo cambio debe realizarse en una rama nueva que nazca exclusivamente de `dev`.*

1. DEBES INVOCAR la skill **@git-branch-formatter** para determinar el nombre correcto de la rama según lo que se va a desarrollar. NO DEBES inventar un nombre tu misma.
2. Crea y muévete a la nueva rama desde `dev`:
   ```bash
   git checkout -b <nombre-rama-nueva>
   ```
3. Inmediatamente después de crearla, sube la rama y configúrala para rastrear la remota:
   ```bash
   git push origin <nombre-rama-nueva> --set-upstream
   ```

## 3. Desarrollo
*Detente y analiza los requerimientos Fullstack (API/Web) basándote en @global-context antes de generar archivos.*

## 3.5. Protocolo de Stops por Fase — OBLIGATORIO (NO NEGOCIABLE)
*Este protocolo se ejecuta entre el desarrollo de cada fase y el commit. Aplica a TODA tarea que requiera más de un paso.*

1. **STOP:** Después de implementar los cambios de UNA fase, DETENTE. NO continúes a la siguiente fase.
2. **BUILD CHECK:** Ejecuta el build respectivo:
   - `pnpm run build:api` — 0 errores (si la fase toca apps/api)
   - `pnpm run build:web` — 0 errores (si la fase toca apps/web)
   - `pnpm run build` — 0 errores (si toca ambos o archivos de configuración)
   - Si falla -> corrige errores. NO sigas, NO comitees.
3. **Solo después de build verde**, procede a la sección 4 (Commit).
4. **PUSH** inmediato después del commit (sección 5).
5. **BITÁCORA:** Actualiza `.bitacoras/actual.md` con el progreso de la fase.
6. **APROBACIÓN:** Espera la aprobación explícita del usuario. NO pases a la siguiente fase sin aprobación.

> ⚠️ Regla: Una fase = un commit. Si la tarea tiene múltiples fases, cada fase produce exactamente un commit con su build check.

## 4. Confirmación de Cambios (Commit)
*Una vez terminados tus cambios y verificado el build (sección 3.5), guárdalos siguiendo las convenciones.*

1. Añade todos los archivos modificados al área de preparación:
   ```bash
   git add .
   ```
2. Usa la skill **@git-commit-formatter** para generar un mensaje de commit profesional bajo el estándar de *Conventional Commits*.
3. Realiza el commit con el mensaje autogenerado:
   ```bash
   git commit -m "<mensaje-generado>"
   ```

## 5. Empujar Cambios
*Publica tu trabajo en la rama remota correspondiente.*

1. Sube los commits a tu rama en el origen:
   ```bash
   git push
   ```
