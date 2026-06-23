# 🏆 CUBÍCULO DIGITAL — PLAN DE GUERRA: HACKATHON Q3 2026

> **Versión:** 1.0 — Última actualización: 2026-06-14
> **Autores:** Equipo Cubículo Digital
> **Duración:** 6 días (1 semana)
> **Equipo:** 2-3 personas

---

## 📋 ÍNDICE

1. [Filosofía del Plan](#1-filosofía-del-plan)
2. [¿Por qué un Sistema de Agentes?](#2-por-qué-un-sistema-de-agentes)
3. [Arquitectura del Proyecto](#3-arquitectura-del-proyecto)
4. [Estructura de GitHub](#4-estructura-de-github)
   - 4.1 Organización y Repositorio
   - 4.2 Branch Protection Rules
   - 4.3 Repository Settings
5. [GitHub Projects — El Tablero de Guerra](#5-github-projects--el-tablero-de-guerra)
   - 5.1 Estructura del Board
   - 5.2 Custom Fields
   - 5.3 Vistas
   - 5.4 Issue Templates
   - 5.5 Labels
   - 5.6 Milestones
6. [GitHub Actions — Pipeline Architecture](#6-github-actions--pipeline-architecture)
   - 6.1 CI Pipeline (quality gate)
   - 6.2 Security Pipeline
   - 6.3 Deploy Staging
   - 6.4 PR Quality Gate
   - 6.5 Deploy Production
   - 6.6 Secrets Management
7. [Sistema de Agentes — El Corazón del Proyecto](#7-sistema-de-agentes--el-corazón-del-proyecto)
   - 7.1 Core Interfaces
   - 7.2 Agent Registry
   - 7.3 BaseAgent
   - 7.4 Department Agents
   - 7.5 Orchestrator Agent
   - 7.6 Data Flow
   - 7.7 DB Schema
8. [Daily Battle Plan](#8-daily-battle-plan)
   - 8.1 Día 1 — Foundation
   - 8.2 Día 2 — Agent System
   - 8.3 Día 3 — Agent-Powered Features
   - 8.4 Día 4 — Export + Analytics
   - 8.5 Día 5 — i18n + Hardening + Tests
   - 8.6 Día 6 — Demo Day Prep
9. [Lista Maestra de Issues](#9-lista-maestra-de-issues)
10. [Critical Success Factors](#10-critical-success-factors)
    - 10.1 Demo Flow (10 min)
    - 10.2 Antipatrones
    - 10.3 Reglas de Oro del Equipo
11. [Definition of Done](#11-definition-of-done)
12. [Checklist de Arranque](#12-checklist-de-arranque)

---

## 1. FILOSOFÍA DEL PLAN

### Why (El Propósito)

Este proyecto compite en un hackathon con premio importante. **No podemos construir sobre una base insegura y esperar ganar.** Tampoco podemos solo arreglar seguridad sin mostrar features que impresionen a los jueces. La solución es **dual-track**: refactor y features en paralelo.

### El Primer Principio

> *"No construimos features sobre un monolito. Construimos un ecosistema de agentes orquestados, y las features son solo ventanas a ese ecosistema."*

Cada decisión en este plan responde a una pregunta: **¿Esto nos acerca a ganar el hackathon?**

| Prioridad | Lógica |
|-----------|--------|
| **Seguridad primero** | Sin JWT expiry ni auth en queries, el proyecto es rechazado automáticamente |
| **Agentes = diferenciador** | 8 agentes departamentales + orquestador es único. Nadie más en el hackathon tendrá esto |
| **Features sobre agentes** | Export, Dashboard, Feedback — todas son ventanas al sistema de agentes |
| **CI/CD desde el día 1** | Equipo de 2-3 personas necesita automatización o se ahoga en errores manuales |
| **Demo-ready el día 6** | Sin excepción. El día 6 NO se escribe código nuevo. Solo se pule y ensaya. |

---

## 2. ¿POR QUÉ UN SISTEMA DE AGENTES?

### El Problema del Monolito Actual

El `ai.service.ts` actual hace **una sola llamada a Groq** con las 11 respuestas y recibe un muro de texto. Esto tiene problemas graves:

| Problema | Impacto |
|----------|---------|
| Una pregunta mala contamina todo el output | El reporte completo se degrada |
| Sin granularidad departamental | No puedes ver "qué dijo el agente de Ventas" |
| No extensible | Agregar un departamento requiere reescribir prompts |
| Sin trazabilidad | No sabes qué agente produjo qué |
| Demo pobre | Mostrar "un texto de IA" no impresiona a nadie |

### La Solución: Ecosystem of Agents (EOA)

```
MONOLITO                              SISTEMA DE AGENTES
──────────                            ─────────────────
1 llamada Groq                        8 agentes + 1 orquestador
1 output plano                        Output estructurado por departamento
Sin departamentos                     Ventas, RRHH, Finanzas, etc.
No testeable                          Cada agente es una unidad testeable
No extensible                         Nueva depto = nuevo agente
Demo: "mira este texto"              Demo: "mira 8 consultores trabajando"
```

### ¿Qué es un "Agente" en este contexto?

NO es un agente autónomo tipo AutoGPT. Es un **patrón de diseño** donde:

1. Cada agente tiene un **rol experto** (Consultor de Ventas, CFO Advisor, etc.)
2. Cada agente tiene un **system prompt especializado** para su dominio
3. El orquestador **rutea** las preguntas al agente correcto según su departamento
4. El orquestador **sintetiza** todos los outputs en un reporte cohesivo
5. Cada agente es **independiente y testeable**

Esto NO es más costoso en tokens que el enfoque actual — de hecho, puede ser más eficiente porque cada prompt es más corto y enfocado.

---

## 3. ARQUITECTURA DEL PROYECTO

### Árbol de Directorios (Post-Refactor)

```
cubiculo-digital/
├── .github/
│   ├── workflows/
│   │   ├── ci.yml                    # Quality gates
│   │   ├── security.yml              # Security scanning
│   │   ├── deploy-staging.yml        # Deploy a staging
│   │   ├── deploy-prod.yml           # Deploy a producción
│   │   └── pr-quality.yml            # PR validation
│   ├── ISSUE_TEMPLATE/
│   │   ├── agent-implementation.md   # Template para agentes
│   │   ├── feature-implementation.md # Template para features
│   │   └── bug-report.md             # Template para bugs
│   └── labels.yml                    # Labels predefinidas
│
├── apps/
│   ├── api/
│   │   └── src/
│   │       ├── core/
│   │       │   ├── agents/
│   │       │   │   ├── index.ts                    # Barrel exports
│   │       │   │   ├── registry.ts                 # AgentRegistry
│   │       │   │   ├── base.agent.ts               # BaseAgent abstract
│   │       │   │   ├── orchestrator.agent.ts       # OrchestratorAgent
│   │       │   │   ├── types.ts                    # Tipos locales
│   │       │   │   ├── departments/
│   │       │   │   │   ├── ventas.agent.ts
│   │       │   │   │   ├── rrhh.agent.ts
│   │       │   │   │   ├── operaciones.agent.ts
│   │       │   │   │   ├── tecnologia.agent.ts
│   │       │   │   │   ├── finanzas.agent.ts
│   │       │   │   │   ├── marketing.agent.ts
│   │       │   │   │   ├── estrategia.agent.ts
│   │       │   │   │   └── legal.agent.ts
│   │       │   │   └── __tests__/
│   │       │   │       ├── registry.test.ts
│   │       │   │       ├── base.agent.test.ts
│   │       │   │       ├── ventas.agent.test.ts
│   │       │   │       ├── rrhh.agent.test.ts
│   │       │   │       └── orchestrator.agent.test.ts
│   │       │   └── ai/
│   │       │       └── ai.service.ts    # ← SE ELIMINA, reemplazado por Orchestrator
│   │       ├── graphql/
│   │       │   ├── schema.graphql       # Schema extraído (antes inline en index.ts)
│   │       │   ├── index.ts             # Solo importa schema + resolvers
│   │       │   ├── context.ts
│   │       │   └── modules/
│   │       │       ├── auth/
│   │       │       ├── interview/
│   │       │       ├── dashboard/       # Nuevo: dashboard stats
│   │       │       ├── feedback/        # Nuevo: feedback history
│   │       │       ├── export/          # Nuevo: export biblia
│   │       │       └── password-reset/  # Nuevo: reset flow
│   │       └── index.ts
│   │
│   ├── web/
│   │   └── src/
│   │       ├── app/
│   │       │   ├── [locale]/            # i18n routing
│   │       │   │   ├── dashboard/
│   │       │   │   │   ├── page.tsx
│   │       │   │   │   ├── feedback/
│   │       │   │   │   └── analytics/
│   │       │   │   ├── reset-password/
│   │       │   │   └── ...
│   │       │   └── layout.tsx
│   │       ├── modules/
│   │       │   ├── dashboard/
│   │       │   ├── feedback/
│   │       │   ├── export/
│   │       │   └── auth/
│   │       ├── views/
│   │       │   ├── dashboard/
│   │       │   │   ├── DashboardPageView.tsx
│   │       │   │   ├── AgentStatusPanel.tsx    # Nuevo
│   │       │   │   └── AnalyticsCharts.tsx      # Nuevo
│   │       │   ├── feedback/
│   │       │   │   └── FeedbackHistoryView.tsx  # Nuevo
│   │       │   └── ...
│   │       └── components/
│   │           ├── agents/
│   │           │   ├── AgentCard.tsx            # Nuevo
│   │           │   ├── AgentTimeline.tsx         # Nuevo
│   │           │   └── AgentStatusBadge.tsx      # Nuevo
│   │           └── ...
│   │
│   └── public/                     # ← SE ELIMINA, mover SVGs a web/public
│
├── packages/
│   ├── types/
│   │   ├── src/
│   │   │   ├── index.ts
│   │   │   └── agent.types.ts      # Interfaces compartidas del sistema de agentes
│   │   ├── package.json
│   │   └── tsconfig.json
│   ├── config/                     # Nuevo: configuraciones compartidas
│   │   ├── tsconfig.base.json
│   │   ├── eslint.base.config.mjs
│   │   └── prettier.base.config.mjs
│   └── db/
│       ├── prisma/
│       │   └── schema.prisma
│       └── src/
│           └── index.ts
│
├── PLAN_DE_GUERRA.md               # ← ESTE ARCHIVO
└── README.md
```

### Stack Tecnológico

| Capa | Tecnología | Versión | ¿Por qué? |
|------|-----------|---------|-----------|
| Frontend | Next.js | 15 | App Router, Server Components, i18n nativo |
| UI | Tailwind CSS | 4 | Utility-first, dark mode nativo |
| GraphQL Client | Apollo Client | 3 | Cache + estado integrado |
| Backend | Node.js | 20 LTS | ESM nativo, performance |
| GraphQL Server | GraphQL Yoga | 5 | Liviano, APQ, CORS flexible |
| ORM | Prisma | 5 | Type-safe, migrations, DX superior |
| DB | PostgreSQL (Supabase) | 15 | Serverless, 500MB gratis |
| Cache | Redis (Upstash) | 7 | APQ, rate limiting, serverless |
| AI | Groq (Llama 3.3-70b) | — | 10x más rápido que OpenAI, gratis |
| Auth | JWT + bcryptjs | — | Sin dependencias externas |
| Monorepo | pnpm workspaces | 10 | Más rápido que npm/yarn |

---

## 4. ESTRUCTURA DE GITHUB

### 4.1 Organización y Repositorio

**Crear GitHub Organization:**
```
Organization:  cubiculo-digital
Owner:         [Líder del equipo]
Members:       Dev 1, Dev 2, Dev 3
Plan:          GitHub Free
```

**Crear repositorio:**
```bash
# Desde el repo local actual (rama dev)
git remote remove origin
gh repo create cubiculo-digital/cubiculo-digital \
  --private \
  --description="SaaS B2B — Ecosystem of Agents for Corporate Knowledge" \
  --source=. \
  --push

# Verificar
git remote -v
# → origin  https://github.com/cubiculo-digital/cubiculo-digital.git (fetch)
# → origin  https://github.com/cubiculo-digital/cubiculo-digital.git (push)
```

**¿Por qué una org y no un repo personal?**
- Las orgs se ven más profesionales en un hackathon
- Permite agregar miembros con roles granularizados
- Si el proyecto gana, la org puede seguir viva post-hackathon
- Los jueces ven "cubiculo-digital/cubiculo-digital" vs "tunombre/repo"

### 4.2 Branch Protection Rules

**Rama `dev` (Staging):**
```
Settings → Branches → Add rule: dev

☑ Require a pull request before merging
  ☑ Require approvals: 1
  ☑ Dismiss stale pull request approvals when new commits are pushed
  ☑ Require review from Code Owners

☑ Require status checks to pass before merging
  ☑ Require branches to be up to date
  Status checks: typecheck, lint, test, build

☑ Require conversation resolution first
☑ Include administrators
☑ Restrict pushes that create matching branches
```

**Rama `main` (Production):**
```
Settings → Branches → Add rule: main

☑ Require a pull request before merging
  ☑ Require approvals: 1
☑ Require status checks to pass
  Status checks: typecheck, lint, test, build
☑ Require branches to be up to date
☑ Restrict who can push: Solo admins
```

**¿Por qué protecciones tan estrictas para un hackathon?**
- Porque el tiempo es el recurso más escaso
- Un merge con errores de tipo o tests fallidos le cuesta al equipo 30+ min de debugging
- Las protecciones NO ralentizan, PREVIENEN pérdida de tiempo
- Squash merging mantiene la historia de dev limpia: 1 feature = 1 commit

### 4.3 Repository Settings

| Setting | Valor | Razón |
|---------|-------|-------|
| Merge button | **Squash only** | 1 PR = 1 commit en dev/main. Historia limpia. |
| Auto-delete branches | ✅ | No acumular ramas huérfanas |
| Issues | ✅ | Cada tarea = 1 issue (trackeable) |
| Projects | ✅ | Board de guerra (siguiente sección) |
| Discussions | ✅ | Comunicación async del equipo |
| Wiki | ❌ | Preferimos docs en código (PLAN_DE_GUERRA.md, README.md) |
| Pages | ❌ | Vercel hosting |
| Dependabot | ✅ | Alertas de seguridad automáticas |
| Secret scanning | ✅ | Atajar credenciales filtradas |
| Push protection | ✅ | Evitar commits con secrets |

---

## 5. GITHUB PROJECTS — EL TABLERO DE GUERRA

### 5.1 Estructura del Board

```
Nombre:     "🏆 Cubículo Digital — Hackathon Q3 2026"
Template:   "Feature planning" (personalizado)
Visibilidad: Público (los jueces pueden ver la organización del equipo)
```

**Columnas:**
```
📥 Backlog → 🎯 Ready → 🔄 In Progress → 👀 In Review → ✅ Done
```

### 5.2 Custom Fields

| Field | Type | Options | ¿Por qué? |
|-------|------|---------|-----------|
| `Priority` | Single select | 🔴 P0-critical, 🟡 P1-high, 🟢 P2-medium, ⚪ P3-low | Separa lo urgente de lo accesorio |
| `Track` | Single select | 🔐 Security, 🏛️ Refactor, 🧠 Agent, 🎯 Feature, 🔄 CI/CD | Filtro rápido por área |
| `Day` | Single select | 1, 2, 3, 4, 5, 6 | Timeline visual |
| `Department` | Single select | Ventas, RRHH, Operaciones, Tecnología, Finanzas, Marketing, Estrategia, Legal | Para issues de agentes |
| `Owner` | Single select | Persona 1, Persona 2, Persona 3 | Responsabilidad clara |
| `Estimate` | Number | 1, 2, 3, 4 (horas) | Planning realista |
| `Status` | Single select | 📥 Backlog, 🎯 Ready, 🔄 In Progress, 👀 In Review, ✅ Done | Seguimiento |

### 5.3 Vistas del Board

**Vista 1: 🎯 Sprint Board (por Status)**

```
📥 Backlog          | 🎯 Ready           | 🔄 In Progress     | 👀 In Review       | ✅ Done
────────────────────|────────────────────|────────────────────|────────────────────|────────────────────
[F-22] SSO/SAML     | [SEC-01] JWT exp   | [🧠] VentasAgent   | [SEC-03] Auth users| [⚙️] GitHub Org
[F-23] OpenTelemetry| [SEC-02] Secrets   | [🧠] RRHHAgent     | [CI] Deploy staging| [📦] packages/types
...                 | ...                | ...                | ...                | ...
```

**Propósito:** Daily standup. Cada persona ve sus tarjetas en "In Progress" y "In Review".

---

**Vista 2: 🗓️ Timeline (por Day, estilo Gantt)**

```
Day 1 | [🔐 SEC-01] [🔐 SEC-02] [🔐 SEC-03] [🔐 SEC-04] [🔐 SEC-05]
      | [🔄 GitHub Org] [🔄 CI] [🔄 Deploy] [🔄 Security Scan]
      | [📦 packages/types] [📦 packages/config]
      | [🧠 BaseAgent] [🧠 Registry] [🧠 Orchestrator skeleton]
      | [🗄️ DB migrations] [🗄️ Seed]

Day 2 | [🧠 Ventas] [🧠 RRHH] [🧠 Operaciones] [🧠 Tecnologia]
      | [🧠 Finanzas] [🧠 Marketing] [🧠 Estrategia] [🧠 Legal]
      | [🧠 Orchestrator routing] [🧠 Orchestrator synthesis]
      | [🧪 Replace ai.service.ts]

Day 3 | [🎯 F-12 API] [🎯 F-12 UI] [🎯 F-14 API] [🎯 F-14 UI]
      | [🎯 Dashboard: Agent Status]

Day 4 | [🎯 F-11 Export JSON/CSV] [🎯 F-19 Analytics Dashboard]

Day 5 | [🌐 i18n EN/ES] [🧪 Auth tests] [🧪 Agent tests]

Day 6 | [📝 Demo script] [📝 Slides] [🚀 Deploy prod] [🐛 Polish]
```

**Propósito:** Visión global de la semana. ¿Vamos bien? ¿Algo se atrasó?

---

**Vista 3: 👥 Team View (por Owner)**

```
Persona 1 (Backend)        | Persona 2 (Frontend/DevOps)   | Persona 3 (Agent Core)
───────────────────────────|───────────────────────────────|───────────────────────────────
[🔐 SEC-01] JWT expiry     | [🔄 GitHub Org + Repo]        | [📦 packages/types/agent.types]
[🔐 SEC-03] Auth users     | [🔄 CI Pipeline]              | [📦 packages/config]
[🔐 SEC-05] Rate limiting  | [🔄 Deploy Staging]           | [🧠 BaseAgent + Registry]
[🗄️ DB migrations]        | [🔄 Security Scan]            | [🧠 Orchestrator skeleton]
[🧠 VentasAgent]           | [🏛️ GitHub Projects setup]    | [🧠 EstrategiaAgent]
[🧠 OperacionesAgent]      | [🧠 RRHHAgent]                | [🧠 FinanzasAgent]
[🧠 MarketingAgent]        | [🧠 TecnologiaAgent]          | [🧠 LegalAgent]
[🧠 Export API]            | [🧠 Export UI]                | [🧠 Orchestrator completo]
[🎯 F-12 API]             | [🎯 F-14 UI]                  | [🎯 F-19 API]
[🌐 i18n setup]           | [🌐 EN/ES translations]       | [🧪 All tests]
```

**Propósito:** Cada persona sabe exactamente qué le toca. Sin ambigüedad.

### 5.4 Issue Templates

#### Template 1: 🧠 Agent Implementation

```markdown
---
name: "🧠 Agent: [Department Name]"
about: "Create a new department agent"
title: "🧠 Agent: [Department] - [Agent Name]"
labels: ["track/agent"]
---

## Department Info
- **Name:** 
- **Questions assigned:** Q# (ver interview.data.ts)
- **System Prompt Theme:** 

## Implementation Checklist
- [ ] Create `apps/api/src/core/agents/departments/[name].agent.ts`
- [ ] Define system prompt (rol + expertise del consultor)
- [ ] Implement `process()` method
- [ ] Register in `AgentRegistry`
- [ ] Add routing in `OrchestratorAgent`
- [ ] Unit test: `__tests__/[name].agent.test.ts`
- [ ] Manual test with Groq (verificar output)

## Acceptance Criteria
- [ ] Agent returns valid `AgentOutput`
- [ ] `analysis` es coherente con el departamento
- [ ] `painPoints` son relevantes (no genéricos)
- [ ] `recommendations` son accionables
- [ ] `confidence` es razonable (0.6-0.95)

## Definition of Done
- [ ] Code merged to `dev`
- [ ] CI green
- [ ] Test coverage >80% para este agente
```

#### Template 2: 🎯 Feature Implementation

```markdown
---
name: "🎯 Feature: [Feature Name]"
about: "Implement a new feature"
title: "🎯 [F-XX] [Feature Name]"
labels: ["track/feature"]
---

## Description
<!-- What does this feature do? Link to PRD, roadmap, etc. -->

## API Changes
- [ ] New GraphQL types in `schema.graphql`
- [ ] New resolver in `apps/api/src/graphql/modules/[feature]/`
- [ ] Error handling (códigos estandarizados)
- [ ] Unit test: resolver

## Frontend Changes
- [ ] New page/component in `apps/web/views/[feature]/`
- [ ] GraphQL queries/mutations in `apps/web/modules/[feature]/`
- [ ] Loading state
- [ ] Error state
- [ ] Empty state
- [ ] Dark mode support

## Dependencies
<!-- Issues or milestones that must be completed first -->

## Acceptance Criteria
- [ ] Feature works end-to-end
- [ ] All tests pass
- [ ] No TypeScript errors
- [ ] i18n strings extracted
- [ ] Dark mode OK
```

#### Template 3: 🐛 Bug Report

```markdown
---
name: "🐛 Bug"
about: "Report a bug"
title: "🐛 [Bug Description]"
labels: ["bug"]
---

## Description
<!-- What's broken? -->

## Steps to Reproduce
1. 
2. 
3. 

## Expected Behavior

## Actual Behavior

## Environment
- Branch: 
- Browser (if frontend): 

## Screenshots / Logs

## Severity
- [ ] 🔴 Bloqueante (no podemos continuar)
- [ ] 🟡 Alta (funcionalidad rota)
- [ ] 🟢 Baja (cosmético, mejora)
```

### 5.5 Labels

```yaml
# .github/labels.yml
# Track Labels
- name: "track/security"
  color: "B60205"
  description: "🔐 Security fixes - P0 blocking"
- name: "track/refactor"
  color: "C5DEF5"
  description: "🏛️ Architecture refactor"
- name: "track/agent"
  color: "5319E7"
  description: "🧠 Agent system implementation"
- name: "track/feature"
  color: "0E8A16"
  description: "🎯 Product feature"
- name: "track/infra"
  color: "1D76DB"
  description: "🔄 CI/CD & DevOps"
- name: "track/testing"
  color: "FBCA04"
  description: "🧪 Tests and coverage"
- name: "track/i18n"
  color: "BFDADC"
  description: "🌐 Internationalization"

# Priority Labels  
- name: "priority/p0"
  color: "B60205"
  description: "🔴 Critical - bloqueante"
- name: "priority/p1"
  color: "D93F0B"
  description: "🟡 High"
- name: "priority/p2"
  color: "0E8A16"
  description: "🟢 Medium"
- name: "priority/p3"
  color: "C2E0C6"
  description: "⚪ Low / Future"

# Day Labels
- name: "day/1"
  color: "F9D0C4"
- name: "day/2"
  color: "F9D0C4"
- name: "day/3"
  color: "F9D0C4"
- name: "day/4"
  color: "F9D0C4"
- name: "day/5"
  color: "F9D0C4"
- name: "day/6"
  color: "F9D0C4"

# Agent Labels
- name: "agent/ventas"
  color: "5319E7"
- name: "agent/rrhh"
  color: "5319E7"
- name: "agent/operaciones"
  color: "5319E7"
- name: "agent/tecnologia"
  color: "5319E7"
- name: "agent/finanzas"
  color: "5319E7"
- name: "agent/marketing"
  color: "5319E7"
- name: "agent/estrategia"
  color: "5319E7"
- name: "agent/legal"
  color: "5319E7"

# Meta Labels
- name: "blocked"
  color: "000000"
  description: "🚫 Blocked by another issue"
- name: "good-first-issue"
  color: "7057ff"
  description: "🌱 Good for new contributors"
- name: "needs-review"
  color: "FBCA04"
  description: "👀 Needs review"
- name: "demo-critical"
  color: "B60205"
  description: "🏆 Critical for demo day"
```

### 5.6 Milestones

```yaml
milestones:
  - title: "MS-1: Foundation"
    description: "Day 1 — Seguridad, GitHub, CI/CD, tipos base, DB migrations"
    due_on: "2026-06-15T18:00:00Z"
    state: open
    
  - title: "MS-2: Agent System"
    description: "Day 2 — 8 department agents + orchestrator + replace ai.service"
    due_on: "2026-06-16T18:00:00Z"
    state: open
    
  - title: "MS-3: Agent Features"
    description: "Day 3 — F-12 Password Reset, F-14 Feedback History, Agent Status Dashboard"
    due_on: "2026-06-17T18:00:00Z"
    state: open
    
  - title: "MS-4: Export + Analytics"
    description: "Day 4 — F-11 Export JSON/CSV, F-19 Analytics Dashboard"
    due_on: "2026-06-18T18:00:00Z"
    state: open
    
  - title: "MS-5: i18n + Tests"
    description: "Day 5 — i18n EN/ES, test suite completo, coverage >70%"
    due_on: "2026-06-19T18:00:00Z"
    state: open
    
  - title: "MS-6: Demo Ready"
    description: "Day 6 — Demo script, slides, deploy producción, polish"
    due_on: "2026-06-20T18:00:00Z"
    state: open
```

**¿Por qué milestones con fechas exactas?**
- Crean urgencia positiva (deadline claro)
- GitHub muestra barras de progreso (visualmente motivador)
- Si un milestone se atrasa, el equipo reacciona antes del día 6
- Los jueces pueden ver la planificación en la pestaña "Milestones"

---

## 6. GITHUB ACTIONS — PIPELINE ARCHITECTURE

### Filosofía de CI/CD para Hackathon

```
PRINCIPIO: "El CI no es una opción. Es el portero que NO DEJA PASAR errores."

Si el CI está roto:
  ❌ Nadie hace merge
  ❌ Nadie deploya
  ✅ Alguien lo arregla INMEDIATAMENTE
```

**¿Por qué tan estricto?**
En un equipo de 2-3 personas, cada hora perdida debuggeando un error que el CI pudo atrapar es una hora que NO se invierte en features que ganan el hackathon.

### 6.1 CI Pipeline (`ci.yml`)

**Ubicación:** `.github/workflows/ci.yml`
**Trigger:** Push a `dev`, PR a `dev` o `main`
**Jobs:** 4 en paralelo, build depende de los otros 3

```yaml
name: "🎯 CI — Quality Gate"
on:
  push:
    branches: [dev]
  pull_request:
    branches: [dev, main]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  typecheck:
    name: "📐 TypeScript Strict"
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v3
        with:
          version: 10.28.1
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm exec tsc --noEmit
    # ⚠️ SIN continue-on-error: true — falla si hay errores
    # ¿Por qué? TypeScript strict atrapa errores que causarían bugs en producción.
    # Un tipo incorrecto puede ser una query que devuelve undefined inesperadamente.

  lint:
    name: "🧹 Lint & Format"
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v3
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm exec eslint . --max-warnings 0
      - run: pnpm exec prettier --check .
    # --max-warnings 0: CERO advertencias permitidas.
    # ¿Por qué? En un hackathon, "lo arreglo después" = "nunca se arregla".

  test:
    name: "🧪 Unit Tests"
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v3
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm exec vitest run --coverage
      - uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: coverage/

  build:
    name: "📦 Build"
    runs-on: ubuntu-latest
    needs: [typecheck, lint, test]
    # Depende de los 3 anteriores. Si alguno falla, no build.
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v3
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm run build:db
      - run: pnpm run build:api  
      - run: pnpm run build:web
      - run: pnpm run build
```

### 6.2 Security Pipeline (`security.yml`)

**Ubicación:** `.github/workflows/security.yml`
**Trigger:** PR a dev/main + diario a las 6 AM

```yaml
name: "🔐 Security Scan"
on:
  pull_request:
    branches: [dev, main]
  schedule:
    - cron: '0 6 * * *'

jobs:
  audit:
    name: "🔍 Dependency Audit"
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v3
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm audit --audit-level=high

  secrets:
    name: "🕵️ Secrets Detection"
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: trufflesecurity/trufflehog@v3
        with:
          extra_args: --only-verified --results=verified,unknown
```

**¿Por qué un pipeline de seguridad separado?**
- El CI ya es lento con 4 jobs. La seguridad no debería bloquear el merge (aunque alerta)
- La detección de secrets es crítica: un API key filtrada = pérdida del hackathon
- El escaneo diario atrapa lo que se escapó de los PRs

### 6.3 Deploy Staging (`deploy-staging.yml`)

**Ubicación:** `.github/workflows/deploy-staging.yml`
**Trigger:** Push a `dev`
**Destino:** Vercel (preview/production según proyecto)

```yaml
name: "🚀 Deploy Staging"
on:
  push:
    branches: [dev]

jobs:
  deploy-api:
    name: "📡 API → Vercel"
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v3
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm run build:db && pnpm run build:api
      - uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_API_PROJECT_ID }}
          vercel-args: '--prod'

  deploy-web:
    name: "🌐 Web → Vercel"
    runs-on: ubuntu-latest
    environment: staging
    needs: [deploy-api]
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v3
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm run build:web
      - uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_WEB_PROJECT_ID }}
          vercel-args: '--prod'

  db-migrate:
    name: "🗄️ DB Migration"
    runs-on: ubuntu-latest
    environment: staging
    needs: [deploy-api]
    steps:
      - run: pnpm --filter @cubiculo/db exec prisma migrate deploy
        env:
          DATABASE_URL: ${{ secrets.STAGING_DATABASE_URL }}
          DIRECT_URL: ${{ secrets.STAGING_DIRECT_URL }}

  smoke-test:
    name: "🔥 Smoke Test"
    runs-on: ubuntu-latest
    needs: [deploy-web, db-migrate]
    steps:
      - run: |
          curl -f https://api-staging.cubiculo-digital.vercel.app/health
```

**¿Por qué staging separado?**
- El equipo necesita un entorno estable para hacer QA antes de la demo final
- Si algo se rompe en staging, no afecta producción
- Los jueces pueden ver la URL de staging durante el desarrollo

### 6.4 PR Quality Gate (`pr-quality.yml`)

**Ubicación:** `.github/workflows/pr-quality.yml`
**Trigger:** PR opened, edited, synchronize, ready_for_review

```yaml
name: "👮 PR Quality Gate"
on:
  pull_request:
    types: [opened, edited, synchronize, ready_for_review]

jobs:
  check-branch:
    name: "🔍 Branch Validation"
    runs-on: ubuntu-latest
    steps:
      - name: Source is not main
        if: github.head_ref == 'main'
        run: |
          echo "❌ ERROR: No puedes hacer PR desde 'main'"
          echo "   Crea una rama feature desde 'dev'"
          exit 1
      
      - name: Naming convention
        run: |
          BRANCH="${{ github.head_ref }}"
          PATTERN='^(feat|fix|chore|docs|refactor)/[a-z0-9-]+$'
          if ! echo "$BRANCH" | grep -qE "$PATTERN"; then
            echo "❌ ERROR: Branch name '$BRANCH' no sigue el patrón:"
            echo "   feat/fix/chore/docs/refactor/<descripcion-corta>"
            exit 1
          fi

  check-commits:
    name: "📝 Commit Convention"
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: wagoid/commitlint-github-action@v6
        with:
          configFile: commitlint.config.js
```

**¿Por qué validar nombres de ramas y commits?**
- En un hackathon con 3 personas, si las ramas se llaman `fix2`, `final`, `final-v2`, `ya-merges`, el caos está garantizado
- Convenciones claras = cero tiempo perdido en "¿de quién es esta rama?"

### 6.5 Deploy Production (`deploy-prod.yml`)

**Ubicación:** `.github/workflows/deploy-prod.yml`
**Trigger:** Push a `main` (solo ocurre UNA vez: el día 6)

```yaml
name: "🏆 Deploy Production"
on:
  push:
    branches: [main]

jobs:
  deploy:
    name: "🚀 Production Deploy"
    runs-on: ubuntu-latest
    environment: production
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v3
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm run build
      
      - uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_API_PROJECT_ID }}
          vercel-args: '--prod'
      
      - uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_WEB_PROJECT_ID }}
          vercel-args: '--prod'
      
      - run: pnpm --filter @cubiculo/db exec prisma migrate deploy
        env:
          DATABASE_URL: ${{ secrets.PROD_DATABASE_URL }}
```

### 6.6 Secrets Management

**¿Por qué GitHub Secrets y no .env?**
El `.env` tiene credenciales reales. En un hackathon con repo compartido, el riesgo de commit accidental es alto. GitHub Secrets cifra los valores y solo se inyectan en los runners de Actions.

**Secrets requeridos:**

| Secret | ¿Qué es? | ¿Dónde se obtiene? | Usado en |
|--------|----------|-------------------|----------|
| `VERCEL_TOKEN` | Token de API de Vercel | Vercel Dashboard → Settings → Tokens | Deploy actions |
| `VERCEL_ORG_ID` | ID de la organización en Vercel | Vercel Dashboard → Settings → General | Deploy actions |
| `VERCEL_API_PROJECT_ID` | Project ID de apps/api | Vercel → Project → Settings → Project ID | Deploy API |
| `VERCEL_WEB_PROJECT_ID` | Project ID de apps/web | Vercel → Project → Settings → Project ID | Deploy Web |
| `STAGING_DATABASE_URL` | Supabase URL (staging) | Supabase Dashboard → Project Settings → Database | DB migrations |
| `STAGING_DIRECT_URL` | Supabase direct URL (staging) | Supabase Dashboard → Project Settings → Database | DB migrations |
| `PROD_DATABASE_URL` | Supabase URL (producción) | Supabase Dashboard → Project Settings → Database | DB migrations |
| `PROD_DIRECT_URL` | Supabase direct URL (producción) | Supabase Dashboard → Project Settings → Database | DB migrations |
| `GROQ_API_KEY` | API Key de Groq | Groq Console → API Keys | API runtime |
| `JWT_SECRET` | Secreto para firmar JWT | Generar con `openssl rand -base64 32` | API runtime |
| `REDIS_URL` | URL de Upstash Redis | Upstash Console → Database → REST URL | API runtime |

**Configurar secrets:**
```bash
gh secret set JWT_SECRET --body "$(openssl rand -base64 32)"
gh secret set GROQ_API_KEY --body "gsk_tu_api_key_aqui"
gh secret set STAGING_DATABASE_URL --body "postgresql://..."
# ... etc para cada secret
```

---

## 7. SISTEMA DE AGENTES — EL CORAZÓN DEL PROYECTO

### 7.1 Core Interfaces (compartidas API/Web)

**Ubicación:** `packages/types/src/agent.types.ts`

```typescript
// ================================================================
// AGENT SYSTEM — CORE TYPES
// ================================================================
// ¿Por qué en packages/types?
// - La API necesita estos tipos para los resolvers
// - El Frontend necesita estos tipos para las queries de GraphQL
// - Compartirlos evita duplicación y desincronización

// ===== ENUMS =====

export enum AgentDepartment {
  VENTAS = 'VENTAS',
  OPERACIONES = 'OPERACIONES',
  RRHH = 'RRHH', 
  TECNOLOGIA = 'TECNOLOGIA',
  FINANZAS = 'FINANZAS',
  MARKETING = 'MARKETING',
  ESTRATEGIA = 'ESTRATEGIA',
  LEGAL = 'LEGAL'
}

export enum AgentStatus {
  IDLE = 'IDLE',           // Sin actividad reciente
  PROCESSING = 'PROCESSING', // Ejecutando Groq
  COMPLETED = 'COMPLETED',  // Output generado
  FAILED = 'FAILED'         // Error en ejecución
}

// ===== INTERFACES =====

export interface IAgent {
  readonly id: string;
  readonly name: string;
  readonly department: AgentDepartment;
  readonly description: string;
  process(context: AgentContext): Promise<AgentOutput>;
  getStatus(): AgentStatus;
}

export interface AgentContext {
  userId: string;
  responses: InterviewQA[];  // Solo preguntas de SU departamento
  previousOutputs?: AgentOutput[];  // Para agentes encadenados (futuro)
}

export interface InterviewQA {
  questionId: string;
  question: string;
  answer: string;
  department: string;
  topic: string;
}

export interface AgentOutput {
  id: string;
  agentId: string;
  department: AgentDepartment;
  analysis: string;           // Narrativa del consultor
  painPoints: string[];       // Top 3-5 pain points detectados
  recommendations: string[];  // Recomendaciones accionables
  confidence: number;         // 0-1 score de confianza
  metadata: AgentMetadata;
  createdAt: Date;
}

export interface AgentMetadata {
  model: string;
  tokensUsed: number;
  latencyMs: number;
}

export interface OrchestratedReport {
  id: string;
  userId: string;
  executiveSummary: string;
  departmentOutputs: AgentOutput[];
  crossDepartmentInsights: string[];
  strategicPlan: StrategicPlan;
  createdAt: Date;
}

export interface StrategicPlan {
  shortTerm: string[];   // 30 días
  midTerm: string[];     // 60 días
  longTerm: string[];    // 90 días
}
```

### 7.2 Agent Registry

**Ubicación:** `apps/api/src/core/agents/registry.ts`

```typescript
// ================================================================
// AGENT REGISTRY
// ================================================================
// Propósito: Mantener un registro central de todos los agentes disponibles.
// Patrón: Singleton (una sola instancia en toda la aplicación)
//
// ¿Por qué singleton?
// - Los agentes se registran una vez al iniciar la app
// - El Orchestrator necesita consultar el registry en cada request
// - No tiene sentido tener múltiples instancias del mismo agente

export class AgentRegistry {
  private static instance: AgentRegistry;
  private agents: Map<AgentDepartment, IAgent> = new Map();
  
  private constructor() {} // Singleton: constructor privado
  
  static getInstance(): AgentRegistry {
    if (!AgentRegistry.instance) {
      AgentRegistry.instance = new AgentRegistry();
    }
    return AgentRegistry.instance;
  }
  
  register(agent: IAgent): void {
    if (this.agents.has(agent.department)) {
      throw new Error(`Agent already registered for department: ${agent.department}`);
    }
    this.agents.set(agent.department, agent);
  }
  
  getAgent(department: AgentDepartment): IAgent | undefined {
    return this.agents.get(department);
  }
  
  getAllAgents(): IAgent[] {
    return Array.from(this.agents.values());
  }
  
  getStatusMap(): Map<AgentDepartment, AgentStatus> {
    const statusMap = new Map<AgentDepartment, AgentStatus>();
    for (const [dept, agent] of this.agents) {
      statusMap.set(dept, agent.getStatus());
    }
    return statusMap;
  }
}
```

### 7.3 BaseAgent (Abstract Class)

**Ubicación:** `apps/api/src/core/agents/base.agent.ts`

```typescript
// ================================================================
// BASE AGENT — Abstract Class
// ================================================================
// Propósito: Proveer implementación base para TODOS los agentes.
// Patrón: Template Method — el proceso es siempre el mismo,
//         solo cambia el system prompt (definido por cada subclase).
//
// ¿Por qué una clase abstracta y no una interfaz?
// - Toda la lógica de llamada a Groq es idéntica entre agentes
// - El parsing del output de Groq es idéntico
// - Cada subclase solo provee: id, name, department, description, systemPrompt
// - DRY: No repetir la lógica de Groq en 8 archivos

import Groq from "groq-sdk";
import { v4 as uuid } from 'uuid';

export abstract class BaseAgent implements IAgent {
  abstract readonly id: string;
  abstract readonly name: string;
  abstract readonly department: AgentDepartment;
  abstract readonly description: string;
  protected abstract readonly systemPrompt: string;
  
  private status: AgentStatus = AgentStatus.IDLE;
  private groq: Groq;
  
  constructor() {
    this.groq = new Groq({ apiKey: process.env.GROQ_API_KEY });
  }
  
  async process(context: AgentContext): Promise<AgentOutput> {
    this.status = AgentStatus.PROCESSING;
    const startTime = Date.now();
    
    try {
      // 1. Construir mensajes para Groq
      const messages = this.buildMessages(context);
      
      // 2. Ejecutar Groq
      const completion = await this.groq.chat.completions.create({
        model: "llama-3.3-70b-versatile",
        messages,
        temperature: 0.5,
        max_tokens: 2048,
      });
      
      // 3. Parsear respuesta
      const content = completion.choices[0]?.message?.content;
      if (!content) {
        throw new Error(`[${this.department}] Groq returned empty response`);
      }
      
      // 4. Estructurar output (cada agente puede sobreescribir el parsing)
      const output = this.parseResponse(content, context);
      
      this.status = AgentStatus.COMPLETED;
      return {
        ...output,
        id: uuid(),
        agentId: this.id,
        department: this.department,
        metadata: {
          model: "llama-3.3-70b-versatile",
          tokensUsed: completion.usage?.total_tokens || 0,
          latencyMs: Date.now() - startTime,
        },
        createdAt: new Date(),
      };
      
    } catch (error) {
      this.status = AgentStatus.FAILED;
      console.error(`[AGENT_ERROR][${this.department}]:`, error);
      throw error;
    }
  }
  
  getStatus(): AgentStatus {
    return this.status;
  }
  
  // Template Method: construye los mensajes del prompt
  protected buildMessages(context: AgentContext) {
    const formattedResponses = context.responses
      .map((r, i) => `[Pregunta ${i + 1}]: ${r.question}\n[Respuesta]: "${r.answer}"`)
      .join('\n\n');
    
    return [
      { role: "system", content: this.systemPrompt },
      { 
        role: "user", 
        content: `Analiza las siguientes respuestas de la entrevista:\n\n${formattedResponses}`
      }
    ];
  }
  
  // Template Method: parsea la respuesta de Groq a AgentOutput
  // Las subclases PUEDEN sobreescribir esto si necesitan parsing especializado
  protected parseResponse(content: string, context: AgentContext): Partial<AgentOutput> {
    // Por defecto, el agente devuelve el contenido como analysis
    // y extrae pain points y recomendaciones con regex simple
    return {
      analysis: content,
      painPoints: this.extractPainPoints(content),
      recommendations: this.extractRecommendations(content),
      confidence: 0.85, // Default, las subclases pueden ajustar
    };
  }
  
  private extractPainPoints(content: string): string[] {
    // Busca sección de "Puntos Críticos" o "Pain Points" en el output
    const match = content.match(/(?:Pain Points|Puntos Críticos)[^]*?(?=\n\n|$)/i);
    if (!match) return ["No se pudieron extraer pain points automáticamente"];
    return match[0]
      .split('\n')
      .filter(l => l.match(/^[-*•]\s/))
      .map(l => l.replace(/^[-*•]\s/, ''));
  }
  
  private extractRecommendations(content: string): string[] {
    // Busca sección de "Recomendaciones" o "Recommendations"
    const match = content.match(/(?:Recomendaciones|Recommendations)[^]*?(?=\n\n|$)/i);
    if (!match) return ["No se pudieron extraer recomendaciones automáticamente"];
    return match[0]
      .split('\n')
      .filter(l => l.match(/^[-*•]\s/))
      .map(l => l.replace(/^[-*•]\s/, ''));
  }
}
```

### 7.4 Department Agents

**Ubicación:** `apps/api/src/core/agents/departments/`

Cada agente es una clase que extiende `BaseAgent` y SOLO define:
- `id`: Identificador único
- `name`: Nombre legible del agente
- `department`: Departamento asignado (enum)
- `description`: Descripción para mostrar en UI
- `systemPrompt`: El prompt especializado

**¿Por qué tan simple?**
- Porque la complejidad está en el prompt del agente, no en su código
- Un agente es básicamente "un experto con un prompt y acceso a Groq"
- Esta simplicidad permite agregar un nuevo agente en 15 minutos

#### VentasAgent

```typescript
export class VentasAgent extends BaseAgent {
  readonly id = 'agent-ventas-001';
  readonly name = 'Consultor Senior de Ventas';
  readonly department = AgentDepartment.VENTAS;
  readonly description = 'Especialista en revenue operations, CRM y customer success';
  
  protected readonly systemPrompt = `
    Eres un Consultor Senior de Ventas y Revenue Operations con 20+ años de experiencia.
    Has trabajado como VP de Ventas en startups que escalaron de $1M a $100M+ en revenue.
    
    Tu especialidad es analizar respuestas sobre canales de venta, herramientas CRM y
    customer experience, y extraer insights accionables.
    
    Estructura tu respuesta en 3 partes:
    1. ANÁLISIS: Diagnóstico de la situación actual de ventas
    2. PAIN POINTS: Enumera como lista con guiones los 3-5 puntos críticos detectados
    3. RECOMENDACIONES: Enumera como lista con guiones las 3-5 acciones concretas
    
    Sé crítico y específico. No des consejos genéricos. Cada recomendación debe
    ser accionable en los próximos 30-90 días.
  `;
}
```

#### RRHHAgent

```typescript
export class RRHHAgent extends BaseAgent {
  readonly id = 'agent-rrhh-001';
  readonly name = 'Consultor de Capital Humano';
  readonly department = AgentDepartment.RRHH;
  readonly description = 'Especialista en cultura organizacional y retención de talento';
  
  protected readonly systemPrompt = `
    Eres un Consultor de Capital Humano y Cultura Organizacional con experiencia en
    empresas de alto crecimiento. Has liderado transformaciones culturales en unicornios
    latinoamericanos.
    
    Tu especialidad es analizar respuestas sobre cultura organizacional, retención de
    talento y liderazgo.
    
    Estructura tu respuesta en 3 partes:
    1. ANÁLISIS: Diagnóstico de la situación actual de RH y cultura
    2. PAIN POINTS: Enumera como lista con guiones los 3-5 puntos críticos
    3. RECOMENDACIONES: Enumera como lista con guiones las 3-5 acciones concretas
    
    Enfócate en retención de talento clave, brechas culturales y planes de desarrollo.
  `;
}
```

*(Los otros 6 agentes siguen exactamente el mismo patrón, cambiando solo `id`, `name`, `description` y `systemPrompt`)*

**Patrón para cada agente:**

| Agente | Questions | Prompt Theme |
|--------|-----------|-------------|
| **VentasAgent** | Q2, Q3, Q6 | CRM, canales, customer success, revenue |
| **OperacionesAgent** | Q5 | Cuellos de botella, escalabilidad, procesos |
| **RRHHAgent** | Q8 | Cultura, retención, liderazgo |
| **TecnologiaAgent** | Q10 | Automatización, madurez digital, stack tech |
| **FinanzasAgent** | Q9 | Rentabilidad, márgenes, costos operativos |
| **MarketingAgent** | Q11 | Competencia, posicionamiento, propuesta de valor |
| **EstrategiaAgent** | Q1, Q4, Q7 | Misión, inversión, riesgos, visión |
| **LegalAgent** | Q7 (compartida) | Compliance, regulatorio, riesgos legales |

### 7.5 Orchestrator Agent

**Ubicación:** `apps/api/src/core/agents/orchestrator.agent.ts`

```typescript
// ================================================================
// ORCHESTRATOR AGENT
// ================================================================
// Propósito: Coordinar todos los departamentos agents y sintetizar
//            el resultado en un reporte unificado.
//
// ¿Por qué separado de los agentes?
// - El Orchestrator NO es un "agente departamental" — no tiene un prompt fijo
// - Su lógica es de coordinación, no de análisis de dominio
// - Puede escalar a paralelo sin cambiar la interfaz de los agentes

export class OrchestratorAgent {
  private registry: AgentRegistry;
  private groq: Groq;
  
  constructor() {
    this.registry = AgentRegistry.getInstance();
    this.groq = new Groq({ apiKey: process.env.GROQ_API_KEY });
  }
  
  async orchestrate(
    allResponses: InterviewQA[],
    userId: string
  ): Promise<OrchestratedReport> {
    
    // 1. Agrupar respuestas por departamento
    const grouped = this.groupByDepartment(allResponses);
    
    // 2. Ejecutar agentes SECUENCIALMENTE (para debug)
    //    En el futuro: Promise.all para ejecución paralela
    const outputs: AgentOutput[] = [];
    for (const [department, responses] of grouped) {
      const agent = this.registry.getAgent(department);
      if (!agent) {
        console.warn(`[ORCHESTRATOR] No agent for department: ${department}`);
        continue;
      }
      const output = await agent.process({ userId, responses });
      outputs.push(output);
    }
    
    // 3. Síntesis cross-departmental (LLAMADA FINAL A GROQ)
    const synthesisResult = await this.synthesize(outputs);
    
    // 4. Construir reporte final
    return {
      id: uuid(),
      userId,
      executiveSummary: synthesisResult.executiveSummary,
      departmentOutputs: outputs,
      crossDepartmentInsights: synthesisResult.crossDepartmentInsights,
      strategicPlan: synthesisResult.strategicPlan,
      createdAt: new Date(),
    };
  }
  
  private groupByDepartment(
    responses: InterviewQA[]
  ): Map<AgentDepartment, InterviewQA[]> {
    const groups = new Map<AgentDepartment, InterviewQA[]>();
    
    for (const response of responses) {
      const dept = response.department as AgentDepartment;
      if (!groups.has(dept)) {
        groups.set(dept, []);
      }
      groups.get(dept)!.push(response);
    }
    
    return groups;
  }
  
  private async synthesize(outputs: AgentOutput[]): Promise<{
    executiveSummary: string;
    crossDepartmentInsights: string[];
    strategicPlan: StrategicPlan;
  }> {
    // Construir contexto con outputs de todos los agentes
    const contextPerDepartment = outputs
      .map(o => `=== ${o.department} ===\n${o.analysis}`)
      .join('\n\n');
    
    const completion = await this.groq.chat.completions.create({
      model: "llama-3.3-70b-versatile", 
      messages: [
        {
          role: "system",
          content: `Eres el Orchestrator Agent, un estratega corporativo que sintetiza
          análisis de múltiples consultores especializados en una "Biblia Corporativa" unificada.
          
          Debes generar:
          1. Executive Summary: Síntesis ejecutiva de 2-3 párrafos
          2. Cross-Department Insights: Lista de insights que cruzan departamentos
             (ej: "Ventas y Operaciones necesitan alinear sus KPIs")
          3. Strategic Plan: Plan a 90 días dividido en:
             - shortTerm: 3-5 acciones para los primeros 30 días
             - midTerm: 3-5 acciones para los días 31-60
             - longTerm: 3-5 acciones para los días 61-90`
        },
        {
          role: "user",
          content: `Aquí están los análisis de cada consultor departamental:\n\n${contextPerDepartment}`
        }
      ],
      temperature: 0.4,
      max_tokens: 4096,
    });
    
    const content = completion.choices[0]?.message?.content;
    if (!content) {
      throw new Error("[ORCHESTRATOR] Synthesis returned empty response");
    }
    
    // Parsear la respuesta en el formato esperado
    return {
      executiveSummary: this.extractSection(content, 'Executive Summary', 'Cross-Department'),
      crossDepartmentInsights: this.extractList(content, 'Cross-Department Insights', 'Strategic Plan'),
      strategicPlan: {
        shortTerm: this.extractList(content, '30 days', '31-60'),
        midTerm: this.extractList(content, '31-60', '61-90'),
        longTerm: this.extractList(content, '61-90', null),
      },
    };
  }
  
  // Métodos auxiliares de parsing...
}
```

### 7.6 Data Flow Completo

```
1. USUARIO COMPLETA ENTREVISTA (11 preguntas)
   │
   ▼
2. finishInterview() MUTATION
   │
   ▼
3. GUARDAR RESPUESTAS EN DB (Prisma transacción)
   │
   ▼
4. CREAR ORCHESTRATOR + LLAMAR orchestrate(allResponses, userId)
   │
   ├── 4a. Group responses by department
   │
   ├── 4b. FOR EACH department:
   │       │
   │       ▼
   │   🧠 DepartmentAgent.process(context)
   │       │
   │       ├── Construye system prompt especializado
   │       ├── Llama a Groq (llama-3.3-70b)
   │       ├── Parsea respuesta → AgentOutput
   │       └── Retorna AgentOutput
   │       │
   │       ▼
   │   Guardar AgentOutput en DB
   │
   ├── 4c. SÍNTESIS FINAL: Orchestrator.synthesize(outputs)
   │       │
   │       ├── Construye contexto con TODOS los outputs
   │       ├── Llama a Groq (llama-3.3-70b)
   │       └── Parsea → executiveSummary + crossInsights + strategicPlan
   │
   ├── 4d. Guardar OrchestratedReport en DB
   │
   └── 4e. Retornar OrchestratedReport al cliente
   │
   ▼
5. DASHBOARD MUESTRA:
   ├── Agent status (qué departamentos se completaron)
   ├── Executive Summary
   ├── Por-department analysis (expandible)
   └── Strategic Plan (30/60/90 días)
```

### 7.7 DB Schema

**Ubicación:** `packages/db/prisma/schema.prisma`

```prisma
// ================================================================
// AGENT SYSTEM MODELS
// ================================================================

model Agent {
  id          String   @id @default(uuid())
  name        String   @unique
  department  String   @unique  // AgentDepartment enum value
  description String
  systemPrompt String   @db.Text
  isActive    Boolean  @default(true)
  outputs     AgentOutput[]
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}

model AgentOutput {
  id                  String              @id @default(uuid())
  agentId             String
  agent               Agent               @relation(fields: [agentId], references: [id])
  userId              String
  feedbackId          String?             // Relación opcional con OrchestratedReport
  analysis            String              @db.Text
  painPoints          String[]            // Array de strings (PostgreSQL)
  recommendations     String[]            // Array de strings
  confidence          Float?
  metadata            Json?               // { model, tokensUsed, latencyMs }
  createdAt           DateTime            @default(now())

  @@index([userId])
  @@index([agentId])
}

model OrchestratedReport {
  id                    String              @id @default(uuid())
  userId                String              @unique
  user                  User                @relation(fields: [userId], references: [id])
  agentOutputs          AgentOutput[]
  executiveSummary      String              @db.Text
  crossDepartmentInsights String[]          // Array de strings
  strategicPlan         Json?               // { shortTerm, midTerm, longTerm }
  createdAt             DateTime            @default(now())
  updatedAt             DateTime            @updatedAt
}

// ================================================================
// AUTH EXTENSIONS (F-12 Password Reset)
// ================================================================

model PasswordResetToken {
  id        String   @id @default(uuid())
  userId    String
  user      User     @relation(fields: [userId], references: [id])
  token     String   @unique
  expiresAt DateTime
  used      Boolean  @default(false)
  createdAt DateTime @default(now())

  @@index([token])
  @@index([userId])
}

// ================================================================
// EXISTING MODELS (con actualizaciones)
// ================================================================

model User {
  id        String   @id @default(uuid())
  email     String   @unique
  password  String
  name      String?
  role      String   @default("USER")   // NUEVO: ADMIN | USER
  // Relaciones
  interviewResponses InterviewResponse[]
  feedback           Feedback?
  agentOutputs       AgentOutput[]
  orchestratedReport OrchestratedReport?
  passwordResetTokens PasswordResetToken[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model Feedback {
  id        String   @id @default(uuid())
  content   String   @db.Text
  userId    String   @unique
  user      User     @relation(fields: [userId], references: [id])
  createdAt DateTime @default(now())
  // NUEVO: relación con orchestrated report
  report    OrchestratedReport?
}

// Los demás modelos existentes (Question, InterviewResponse) se mantienen igual
```

**¿Por qué estos cambios en DB?**
- `Agent`: Catálogo de agentes disponibles. Permite agregar/quitar agentes sin cambiar código.
- `AgentOutput`: Output individual de cada agente. Permite mostrar el detalle por departamento.
- `OrchestratedReport`: Reemplaza el concepto de "Feedback" como output único. Contiene la síntesis.
- `PasswordResetToken`: Necesario para F-12 (reset seguro con token con expiry).
- `User.role`: Preparación para multi-tenant y permisos (futuro).

---

## 8. DAILY BATTLE PLAN

### 8.1 DÍA 1 — Foundation (Foundation Day)

> *"Nada de features hasta que el escenario esté armado. Hoy construimos los cimientos."*

**Objetivo:** Seguridad OK, GitHub configurado, CI verde, tipos compilando, DB migrada.

| Hora | Persona 1 (Backend) | Persona 2 (Frontend/DevOps) | Persona 3 (Agent Core) |
|------|--------------------|---------------------------|----------------------|
| 09:00 | 🏛️ Daily standup: qué haré hoy | 🏛️ Daily standup | 🏛️ Daily standup |
| 09:30 | 🔐 SEC-01: Agregar `expiresIn: '1d'` en `auth.resolvers.ts` (líneas 14, 24) | 🏛️ Crear GitHub org + repo + migrar remote | 📦 Crear `packages/types/` con `agent.types.ts` |
| 10:00 | 🔐 SEC-01: Generar JWT_SECRET y mover a variable de entorno | 🏛️ Configurar branch protection (dev + main) | 📦 Definir enums + interfaces del sistema de agentes |
| 10:30 | 🔐 SEC-03: Agregar `if (!context.currentUser) throw new Error(...)` en `users` query | 🏛️ Crear GitHub Projects + custom fields | 📦 Crear `packages/config/` con tsconfig.base.json |
| 11:00 | 🔐 SEC-04: Unificar logging: reemplazar `[OPENAI_*]` → `[GROQ_*]` en toda la API | 🏛️ Configurar labels + milestones | 📦 eslint.base.config.mjs + prettier.base.config.mjs |
| 11:30 | 🔐 SEC-05: Rate limiting con Upstash Redis | 🏛️ Crear CI pipeline (`ci.yml`) | 🧠 `BaseAgent` abstract class |
| 12:00 | 🍔 **Lunch** | 🍔 **Lunch** | 🍔 **Lunch** |
| 13:00 | 🗄️ DB migration: `Agent` model | 🔧 Crear `security.yml` pipeline | 🧠 `AgentRegistry` singleton |
| 13:30 | 🗄️ DB migration: `AgentOutput` + `OrchestratedReport` | 🔧 Crear `deploy-staging.yml` | 🧠 `OrchestratorAgent` skeleton |
| 14:00 | 🗄️ DB migration: `PasswordResetToken` + `User.role` | 🔧 Crear `pr-quality.yml` | 🧪 Test: BaseAgent |
| 14:30 | 🗄️ Seed: 8 agentes default en DB | 🔧 Configurar GitHub Secrets | 🧪 Test: Registry |
| 15:00 | 🧪 Verificar: `pnpm run build` compila | 🔧 Verificar: CI pipeline corre en PR de prueba | 🧪 Verificar: tipos compilan en packages/types |
| 15:30 | 🐛 Fix errores de build | 🐛 Fix errores de pipeline | 🐛 Fix errores de tipos |
| 16:00 | 🔄 PR #1: SEC-01 a SEC-05 → dev | 🔄 PR #2: GitHub setup → dev | 🔄 PR #3: packages/types/config → dev |
| 16:30 | 👀 Code review | 👀 Code review | 👀 Code review |
| 17:00 | 🔄 Merge PRs → dev (CI verde) | 🔄 Merge PRs → dev | 🔄 Merge PRs → dev |
| 17:30 | 🧪 Smoke test: health endpoint | 🧪 Smoke test: CI green | 🧪 Smoke test: types compile |
| 18:00 | ✅ **MS-1 COMPLETE** | ✅ **GitHub listo** | ✅ **Framework de agentes listo** |

**Checklist de fin de día:**
```
□ JWT tiene expiresIn: '1d'
□ users query requiere autenticación
□ Todos los logs usan [GROQ_*] 
□ Rate limiting implementado
□ GitHub org creada con repo migrado
□ Branch protection activa en dev y main
□ Los 4 pipelines (CI, Security, Staging, PR) funcionan
□ GitHub Projects con 3 vistas configuradas
□ Labels + milestones creados
□ packages/types con agent.types.ts compilando
□ packages/config con tsconfig/eslint/prettier base
□ BaseAgent + Registry implementados
□ DB migrada con Agent + AgentOutput + OrchestratedReport
□ Seed de 8 agentes ejecutado
□ Todos los PRs mergeados a dev
□ CI verde en dev
```

---

### 8.2 DÍA 2 — Agent System

> *"Today we build an army of AI consultants. 8 agents + 1 orchestrator."*

**Objetivo:** 8 agentes departamentales funcionando, Orchestrator integrado, reemplazo de ai.service.ts.

| Hora | Persona 1 | Persona 2 | Persona 3 |
|------|----------|----------|----------|
| 09:00 | 🏛️ Daily + pull dev | 🏛️ Daily + pull dev | 🏛️ Daily + pull dev |
| 09:30 | 🧠 `VentasAgent` (Q2, Q3, Q6) — prompt + implementación | 🧠 `RRHHAgent` (Q8) — prompt + implementación | 🧠 `EstrategiaAgent` (Q1, Q4, Q7) — prompt + implementación |
| 10:30 | 🧠 `OperacionesAgent` (Q5) | 🧠 `TecnologiaAgent` (Q10) | 🧠 `FinanzasAgent` (Q9) |
| 11:30 | 🧠 `MarketingAgent` (Q11) | 🧠 `LegalAgent` (Q7 compartida) | 🧠 `OrchestratorAgent`: routing + groupByDepartment |
| 12:00 | 🍔 **Lunch** | 🍔 **Lunch** | 🍔 **Lunch** |
| 13:00 | 🧪 Test: VentasAgent + OperacionesAgent + MarketingAgent | 🧪 Test: RRHHAgent + TecnologiaAgent + LegalAgent | 🧪 Test: EstrategiaAgent + FinanzasAgent |
| 13:30 | 🔄 Register Ventas, Operaciones, Marketing en Registry | 🔄 Register RRHH, Tecnologia, Legal en Registry | 🔄 Register Estrategia, Finanzas en Registry |
| 14:00 | 🐛 Debug outputs de agentes | 🐛 Debug outputs de agentes | 🧠 `OrchestratorAgent.synthesize()` — llamada final Groq |
| 15:00 | 🧪 Integration test: agente individual → Groq → output | 🧪 Integration test: agente individual | 🧪 Integration test: Orchestrator completo |
| 15:30 | 🔄 PR: 3 agents → dev | 🔄 PR: 3 agents → dev | 🔄 PR: 2 agents + Orchestrator → dev |
| 16:00 | 👀 Review agents | 👀 Review agents | 👀 Review Orchestrator |
| 16:30 | 🔄 Merge → dev | 🔄 Merge → dev | 🔄 Merge → dev |
| 17:00 | 🔄 Reemplazar `ai.service.ts` → `Orchestrator.orchestrate()` en `interview.resolvers.ts` | 🧪 Test E2E: entrevista completa → agentes → reporte | 🐛 Fix errores de integración |
| 17:30 | 🧪 E2E test: POST finishInterview → 8 AgentOutputs | 🧪 E2E test: verificar DB | 🧪 E2E test: verificar dashboard mock |
| 18:00 | ✅ **MS-2 COMPLETE** | ✅ **8 agentes funcionando** | ✅ **Orchestrator integrado** |

**Checklist de fin de día:**
```
□ 8 agentes departamentales implementados
□ Cada agente tiene system prompt especializado
□ Todos los agentes registrados en AgentRegistry
□ Orchestrator.groupByDepartment() funciona
□ Orchestrator.synthesize() produce executiveSummary + insights + strategicPlan
□ ai.service.ts ELIMINADO (reemplazado por Orchestrator)
□ Entrevista completa genera 8 AgentOutputs en DB
□ Entrevista completa genera 1 OrchestratedReport
□ CI verde
□ Tests unitarios para cada agente
```

---

### 8.3 DÍA 3 — Agent-Powered Features

> *"Every feature is a window into the agent ecosystem."*

**Objetivo:** F-12 Password Reset, F-14 Feedback History, Dashboard con status de agentes.

| Hora | Persona 1 (API) | Persona 2 (Frontend) | Persona 3 (Dashboard) |
|------|----------------|--------------------|----------------------|
| 09:00 | 🏛️ Daily + pull dev | 🏛️ Daily + pull dev | 🏛️ Daily + pull dev |
| 09:30 | 🎯 F-12 API: `requestPasswordReset` mutation | 🎯 F-14 API: `Query.feedbacks` con agentOutputs incluidos | 🎯 Dashboard: Query agent status desde API |
| 10:30 | 🎯 F-12 API: `resetPassword` mutation + token validation | 🎯 F-14 UI: FeedbackHistoryView.tsx (timeline de agentes) | 🎯 Dashboard: AgentStatusPanel.tsx (8 indicadores) |
| 11:30 | 🎯 F-12: Email mock (console.log) + error handling | 🎯 F-14 UI: AgentCard.tsx (output por departamento) | 🎯 Dashboard: AgentStatusBadge.tsx (🟢🟡🔴) |
| 12:00 | 🍔 **Lunch** | 🍔 **Lunch** | 🍔 **Lunch** |
| 13:00 | 🧪 Test: Password Reset flow (request + reset) | 🧪 Test: Feedback History query | 🧪 Test: Agent status component |
| 14:00 | 🎯 F-12 UI: Reset password page + forms | 🎯 F-14 UI: Loading + error + empty states | 🎯 Dashboard: Integrar con dashboard layout existente |
| 15:00 | 🔄 PR: F-12 API + UI → dev | 🔄 PR: F-14 API + UI → dev | 🔄 PR: Dashboard agent status → dev |
| 16:00 | 👀 Review | 👀 Review | 👀 Review |
| 16:30 | 🔄 Merge → dev | 🔄 Merge → dev | 🔄 Merge → dev |
| 17:00 | 🧪 Deploy staging: test E2E password reset | 🧪 Deploy staging: test feedback history | 🧪 Deploy staging: test dashboard |
| 17:30 | 🐛 Fix bugs | 🐛 Fix bugs | 🐛 Fix bugs |
| 18:00 | ✅ **MS-3 COMPLETE** | ✅ **Feedback visible por agente** | ✅ **Dashboard muestra agentes** |

---

### 8.4 DÍA 4 — Export + Analytics

> *"Data is the product. Export it, visualize it."*

**Objetivo:** F-11 Export JSON/CSV, F-19 Analytics Dashboard con datos reales.

| Hora | Persona 1 (Export API) | Persona 2 (Analytics API) | Persona 3 (Frontend) |
|------|----------------------|-------------------------|---------------------|
| 09:00 | 🏛️ Daily + pull dev | 🏛️ Daily + pull dev | 🏛️ Daily + pull dev |
| 09:30 | 🎯 F-11 API: `exportBiblia(format: JSON)` — query OrchestratedReport | 🎯 F-19 API: `Query.dashboardStats` — stats reales desde DB | 🎯 F-11 UI: Export button + download handler |
| 10:30 | 🎯 F-11: Formato CSV | 🎯 F-19: Per-agent metrics resolver | 🎯 F-11: Loading + error states |
| 11:30 | 🎯 F-11: Headers HTTP (Content-Disposition) | 🎯 F-19: Overall progress calculation | 🎯 F-19 UI: Chart component (Chart.js) |
| 12:00 | 🍔 **Lunch** | 🍔 **Lunch** | 🍔 **Lunch** |
| 13:00 | 🧪 Test: Export JSON format | 🧪 Test: Dashboard resolver | 🎯 F-19 UI: Department breakdown chart |
| 14:00 | 🧪 Test: Export CSV format | 🧪 Test: Per-agent metrics | 🎯 F-19 UI: Trend indicators |
| 15:00 | 🔄 PR: F-11 → dev | 🔄 PR: F-19 API → dev | 🔄 PR: F-11 UI + F-19 UI → dev |
| 16:00 | 👀 Review | 👀 Review | 👀 Review |
| 16:30 | 🔄 Merge → dev | 🔄 Merge → dev | 🔄 Merge → dev |
| 17:00 | 🧪 E2E: Export flow (staging) | 🧪 E2E: Dashboard real data | 🧪 E2E: Charts render |
| 17:30 | 🐛 Fix: encoding, filenames | 🐛 Fix: metrics edge cases | 🐛 Fix: dark mode charts |
| 18:00 | ✅ **MS-4 COMPLETE** | ✅ **Dashboard con datos reales** | ✅ **Export + Charts funcionando** |

---

### 8.5 DÍA 5 — i18n + Hardening + Tests

> *"Último día de código. Mañana solo demo."*

**Objetivo:** i18n EN/ES, test suite >70% coverage, hardening.

| Hora | Persona 1 (i18n API) | Persona 2 (i18n UI) | Persona 3 (Testing) |
|------|--------------------|-------------------|-------------------|
| 09:00 | 🏛️ Daily + pull dev | 🏛️ Daily + pull dev | 🏛️ Daily + pull dev |
| 09:30 | 🌐 Setup next-intl + [locale] routing | 🌐 Extraer todos los strings de UI → `en.json` | 🧪 Auth resolvers tests (signup, login, JWT) |
| 10:30 | 🌐 i18n middleware: detect + redirect | 🌐 `en.json` completo (100% de strings) | 🧪 Interview resolvers tests (submit, finish) |
| 11:30 | 🌐 Server component translations | 🌐 `es.json` completo | 🧪 Agent resolvers tests (process, orchestrate) |
| 12:00 | 🍔 **Lunch** | 🍔 **Lunch** | 🍔 **Lunch** |
| 13:00 | 🌐 Client component translations (useTranslations) | 🌐 Verificar EN y ES side-by-side | 🧪 Export resolvers tests (JSON, CSV) |
| 14:00 | 🧪 Test: i18n routing | 🐛 Fix: missing translations | 🧪 Run full suite + coverage report |
| 15:00 | 🔄 PR: i18n setup → dev | 🔄 PR: EN/ES translations → dev | 🔄 PR: test suite → dev |
| 16:00 | 👀 Review | 👀 Review | 👀 Review |
| 16:30 | 🔄 Merge → dev | 🔄 Merge → dev | 🔄 Merge → dev |
| 17:00 | 🧪 Deploy staging: verify EN/ES | 🧪 Deploy staging: verify EN/ES | 📊 Coverage report: target >70% |
| 17:30 | 🐛 Fix i18n bugs | 🐛 Fix i18n bugs | 🐛 Fix test failures |
| 18:00 | ✅ **MS-5 COMPLETE** | ✅ **App bilingüe** | ✅ **Coverage >70%** |

---

### 8.6 DÍA 6 — Demo Day Prep

> *"It doesn't matter what you built if you can't show it."*

**Objetivo:** Demo script, slides, deploy producción, polish final. **NO se escribe código nuevo.**

| Hora | Persona 1 | Persona 2 | Persona 3 |
|------|----------|----------|----------|
| 09:00 | 🏛️ Daily: objetivo del día = demo perfecta | 🏛️ Daily | 🏛️ Daily |
| 09:30 | 📝 Demo script: escribir guión de 10 min | 🐛 Bug fixes: UI glitches | 🐛 Bug fixes: API edge cases |
| 10:30 | 📝 Slides: Problem + Solution + Architecture | 🎨 UI polish: transitions, animations | 🎨 UI polish: empty states, error states |
| 11:30 | 📝 Slides: Live Demo workflow | 🌐 Verify: no missing translations | 🔐 Security scan: final check |
| 12:00 | 🍔 **Lunch** | 🍔 **Lunch** | 🍔 **Lunch** |
| 13:00 | 🏆 **MERGE dev → main + DEPLOY PROD** | 🏆 **MERGE dev → main + DEPLOY PROD** | 🏆 **MERGE dev → main + DEPLOY PROD** |
| 14:00 | 🎯 Practicar demo (Round 1) | 🎯 Practicar demo (Round 1) | 🎯 Practicar demo (Round 1) |
| 14:30 | 🐛 Fix issues found | 🐛 Fix issues found | 🐛 Fix issues found |
| 15:00 | 🎯 Practicar demo (Round 2) | 🎯 Practicar demo (Round 2) | 🎯 Practicar demo (Round 2) |
| 15:30 | 📝 README.md: architecture + setup | 📝 README.md: contributors guide | 📝 README.md: API docs |
| 16:00 | 🎯 Practicar demo (Round 3 — final) | 🎯 Practicar demo (Round 3) | 🎯 Practicar demo (Round 3) |
| 16:30 | 📸 Capturas para slides | 📸 Capturas para slides | 💾 Backup DB: prisma dump |
| 17:00 | 🧘 Preparar setup técnico | 🧘 Preparar setup técnico | 🧘 Preparar setup técnico |
| 18:00 | ✅ **🏆 LISTOS PARA GANAR** | ✅ **Producción en vivo** | ✅ **Demo ensayada 3x** |

---

## 9. LISTA MAESTRA DE ISSUES (54 issues total)

### MS-1: Foundation (Day 1) — 18 issues

| # | Issue | Track | Prio | Owner | Est. |
|---|-------|-------|------|-------|------|
| 1 | 🔐 SEC-01: JWT expiry en signup + login | Security | 🔴 P0 | P1 | 1h |
| 2 | 🔐 SEC-02: Rotar secrets → GitHub Secrets | Security | 🔴 P0 | P1 | 1h |
| 3 | 🔐 SEC-03: Auth en `users` query | Security | 🔴 P0 | P1 | 0.5h |
| 4 | 🔐 SEC-04: Logging unificado `[GROQ_*]` | Security | 🔴 P0 | P1 | 0.5h |
| 5 | 🔐 SEC-05: Rate limiting (Upstash) | Security | 🟡 P1 | P1 | 1h |
| 6 | 🔧 Crear GitHub org + migrar repo | CI/CD | 🔴 P0 | P2 | 2h |
| 7 | 🔧 Branch protection + repo settings | CI/CD | 🔴 P0 | P2 | 1h |
| 8 | 🔧 CI Pipeline (typecheck, lint, test, build) | CI/CD | 🔴 P0 | P2 | 2h |
| 9 | 🔧 Deploy Staging Pipeline | CI/CD | 🟡 P1 | P2 | 2h |
| 10 | 🔧 Security Scan + PR Quality Gate | CI/CD | 🟡 P1 | P2 | 1h |
| 11 | 🏛️ GitHub Projects: board + views + fields | CI/CD | 🟢 P2 | P2 | 1h |
| 12 | 📦 Crear packages/types/ + agent.types.ts | Refactor | 🔴 P0 | P3 | 2h |
| 13 | 📦 Crear packages/config/ (tsconfig, eslint, prettier) | Refactor | 🔴 P0 | P3 | 2h |
| 14 | 🧠 BaseAgent abstract class | Agent | 🔴 P0 | P3 | 2h |
| 15 | 🧠 AgentRegistry singleton | Agent | 🔴 P0 | P3 | 1h |
| 16 | 🧠 OrchestratorAgent skeleton | Agent | 🔴 P0 | P3 | 1h |
| 17 | 🗄️ DB migrations (Agent, AgentOutput, OrchestratedReport, PwdReset) | Refactor | 🔴 P0 | P1 | 2h |
| 18 | 🗄️ Seed DB: 8 agents default | Refactor | 🟡 P1 | P1 | 0.5h |

### MS-2: Agent System (Day 2) — 12 issues

| # | Issue | Track | Prio | Owner | Est. |
|---|-------|-------|------|-------|------|
| 19 | 🧠 VentasAgent (Q2, Q3, Q6) | Agent | 🔴 P0 | P1 | 2h |
| 20 | 🧠 RRHHAgent (Q8) | Agent | 🔴 P0 | P1 | 1.5h |
| 21 | 🧠 OperacionesAgent (Q5) | Agent | 🔴 P0 | P2 | 1.5h |
| 22 | 🧠 TecnologiaAgent (Q10) | Agent | 🔴 P0 | P2 | 1.5h |
| 23 | 🧠 FinanzasAgent (Q9) | Agent | 🔴 P0 | P3 | 1.5h |
| 24 | 🧠 MarketingAgent (Q11) | Agent | 🔴 P0 | P3 | 1.5h |
| 25 | 🧠 EstrategiaAgent (Q1, Q4, Q7) | Agent | 🔴 P0 | P1 | 2h |
| 26 | 🧠 LegalAgent (Q7 compartida) | Agent | 🔴 P0 | P2 | 1.5h |
| 27 | 🧠 OrchestratorAgent: routing + groupByDepartment | Agent | 🔴 P0 | P3 | 2h |
| 28 | 🧠 OrchestratorAgent: synthesize() llamada final Groq | Agent | 🔴 P0 | P3 | 2h |
| 29 | 🔄 Reemplazar ai.service.ts → Orchestrator en interview flow | Agent | 🔴 P0 | P1 | 1h |
| 30 | 🧪 Unit tests: 8 agents + orchestrator | Testing | 🟡 P1 | ALL | 3h |

### MS-3: Agent Features (Day 3) — 5 issues

| # | Issue | Track | Prio | Owner | Est. |
|---|-------|-------|------|-------|------|
| 31 | 🎯 F-12 API: requestPasswordReset + resetPassword | Feature | 🟡 P1 | P1 | 2h |
| 32 | 🎯 F-12 UI: Password Reset page + forms | Feature | 🟡 P1 | P2 | 2h |
| 33 | 🎯 F-14 API: Query.feedbacks con agentOutputs | Feature | 🟡 P1 | P1 | 1.5h |
| 34 | 🎯 F-14 UI: Feedback History page + Agent cards | Feature | 🟡 P1 | P2 | 2.5h |
| 35 | 🎯 Dashboard: Agent status indicators (🟢🟡🔴) | Feature | 🟡 P1 | P3 | 2h |

### MS-4: Export + Analytics (Day 4) — 6 issues

| # | Issue | Track | Prio | Owner | Est. |
|---|-------|-------|------|-------|------|
| 36 | 🎯 F-11 API: exportBiblia(format: JSON) | Feature | 🟡 P1 | P1 | 2h |
| 37 | 🎯 F-11 API: exportBiblia(format: CSV) | Feature | 🟡 P1 | P1 | 1h |
| 38 | 🎯 F-11 UI: Export button + download handler | Feature | 🟡 P1 | P2 | 1.5h |
| 39 | 🎯 F-19 API: Query.dashboardStats (datos reales) | Feature | 🟡 P1 | P3 | 2h |
| 40 | 🎯 F-19 API: Per-agent metrics | Feature | 🟡 P1 | P3 | 1.5h |
| 41 | 🎯 F-19 UI: Charts + Analytics cards | Feature | 🟡 P1 | P2 | 3h |

### MS-5: i18n + Hardening (Day 5) — 8 issues

| # | Issue | Track | Prio | Owner | Est. |
|---|-------|-------|------|-------|------|
| 42 | 🌐 Setup next-intl + i18n routing | Feature | 🟢 P2 | P1 | 2h |
| 43 | 🌐 en.json translations (100%) | Feature | 🟢 P2 | P2 | 2h |
| 44 | 🌐 es.json translations (100%) | Feature | 🟢 P2 | P2 | 2h |
| 45 | 🧪 Auth resolver tests (signup, login, JWT) | Testing | 🟡 P1 | P3 | 1h |
| 46 | 🧪 Interview resolver tests (submit, finish) | Testing | 🟡 P1 | P3 | 1h |
| 47 | 🧪 Agent resolver tests (process, orchestrate) | Testing | 🟡 P1 | P3 | 1.5h |
| 48 | 🧪 Export resolver tests (JSON, CSV) | Testing | 🟡 P1 | P3 | 1h |
| 49 | 📊 Coverage threshold >70% | Testing | 🟡 P1 | P3 | 0.5h |

### MS-6: Demo Prep (Day 6) — 5 issues

| # | Issue | Track | Prio | Owner | Est. |
|---|-------|-------|------|-------|------|
| 50 | 📝 Demo script (10 min cronometrado) | Docs | 🔴 P0 | P1 | 2h |
| 51 | 📝 Slides: Problem + Solution + Architecture + Demo | Docs | 🔴 P0 | P2 | 3h |
| 52 | 📝 README.md: Architecture + Setup + Contributing | Docs | 🟡 P1 | P3 | 2h |
| 53 | 🚀 Deploy Production (merge dev→main) | CI/CD | 🔴 P0 | ALL | 1h |
| 54 | 🐛 Bug fixes + polish final | Meta | 🟡 P1 | ALL | 4h |

---

## 10. CRITICAL SUCCESS FACTORS

### 10.1 Demo Flow (10 Minutos Cronometrados)

```
⏱ 0:00 - 0:30  → INTRO: "El problema"
   "El conocimiento corporativo se pierde cuando la gente se va. 
   Las startups escalan y la información crítica queda en cabezas, no en documentos."

⏱ 0:30 - 1:30  → LA SOLUCIÓN
   "Cubículo Digital transforma conocimiento tácito en activos estructurados
   mediante un ecosistema de 8 agentes de IA especializados."

⏱ 1:30 - 2:30  → ARQUITECTURA (Slide + Diagrama)
   "Cada departamento tiene su propio agente-consultor. Un Orchestrator
   los coordina y sintetiza en una Biblia Corporativa unificada."

⏱ 2:30 - 4:00  → LIVE DEMO: Registro + Entrevista
   Abrir app → Registrarse → 3 preguntas rápidas

⏱ 4:00 - 5:30  → LIVE DEMO: Agentes trabajando
   Mostrar dashboard con 8 agentes → Ver status cambiar de ⏳ a ✅

⏱ 5:30 - 7:00  → LIVE DEMO: Biblia Corporativa
   Abrir feedback → Mostrar executive summary
   Expandir departamentos → Mostrar análisis de Ventas, RRHH, Estrategia

⏱ 7:00 - 8:00  → FEATURE: Export
   Click Export → Descargar JSON/CSV → Mostrar estructura con agentOutputs[]

⏱ 8:00 - 9:00  → FEATURE: Analytics
   Dashboard → Charts por departamento → Score de madurez

⏱ 9:00 - 9:45  → FEATURE: Password Reset (mencionar, no mostrar)
   "Olvidé mi contraseña → Email → Reset → Listo"

⏱ 9:45 - 10:00 → CIERRE
   "Código abierto, arquitectura extensible, listo para producción."
   QR al repo + invitación a contribuir
```

**Reglas de oro de la demo:**
1. **NUNCA muestres código** (a menos que pregunte un juez)
2. **NUNCA hagas scroll rápido** (mareas a la audiencia)
3. **NUNCA digas "esto no funcionó en el ensayo"**
4. **SIEMPRE ten un plan B** (capturas de pantalla, video grabado)
5. **SIEMPRE sonríe** (la pasión vende más que las features)

### 10.2 Antipatrones: Qué NO Hacer

| ❌ Antipatrón | Por qué duele | ✅ En su lugar |
|--------------|--------------|----------------|
| Escribir código sin issue asignado | Nadie sabe qué estás haciendo, duplicación de trabajo | Todo cambio linkeado a GitHub Issue |
| PR sin descripción | El reviewer pierde 20min entendiendo qué cambió | PR template con checklist obligatorio |
| Merge con CI rojo | "Lo arreglo después" = bugs en producción | CI es gatekeeper. No merge hasta verde. |
| Refactorizar lo que no tocan las features | Tiempo perdido que no se ve en la demo | YAGNI: solo refactoriza lo necesario |
| Escribir tests "después" | "Después" = día 6 = no hay tests | Tests son parte de la definición de "done" |
| Trabajar en main o dev directo | Conflicts, overwrites, caos | Siempre rama desde dev |
| Code review sin comentarios | "LGTM" no es review, es aprobación ciega | Review de verdad: al menos 1 pregunta |
| Cambiar de rama sin commit/push | Perder trabajo local | Push antes de pausa/lunch |

### 10.3 Reglas de Oro del Equipo

```
╔══════════════════════════════════════════════════════════════╗
║                 REGLAS DE ORO DEL EQUIPO                     ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  🚫 NO SE HACE MERGE SIN:                                    ║
║     □ CI verde (typecheck + lint + test + build)             ║
║     □ Al menos 1 approval del equipo                         ║
║     □ PR template completado                                 ║
║     □ Branch actualizada con dev                             ║
║                                                              ║
║  🚫 NO SE ESCRIBE CÓDIGO SIN:                                ║
║     □ Issue asignado en GitHub Projects                      ║
║     □ Tipo definido (feat/fix/chore/docs/refactor)           ║
║     □ Tests planificados (no necesariamente escritos antes)  ║
║                                                              ║
║  ✅ SIEMPRE:                                                  ║
║     □ Pull de dev antes de empezar el día                    ║
║     □ Push antes de break/lunch                              ║
║     □ PR antes de EOD (aunque no esté mergeado)              ║
║     □ Daily standup: "Qué hice, qué haré, blockers"          ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```

---

## 11. DEFINITION OF DONE

### Por Feature

| Feature | Criterios de Aceptación |
|---------|------------------------|
| **F-11 Export** | JSON descargable con estructura completa, CSV descargable, headers HTTP correctos, errores manejados |
| **F-12 Password Reset** | Email con token enviado, token expira en 1h, reset funciona, contraseña hasheada |
| **F-14 Feedback History** | Lista de feedbacks con agentOutputs, timeline visual, expandible por departamento |
| **F-19 Analytics** | DashboardStats query devuelve datos reales, charts renderizan, dark mode OK |
| **i18n EN/ES** | 100% strings traducidos, routing por locale, server + client components |

### Por Calidad

| Métrica | Target | Cómo se mide |
|---------|--------|-------------|
| **TypeScript** | 0 errors, strict mode | `tsc --noEmit --strict` |
| **ESLint** | 0 warnings | `eslint . --max-warnings 0` |
| **Prettier** | 100% formateado | `prettier --check .` |
| **Tests** | >70% line coverage | `vitest run --coverage` |
| **Build** | Compila en prod | `pnpm run build` |
| **Security** | 0 P0 vulnerabilidades | `pnpm audit`, secret scan |

### Por Demo

| Elemento | Status Requerido |
|----------|-----------------|
| Demo script | 10 min, cronometrado, ensayado 3x |
| Slides | Problem + Solution + Architecture + Live Demo + Cierre |
| URL producción | Funcionando, con datos de prueba |
| Plan B | Capturas de pantalla + video grabado |
| Repo GitHub | Público (o accesible a jueces) |

---

## 12. CHECKLIST DE ARRANQUE

### Pre-Día 1 (Antes de empezar)

```
☐ Todos tienen acceso a GitHub org
☐ Todos tienen Node.js 20 + pnpm 10.28.1 instalado
☐ Todos tienen cuenta de Vercel (gratis)
☐ Todos tienen cuenta de Supabase (gratis — 500MB DB)
☐ Todos tienen cuenta de Groq (gratis — API key)
☐ Todos tienen cuenta de Upstash (gratis — Redis)
☐ Repo local funciona: pnpm install + pnpm run dev
☐ Docker instalado (opcional, para API local)
```

### Día 1 — 09:00

```bash
# 1. Todos hacen pull de dev
git checkout dev && git pull origin dev

# 2. Verificar que el remote apunta a la nueva org
git remote -v
# → origin git@github.com:cubiculo-digital/cubiculo-digital.git

# 3. Cada quien crea su rama del día
git checkout -b feat/day1-security  # Persona 1
git checkout -b feat/day1-github    # Persona 2
git checkout -b feat/day1-packages  # Persona 3

# 4. GO! 🚀
```

### Comandos Útiles Durante el Hackathon

```bash
# Crear nuevo issue desde terminal
gh issue create \
  --title "🧠 Agent: VentasAgent" \
  --label "track/agent,priority/p0,day/2" \
  --assignee @me

# Crear milestone
gh api repos/:owner/:repo/milestones \
  --field title="MS-2: Agent System" \
  --field due_on=2026-06-16T18:00:00Z

# Ver CI status
gh run list --branch dev --workflow=ci.yml

# Deploy staging manual
gh workflow run deploy-staging.yml --ref dev

# Asignar secret
gh secret set JWT_SECRET --body "$(openssl rand -base64 32)"

# Merge PR cuando CI está verde
gh pr merge 12 --squash --delete-branch
```

---

## 🏁 CIERRE

Este plan es **tu mapa de batalla para los próximos 6 días**. No es un documento para leer una vez y olvidar. Es el **contrato del equipo**: todos sabemos qué hacer, cuándo y por qué.

Los principios que hacen ganador este plan:
1. **Seguridad primero** — sin base sólida, todo se derrumba
2. **Agentes como diferenciador** — nadie más tendrá 8 agentes orquestados
3. **Features como ventanas** — cada feature muestra el poder del sistema de agentes
4. **CI/CD desde el día 1** — automatización > esfuerzo manual
5. **Demo el día 6** — el día 6 NO se escribe código. Se ensaya.

> *"El mejor plan es el que se ejecuta. El segundo mejor es el que se adapta. El peor es el que no existe."*

**GOOD LUCK. WIN THE HACKATHON. 🏆**

---

*Documento generado el 2026-06-14 por el equipo Cubículo Digital*
