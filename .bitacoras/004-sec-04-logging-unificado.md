# 🛠️ TAREA: SEC-04 — Logging unificado [GROQ_*]
**ID:** #004 | **Estado:** ✅ COMPLETADO | **Fecha:** 2026-06-23

---

## 🎯 OBJETIVO FINAL
> Reemplazar todo prefijo `[OPENAI_*]` → `[GROQ_*]` en logs activos de `interview.resolvers.ts`, eliminando referencias a OpenAI/GPT-4 en los mensajes de logging de la API.

---

## 🚦 PUNTO DE CONTROL (Contexto de Reanudación)

- **Lo último que funcionó:** FASE 1-3 completadas — 2 líneas editadas, build exitoso, push a remoto.
- **Dónde se rompió/detuvo:** N/A — todo fluyó sin bloqueos.
- **Siguiente acción inmediata:** Esperar aprobación final del PR por parte del usuario.

---

## 📝 CAMBIOS TÉCNICOS CLAVE
- [ ] FASE 0: Pre-flight & setup (rama + bitácora) — COMPLETADO
- [x] FASE 1: Implementación (editar 2 líneas en `interview.resolvers.ts`)
- [x] FASE 2: Commit & push
- [x] FASE 3: CI verification
- [x] FASE 4: Pull Request — CREADO

---

## 📸 DIFF DE CAMBIOS
```
- console.log(`[OPENAI_INVOKE] Enviando ${x} respuestas a GPT-4`);
+ console.log(`[GROQ_INVOKE] Enviando ${x} respuestas a Llama-3.3-70b`);

- console.error(`[OPENAI_ERROR] OpenAI devolvió contenido vacío para ${uid}`);
+ console.error(`[GROQ_ERROR] Groq devolvió contenido vacío para ${uid}`);
```

---

## ⚠️ NOTAS DE MEMORIA
- *Regla:* Prefijo correcto es `[GROQ_*]` — NUNCA `[OPENAI_*]` (Z-02 technical-rules.md)
- *Regla:* Solo tocar código activo, no comentado (CLEAN-05 es otra tarea)
- *Branch:* `feat/sec-04-logging-unificado-groq`
- *Archivo afectado:* `apps/api/src/graphql/modules/interview/interview.resolvers.ts` (líneas 54 y 61)
- *Base:* `dev-2`
