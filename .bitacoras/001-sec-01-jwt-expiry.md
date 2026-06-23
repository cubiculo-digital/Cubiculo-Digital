# 🛠️ TAREA: SEC-01 — JWT expiry en signup + login
**ID:** #001 | **Estado:** ✅ COMPLETADO | **Fecha:** 2026-06-16

---

## 🎯 OBJETIVO FINAL
> Que todos los JWT emitidos en signup y login tengan `expiresIn: '1d'`, eliminando el riesgo de tokens sin expiración.

---

## 🚦 PUNTO DE CONTROL

- **Lo último que funcionó:** Auth flow completo — signup y login emiten JWT correctamente, pero sin expiry.
- **Dónde se rompió/detuvo:** N/A — arranque del Día 1 Foundation.
- **Siguiente acción inmediata:** Agregar `{ expiresIn: '1d' }` a `jwt.sign()` en signup y login.

---

## 📝 CAMBIOS TÉCNICOS CLAVE
- [x] Crear bitácora 001-sec-01-jwt-expiry.md
- [x] Crear rama `fix/sec-01-jwt-expiry` desde `dev-2`
- [x] Agregar `expiresIn: '1d'` en `signup` (línea 14)
- [x] Agregar `expiresIn: '1d'` en `login` (línea 24)
- [x] TypeScript check: `pnpm exec tsc --noEmit` — 0 errors
- [x] Tests: 5/5 passing (`pnpm exec vitest run`)
- [x] Commit + Push + PR #58
- [x] GitHub Actions CI en dev-2 (typecheck, lint, test, build)
- [x] GitHub Actions CI: ✅ success (typecheck, lint, test, build)
- [x] PR #58 → https://github.com/cubiculo-digital/Cubiculo-Digital/pull/58

---

## ⚠️ NOTAS DE MEMORIA
- *Regla:* JWT DEBE tener `expiresIn: '1d'` en signup y login (global-context.md §9)
- *Regla:* Verificar JWT expiry en mutations de auth (checklist-verify.md §4)
- *Branch:* `fix/sec-01-jwt-expiry`
- *Archivo modificado:* `apps/api/src/graphql/modules/auth/auth.resolvers.ts`
