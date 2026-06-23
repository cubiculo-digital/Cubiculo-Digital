# 🛠️ TAREA: SEC-03 — Auth en users query
**ID:** #004 | **Estado:** ✅ COMPLETADO | **Fecha:** 2026-06-22

---

## 🎯 OBJETIVO FINAL
> Que la query `users` en GraphQL requiera autenticación JWT, impidiendo que clientes no autenticados puedan leer el listado completo de usuarios registrados.

---

## 🚦 PUNTO DE CONTROL

- **Lo último que funcionó:** FASE 3 completada — Post-Flight + Self-Maintenance sin cambios requeridos.
- **Dónde se rompió/detuvo:** N/A — tarea completada exitosamente.
- **Siguiente acción inmediata:** N/A — tarea finalizada. Pendiente aprobación para PR a `dev-2`.

---

## 📝 CAMBIOS TÉCNICOS CLAVE

- [x] FASE 0: Pre-Flight — `dev-2` verificada, builds verdes
- [x] FASE 1: Bitácora + Rama creada
- [x] FASE 2: Implementar `if (!context.currentUser) throw new Error('No autorizado')` en `users` resolver
- [x] FASE 2: Verificar build API → 0 errors
- [x] FASE 3: Post-Flight + Self-Maintenance — Sin cambios requeridos
- [ ] FASE 4: PR a `dev-2` — Pendiente de aprobación

---

## ⚠️ NOTAS DE MEMORIA

- *Regla:* Toda query protegida DEBE verificar `context.currentUser` (global-context.md §9)
- *Regla:* `users` query requiere autenticación — P0 (api-schema.md §Notas de Seguridad)
- *Regla:* PRs individuales por issue — CTO mindset
- *Regla:* Build DEBE pasar antes de cada commit
- *Branch:* `fix/003-sec-03-auth-users-query`
- *Base:* `dev-2`
- *Archivo target:* `apps/api/src/graphql/index.ts` (línea 61)
- *Patrón:* `me` resolver e interview resolvers como referencia
