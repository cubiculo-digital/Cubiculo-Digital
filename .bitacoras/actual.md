# 🛠️ TAREA: GitHub Full Setup + Issues + Projects Board
**ID:** #002 | **Estado:** ✅ COMPLETADO | **Fecha:** 2026-06-14

---

## 🎯 OBJETIVO FINAL
> Configurar GitHub completo: org, repo, branch protection, labels, milestones, 54 issues, y Projects board poblado con campos personalizados.

---

## 🚦 PUNTO DE CONTROL
- **Lo último que funcionó:** Verificación final — 54 issues open + 1 closed (duplicado), 55 items en Projects board con todos los campos personalizados configurados (Priority, Track, Day, Department, Estimate).
- **Dónde se rompió/detuvo:** N/A — tarea completada.
- **Siguiente acción inmediata:** Esperar instrucciones para comenzar el backlog del Día 1 (F-01 JWT expiry, F-02 Secrets, etc.)

---

## 📝 CAMBIOS TÉCNICOS CLAVE
- [x] Org `cubiculo-digital` creada + repo transferido + remote actualizado
- [x] Branch protection (dev + dev-2): 1 approval, linear history, enforce admins
- [x] Repo settings: squash merge, auto-delete branches, auto-merge
- [x] 6 workflows: ci, deploy-staging, deploy-prod, security, pr-quality
- [x] Issue templates: agent-implementation, feature-implementation, bug-report
- [x] 34+ labels: 8 agent/*, 4 priority/*, 6 day/*, 7 track/*, 4 meta + defaults
- [x] 6 milestones: MS-1 through MS-6
- [x] Projects board: 5 custom fields (Priority, Track, Day, Department, Estimate)
- [x] 54 issues creados (MS-1 a MS-6) con labels y milestones
- [x] Todos los issues agregados al Projects board con campos configurados

---

## ⚠️ NOTAS DE MEMORIA
- *Regla:* `dev` = producción, `dev-2` = staging. NUNCA push directo a dev.
- *Regla:* gh v2.4.0 no soporta `gh label` ni `--comment` flag — usar `gh api` como workaround
- *Regla:* Ejecución en paralelo con `&` puede causar race conditions en asignación de issue numbers
- *Branch:* `dev-2` (todo el trabajo en dev-2, PR a dev)
- *Board:* https://github.com/orgs/cubiculo-digital/projects/1