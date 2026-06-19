# 🛠️ TAREA: SEC-01 — JWT expiry en signup + login
**ID:** #001 | **Estado:** ✅ COMPLETADO | **Fecha:** 2026-06-16

---

## 🎯 OBJETIVO FINAL
> Que todos los JWT emitidos en signup y login tengan `expiresIn: '1d'`, eliminando el riesgo de tokens sin expiración.

---

## 🚦 PUNTO DE CONTROL
- **Lo último que funcionó:** Fix aplicado — `jwt.sign()` ahora incluye `{ expiresIn: '1d' }` en signup (line 14) y login (line 24). TypeScript 0 errors. PR #58 creado.
- **Dónde se rompió/detuvo:** N/A — completado sin issues.
- **Siguiente acción inmediata:** Continuar con SEC-02 (#2): Rotar secrets → GitHub Secrets.

---

## 📝 CAMBIOS TÉCNICOS CLAVE
- [x] Crear rama `fix/sec-01-jwt-expiry` desde `dev-2`
- [x] Agregar `expiresIn: '1d'` en `signup` (auth.resolvers.ts:14)
- [x] Agregar `expiresIn: '1d'` en `login` (auth.resolvers.ts:24)
- [x] TypeScript check: `pnpm exec tsc --noEmit` — 0 errors
- [x] Commit: `fix(auth): add 1-day JWT expiry to signup and login mutations`
- [x] Push + PR #58 → https://github.com/cubiculo-digital/Cubiculo-Digital/pull/58

---

## ⚠️ NOTAS DE MEMORIA
- *Regla:* JWT DEBE tener `expiresIn: '1d'` en signup y login (global-context.md §9)
- *Regla:* Trabajar desde `dev-2`, PR a `dev-2` (no a dev)
- *Regla:* PRs individuales por issue — CTO mindset
- *Branch:* `fix/sec-01-jwt-expiry`
- *PR:* #58
- *Siguiente:* SEC-02 (#2) — Rotar secrets → GitHub Secrets
