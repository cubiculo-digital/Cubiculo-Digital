# 🛠️ TAREA: Reforzar Reglas Agénticas (Stops, Builds, Aprobaciones)
**ID:** #005 | **Estado:** 🟡 EN CURSO | **Fecha:** 2026-07-15

---

## 🎯 OBJETIVO FINAL
> Que los agentes OpenCode NUNCA omitan: (1) stops por fase, (2) build check antes de commit, (3) commits por fase, (4) esperar aprobación entre fases, (5) actualizar bitácora antes de pedir aprobación, (6) PR solo después de tarea COMPLETADA.

---

## 🚦 PUNTO DE CONTROL (Contexto de Reanudación)

- **Lo último que funcionó:** Plan aprobado, arrancando ejecución.
- **Dónde se rompió/detuvo:** N/A — inicio de tarea.
- **Siguiente acción inmediata:** Ejecutar FASE 0 — Reemplazar "dev-2" -> "dev" en WORKFLOW.md.

---

## 📝 CAMBIOS TÉCNICOS CLAVE
- [ ] FASE 0: WORKFLOW.md — reemplazar dev-2 por dev
- [ ] FASE 1: AGENTS.md + opencode.json — agregar protocolo de fases
- [ ] FASE 2: prompts/build + prompts/review + git-workflow.md + checklist-verify.md
- [ ] FASE 3: feature-implementation/SKILL.md + refinamientos finales

---

## ⚠️ NOTAS DE MEMORIA
- *Regla:* Tarea clasificada como EXENTA (cambios en .agent/, .opencode/, config de IA)
- *Regla:* 4 fases, cada una con STOP obligatorio
- *Regla:* Build check ANTES de cada commit
- *Regla:* Bitácora actualizada después de push y antes de aprobación
- *Branch:* chore/agent-phase-enforcement
