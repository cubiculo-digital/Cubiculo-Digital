# 🏢 Cubículo Digital

> **Transformamos conocimiento tácito en activos estratégicos.**
> 8 agentes de IA. 1 orquestador. 0 pérdida de información.

[![CI Status](https://github.com/cubiculo-digital/Cubiculo-Digital/actions/workflows/ci.yml/badge.svg)](https://github.com/cubiculo-digital/Cubiculo-Digital/actions/workflows/ci.yml)
[![Security Scan](https://github.com/cubiculo-digital/Cubiculo-Digital/actions/workflows/security.yml/badge.svg)](https://github.com/cubiculo-digital/Cubiculo-Digital/actions/workflows/security.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

---

## 🔥 El problema

Cada vez que un empleado clave se va de una startup, **se lleva el conocimiento en la cabeza**.

No hay documento. No hay transición. Solo silencio y horas de "¿cómo hacía esto Juan?".

Las empresas gastan millones en tecnología, pero **su conocimiento más valioso sigue siendo oral**. El 70% de la información crítica de una PYME nunca se documenta. Y el 30% que se documenta, está desactualizada a los 3 meses.

Esto no es un problema de HR. Es un problema de **supervivencia**.

---

## 🚀 La solución

**Cubículo Digital** es un ecosistema de **8 agentes de IA especializados** que entrevistan, analizan y documentan el conocimiento corporativo de forma estructurada.

Cada agente actúa como un **consultor experto en su departamento**:

| Agente | Rol | Preguntas que analiza |
|--------|-----|-----------------------|
| 🧠 **Estrategia** | Director de Planificación | Q1, Q4, Q7 |
| 💰 **Ventas** | VP de Revenue | Q2, Q3, Q6 |
| ⚙️ **Operaciones** | COO | Q5 |
| 👥 **RRHH** | Chief People Officer | Q8 |
| 💳 **Finanzas** | CFO Advisor | Q9 |
| 💻 **Tecnología** | CTO Advisor | Q10 |
| 📣 **Marketing** | CMO Advisor | Q11 |
| ⚖️ **Legal** | General Counsel | Q7 (compartida) |

Y un **Orchestrator** que los coordina, sintetiza y genera la **Biblia Corporativa**: un reporte unificado con executive summary, análisis departamental, cross-department insights y plan estratégico.

### ¿Por qué agentes y no un monolito?

```
MONOLITO (antes)                    SISTEMA DE AGENTES (ahora)
─────────────────                   ─────────────────────────
1 llamada Groq                      8 agentes + 1 orchestrator
1 muro de texto                     Output estructurado por depto
Sin granularidad                    "¿Qué dijo Ventas?" → 1 clic
No extensible                       Nuevo depto = nuevo agente
Demo pobre                          Demo: 8 consultores trabajando
```

---

## 🏛️ Arquitectura

```
┌─────────────────────────────────────────────────────┐
│                      CLIENTE                         │
│         Next.js 15 + Tailwind 4 + Apollo            │
│         i18n (EN/ES) + Dark Mode                    │
└──────────────────────┬──────────────────────────────┘
                       │ GraphQL (Yoga)
┌──────────────────────▼──────────────────────────────┐
│                       API                            │
│         Node.js 20 + GraphQL Yoga + JWT Auth         │
│                                                      │
│    ┌──────────────────────────────────────────┐     │
│    │          ORCHESTRATOR AGENT               │     │
│    │  routing → process → synthesize → report  │     │
│    └──┬───┬───┬───┬───┬───┬───┬───┬──────────┘     │
│       │   │   │   │   │   │   │   │                 │
│       ▼   ▼   ▼   ▼   ▼   ▼   ▼   ▼                 │
│     Estr Ven Op  RRHH Fin Tec Mkt Leg               │
│     Agent Registry (singleton)                       │
└──────────────────────┬──────────────────────────────┘
                       │ Prisma
┌──────────────────────▼──────────────────────────────┐
│              PostgreSQL (Supabase)                   │
│     + Redis (Upstash) para rate limiting + APQ       │
└─────────────────────────────────────────────────────┘
                       │ Groq API (Llama 3.3-70b)
┌──────────────────────▼──────────────────────────────┐
│              Groq Cloud (10x faster)                 │
└─────────────────────────────────────────────────────┘
```

### Stack

| Capa | Tecnología | Por qué |
|------|-----------|--------|
| Frontend | Next.js 15 + Tailwind 4 + Apollo Client | App Router, RSC, dark mode nativo |
| Backend | Node.js 20 + GraphQL Yoga | Liviano, APQ, ESM |
| ORM | Prisma 5 | Type-safe, migrations automáticas |
| DB | PostgreSQL (Supabase) | Serverless, 500MB gratis |
| Cache | Redis (Upstash) | Rate limiting + APQ |
| AI | Groq (Llama 3.3-70b) | 10x más rápido que OpenAI, gratis |
| Auth | JWT + bcryptjs | Zero external dependencies |
| Monorepo | pnpm workspaces | 3x más rápido que npm |

---

## ⚡ Quick start (30 segundos)

```bash
# 1. Clonar
git clone https://github.com/cubiculo-digital/Cubiculo-Digital.git
cd Cubiculo-Digital

# 2. Instalar
pnpm install

# 3. Configurar variables de entorno
cp .env.example .env
# Editar .env con tus keys (ver sección "Variables de entorno")

# 4. Migrar DB
pnpm run db:migrate

# 5. Iniciar
pnpm run dev
```

Abrí [http://localhost:3000](http://localhost:3000). Listo.

### Variables de entorno

```env
# Base de datos
DATABASE_URL="postgresql://user:pass@host:port/db"

# Autenticación
JWT_SECRET="openssl rand -base64 32"
JWT_EXPIRES_IN="15m"

# APIs externas
GROQ_API_KEY="gsk_..."
UPSTASH_REDIS_URL="..."
UPSTASH_REDIS_TOKEN="..."

# App
NEXT_PUBLIC_API_URL="http://localhost:4000"
NODE_ENV="development"
```

### Comandos útiles

```bash
pnpm run dev          # Iniciar dev (web + api)
pnpm run build        # Build production
pnpm run test         # Tests
pnpm run lint         # ESLint
pnpm run typecheck    # TypeScript strict
pnpm run db:studio    # Prisma Studio (ver DB)
```

---

## 🧪 Testing

| Tipo | Herramienta | Threshold |
|------|------------|-----------|
| Unit | Vitest | >70% line coverage |
| Lint | ESLint + Prettier | 0 warnings |
| Type | TypeScript strict | 0 errors |
| E2E | Playwright (próximamente) | — |

```bash
pnpm run test          # Full suite
pnpm run test:watch    # Modo watch
pnpm run test:coverage # Reporte coverage
```

---

## 🤖 ¿Cómo funciona el sistema de agentes?

### 1. El usuario responde 11 preguntas
Una entrevista estructurada que cubre todas las áreas de la empresa.

### 2. El Orchestrator las rutea a los agentes correctos
Cada pregunta va al agente del departamento correspondiente. Un agente puede recibir múltiples preguntas.

### 3. Cada agente procesa y devuelve un output estructurado
```
{
  department: "ventas",
  answers: [{ questionId, analysis, score, recommendations }],
  confidenceScore: 0.92,
  processingTimeMs: 1200
}
```

### 4. El Orchestrator sintetiza todo en la Biblia Corporativa
Un reporte unificado que incluye executive summary, análisis por departamento, insights transversales y plan estratégico.

### 5. El usuario puede exportar, ver feedback history y analizar métricas
JSON, CSV, dashboard en tiempo real, charts de madurez por departamento.

---

## 📦 Proyecto en estructura

```
cubiculo-digital/
├── apps/
│   ├── api/          ← GraphQL API + Agentes
│   │   └── src/
│   │       ├── core/agents/     ← Sistema de agentes
│   │       └── graphql/modules/ ← Resolvers por feature
│   └── web/          ← Next.js frontend
│       └── src/
│           ├── app/[locale]/    ← i18n routing
│           ├── views/           ← Page views
│           └── components/      ← UI components
├── packages/
│   ├── types/        ← Tipos compartidos (agent.types.ts)
│   ├── config/       ← ESLint, Prettier, TypeScript base
│   └── db/           ← Prisma schema + migrations
├── .github/          ← Workflows + templates
└── PLAN_DE_GUERRA.md ← Estrategia del hackathon
```

---

## 🗺️ Roadmap (6 días)

| Día | Milestone | ¿Qué se entrega? |
|-----|-----------|-----------------|
| 1 | **Foundation** | Seguridad, CI/CD, tipos base, DB, BaseAgent |
| 2 | **Agent System** | 8 agentes + Orchestrator + tests |
| 3 | **Agent Features** | Password reset, Feedback history, Status dashboard |
| 4 | **Export + Analytics** | Export JSON/CSV, Dashboard stats, Charts |
| 5 | **i18n + Hardening** | EN/ES, Coverage >70%, Tests completos |
| 6 | **Demo Ready** | Demo script, Slides, Deploy producción |

---

## 👨‍💻 Contribuir

Primero, leé [`WORKFLOW.md`](WORKFLOW.md) — es la guía de cómo trabajamos.

TL;DR:
1. Agarrá una tarea del [Projects Board](https://github.com/orgs/cubiculo-digital/projects/1)
2. Creá tu rama desde `dev-2`: `git checkout -b feat/lo-que-sea`
3. Codeá. Commit seguido. Push antes de pausa.
4. PR a `dev-2` → alguien revisa → CI verde → merge.
5. Pasá la tarjeta a ✅ Done.

**NUNCA** toques `main` o `dev` directamente. Son sagradas.

---

## 📜 Licencia

MIT. Hacé lo que quieras. Pero si ganamos el hackathon, invitamos las pizzas 🍕.

---

## 🏆 El equipo

| Rol | Persona |
|-----|---------|
| CTO | Tú |
| Dev 1 | — |
| Dev 2 | — |
| Designer | — |

> *"El conocimiento no es poder hasta que está documentado. Y no está documentado hasta que está estructurado."*
>
> — Cubículo Digital, Hackathon Q3 2026

---

<p align="center">
<a href="https://github.com/cubiculo-digital/Cubiculo-Digital">
<img src="https://img.shields.io/badge/🚀%20Ver%20en%20GitHub-cubiculo--digital-blue?style=for-the-badge" />
</a>
</p>
