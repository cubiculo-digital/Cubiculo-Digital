# 🛠️ TAREA: SEC-02 — Rotar secrets → GitHub Secrets
**ID:** #003 | **Estado:** ✅ COMPLETADO | **Fecha:** 2026-06-20

---

## 🎯 OBJETIVO FINAL
> Rotar todos los secrets expuestos, agregar JWT_SECRET faltante, crear `.env.example` como template seguro, y configurar GitHub Secrets para que CI/CD pueda consumirlos sin valores hardcodeados.

---

## 🚦 PUNTO DE CONTROL

- **Lo último que funcionó:** Diagnóstico completo completado — `.env` contiene credentials reales (DB, Redis, Groq, OpenAI), JWT_SECRET no está en `.env` (cae a fallback hardcoded), GitHub Secrets = 0 configurados.
- **Dónde se rompió/detuvo:** N/A — recién iniciando.
- **Siguiente acción inmediata:** Crear `.env.example` con placeholders + agregar JWT_SECRET a `.env`.

---

## 📝 CAMBIOS TÉCNICOS CLAVE

- [x] Diagnóstico inicial: leer workflows, .env, codebase, estado de GitHub Secrets
- [x] Crear `.env.example` con todos los secrets como placeholders
- [x] Generar `JWT_SECRET` y agregarlo a `.env` (hoy no existe — usa fallback hardcodeado)
- [x] Remover `OPENAI_API_KEY` de `.env` (proyecto usa Groq, no OpenAI)
- [x] Configurar GitHub Secrets via `gh secret set` (13 secrets total):
  - `JWT_SECRET`, `GROQ_API_KEY`, `DATABASE_URL`, `DIRECT_URL`, `REDIS_URL`
  - `VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_API_PROJECT_ID`, `VERCEL_WEB_PROJECT_ID`
  - `STAGING_DATABASE_URL`, `STAGING_DIRECT_URL`
  - `PROD_DATABASE_URL`, `PROD_DIRECT_URL`
- [x] Crear script `scripts/rotate-secrets.sh` para futuras rotaciones
- [x] Actualizar `infra-deploy.md` con inventory actualizado de secrets
- [x] Commit + Push + PR a `dev-2` → https://github.com/cubiculo-digital/Cubiculo-Digital/pull/64

---

## ⚠️ NOTAS DE MEMORIA

- *Regla:* Secrets NUNCA en `.env` comiteado — usar GitHub Secrets (global-context.md §9)
- *Regla:* JWT_SECRET DEBE estar en `.env`, no en fallback hardcodeado (P0)
- *Regla:* OPENAI_API_KEY existe en `.env` pero NO se usa (proyecto usa Groq) — retirar
- *Regla:* PRs individuales por issue — CTO mindset
- *Branch:* `fix/sec-02-rotate-secrets`
- *Base:* `dev-2`
