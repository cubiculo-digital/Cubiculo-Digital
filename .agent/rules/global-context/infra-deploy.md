---
trigger: always_on
---

# 🚀 Infraestructura y Deploy

## Runtime
| Componente | Versión | Notas |
|------------|---------|-------|
| Node.js | 20.x LTS | engines en package.json |
| pnpm | 10.28.1 | packageManager requerido |
| PostgreSQL | Supabase (v15+) | Pooled + Direct URLs |
| Redis | Upstash (v7+) | Serverless, APQ + query cache |

## Docker (API only)
- Multi-stage build: node:20 builder + node:20 runner
- Stage 1: pnpm install —frozen-lockfile → generate Prisma → build API
- Stage 2: openssl + prisma migrate deploy → node apps/api/dist/index.js
- Expone puerto 4000

## Variables de Entorno Críticas
| Variable | Requerido | ⚠️ Nota |
|----------|-----------|---------|
| DATABASE_URL | ✅ | Supabase pooled — NO comitear |
| DIRECT_URL | ✅ | Supabase direct — NO comitear |
| JWT_SECRET | ✅ | Generar con `openssl rand -base64 32` |
| GROQ_API_KEY | ✅ | Groq Cloud — https://console.groq.com/keys |
| REDIS_URL | Prod | Upstash — solo prod |
| NODE_ENV | No | development/production |
| HEALTHCHECK_DB | No | true/false |
| NEXT_PUBLIC_API_URL | Dev | http://localhost:4000/graphql |

## ⚠️ Seguridad de Secrets
- **PROHIBIDO** comitear `.env` con valores reales
- Usar `.env.example` con placeholders (template oficial en raíz)
- En prod: GitHub Secrets / Vercel Environment Variables / Doppler
- Script de rotación: `scripts/rotate-secrets.sh`

## 📦 GitHub Secrets Inventory
Secrets configurados en el repositorio (via `gh secret set`):

| Secret | Estado | Dónde se usa |
|--------|--------|-------------|
| `JWT_SECRET` | ✅ Rotado (2026-06-20) | auth.resolvers.ts, context.ts |
| `GROQ_API_KEY` | ⚠️ Pendiente rotar en consola Groq | ai.service.ts |
| `DATABASE_URL` | ⚠️ Pendiente rotar en Supabase | Prisma, deploy-staging.yml |
| `DIRECT_URL` | ⚠️ Pendiente rotar en Supabase | Prisma migrations |
| `REDIS_URL` | ⚠️ Pendiente rotar en Upstash | redis.ts |
| `STAGING_DATABASE_URL` | ⚠️ Pendiente rotar en Supabase | deploy-staging.yml |
| `STAGING_DIRECT_URL` | ⚠️ Pendiente rotar en Supabase | deploy-staging.yml |
| `PROD_DATABASE_URL` | 🟡 Placeholder — requiere valores reales | deploy-prod.yml |
| `PROD_DIRECT_URL` | 🟡 Placeholder — requiere valores reales | deploy-prod.yml |
| `VERCEL_TOKEN` | 🟡 Placeholder — requiere token real | deploy-staging.yml, deploy-prod.yml |
| `VERCEL_ORG_ID` | 🟡 Placeholder — requiere ID real | deploy-staging.yml, deploy-prod.yml |
| `VERCEL_API_PROJECT_ID` | 🟡 Placeholder — requiere ID real | deploy-staging.yml, deploy-prod.yml |
| `VERCEL_WEB_PROJECT_ID` | 🟡 Placeholder — requiere ID real | deploy-staging.yml, deploy-prod.yml |

**Leyenda:** ✅ = Rotado | ⚠️ = Pendiente rotación externa | 🟡 = Placeholder

> ⚠️ Los secrets marcados como "Pendiente rotar" requieren regenerar la credential
> en la consola del servicio (Supabase, Groq, Upstash) y luego actualizar tanto `.env`
> como GitHub Secrets usando `scripts/rotate-secrets.sh`.

## Deploy Targets
- **API**: Docker container (servidor propio o Railway/Render)
- **Web**: Vercel (presunto por configuración CORS)

## CI/CD Pipeline (GitHub Actions)
| Workflow | Trigger | Jobs |
|----------|---------|------|
| PR Quality Gate | `pull_request` → `dev` | typecheck → lint → test → build |
| Deploy API Staging | `push` → `dev` | Build Docker → deploy staging |
| Deploy API Production | `push` → `main` | Build Docker → deploy production |
| Deploy Web | `push` → `main` | Build Next.js → deploy Vercel |
| Security Scan | weekly cron | `npm audit`, `trivy`, `gitleaks` |

## Health Check
- `GET /health` → HTML con DB + Redis status
- Respeta `HEALTHCHECK_DB=false` para ambientes serverless
- A futuro: health endpoint JSON para monitoreo programático
