# 🛠️ TAREA: SEC-03 — Auth en users query
**ID:** #004 | **Estado:** 🟡 EN CURSO | **Fecha:** 2026-06-22

---

## 🎯 OBJETIVO FINAL
> Que la query `users` en GraphQL requiera autenticación JWT, impidiendo que clientes no autenticados puedan leer el listado completo de usuarios registrados.

---

## 🚦 PUNTO DE CONTROL

- **Lo último que funcionó:** FASE 0 completada — `dev-2` sincronizada, build baseline verde (0 errors), PRs #58 (SEC-01) y #64 (SEC-02) confirmados merged.
- **Dónde se rompió/detuvo:** N/A — recién iniciando implementación.
- **Siguiente acción inmediata:** Ejecutar FASE 2 — implementar guard de autenticación en resolver `users`.

---

## 📝 CAMBIOS TÉCNICOS CLAVE

- [x] FASE 0: Pre-Flight — `dev-2` verificada, builds verdes
- [x] FASE 1: Bitácora + Rama creada
- [ ] FASE 2: Implementar `if (!context.currentUser) throw new Error('No autorizado')` en `users` resolver
- [ ] FASE 2: Verificar build API → 0 errors
- [ ] FASE 3: Post-Flight + Self-Maintenance
- [ ] FASE 4: PR a `dev-2`

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
