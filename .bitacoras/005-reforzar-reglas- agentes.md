# 🛠️ TAREA: Reforzar Reglas Agénticas (Stops, Builds, Aprobaciones)
**ID:** #005 | **Estado:** 🟡 EN CURSO | **Fecha:** 2026-07-15

---

## 🎯 OBJETIVO FINAL
> Que los agentes OpenCode NUNCA omitan: (1) stops por fase, (2) build check antes de commit, (3) commits por fase, (4) esperar aprobación entre fases, (5) actualizar bitácora antes de pedir aprobación, (6) PR solo después de tarea COMPLETADA.

---

## 🚦 PUNTO DE CONTROL (Contexto de Reanudación)

- **Lo último que funcionó:** ✅ FASE 2 completada — build.txt (phase protocol), review.txt (build verification), git-workflow.md (section 3.5), checklist-verify.md (section 2.5 + 4.5 ampliado). Commit `57d1624` pusheado.
- **Dónde se rompió/detuvo:** Pendiente de aprobación para continuar a FASE 3.
- **Siguiente acción inmediata:** Esperar aprobación para FASE 3 (feature-implementation/SKILL.md + refinamientos finales).

---

## 📝 CAMBIOS TÉCNICOS CLAVE
- [x] FASE 0: WORKFLOW.md — reemplazar dev-2 por dev ✅ (commit 2788be2)
- [x] FASE 1: AGENTS.md + opencode.json — protocolo de fases ✅ (commit 2306b8f)
- [x] FASE 2: prompts/build + prompts/review + git-workflow.md + checklist-verify.md ✅ (commit 57d1624)
- [ ] FASE 3: feature-implementation/SKILL.md + refinamientos finales

---

## ⚠️ NOTAS DE MEMORIA
- *Regla:* Tarea clasificada como EXENTA (cambios en .agent/, .opencode/, config de IA)
- *Regla:* 4 fases, cada una con STOP obligatorio
- *Regla:* Build check ANTES de cada commit
- *Regla:* Bitácora actualizada después de push y antes de aprobación
- *Branch:* chore/agent-phase-enforcement
