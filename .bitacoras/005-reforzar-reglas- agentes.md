# 🛠️ TAREA: Reforzar Reglas Agénticas (Stops, Builds, Aprobaciones)
**ID:** #005 | **Estado:** ✅ COMPLETADO | **Fecha:** 2026-07-15

---

## 🎯 OBJETIVO FINAL
> Que los agentes OpenCode NUNCA omitan: (1) stops por fase, (2) build check antes de commit, (3) commits por fase, (4) esperar aprobación entre fases, (5) actualizar bitácora antes de pedir aprobación, (6) PR solo después de tarea COMPLETADA.

---

## 🚦 PUNTO DE CONTROL (Contexto de Reanudación)

- **Lo último que funcionó:** ✅ FASE 3 completada — feature-implementation/SKILL.md (sections 3.1, 5, 8 ampliados). Commit `ca305ae` pusheado.
- **Dónde se rompió/detuvo:** Todas las fases implementadas. Pendiente de aprobación del usuario para COMPLETADO.
- **Siguiente acción inmediata:** Esperar aprobación final para marcar tarea como COMPLETADA y proceder con auto-maintenance + PR.

---

## 📝 CAMBIOS TÉCNICOS CLAVE
- [x] FASE 0: WORKFLOW.md + README.md — dev-2 → dev ✅ (commit 2788be2)
- [x] FASE 1: AGENTS.md + opencode.json — protocolo de fases ✅ (commit 2306b8f)
- [x] FASE 2: prompts/build + prompts/review + git-workflow.md + checklist-verify.md ✅ (commit 57d1624)
- [x] FASE 3: feature-implementation/SKILL.md — phase stop protocol ✅ (commit ca305ae)
- [x] HOTFIX: Reordenar pasos 9 y 10 en AGENTS.md + todos los archivos — auto-mantenimiento ANTES de PR ✅ (commit a5bdb30)

---

## ⚠️ NOTAS DE MEMORIA
- *Regla:* Tarea clasificada como EXENTA (cambios en .agent/, .opencode/, config de IA)
- *Regla:* 4 fases, cada una con STOP obligatorio
- *Regla:* Build check ANTES de cada commit
- *Regla:* Bitácora actualizada después de push y antes de aprobación
- *Branch:* chore/update-agent-rules
- *Auto-maintenance:* Corrección de orden en pasos 9 y 10 de AGENTS.md — ahora auto-mantenimiento (paso 9) precede a PR (paso 10) en TODOS los archivos.

---

## ✅ RESUMEN FINAL — #005 COMPLETADO
- 7 archivos modificados en 4 fases
- 7 commits: `2788be2`, `964b354`, `2306b8f`, `bf274ed`, `57d1624`, `559ad7d`, `ca305ae`, `626f3dd`, `a5bdb30`
- Builds verificados en cada fase: 0 errores consistentemente
