---
name: feature-implementation
description: Guía paso a paso para implementar nuevas features en Cubículo Digital. Actívala cuando inicies una tarea de tipo feat/ o feature.
---

# Feature Implementation Skill

## Ciclo de Vida Obligatorio

```
IDEA → ISSUE → BRANCH → 4-CAPAS → TEST → COMMIT → PR → MERGE
```

Ningún paso se salta. Cada uno tiene reglas estrictas.

---

## 1. Issue (antes de escribir código)

Si no existe Issue, crearlo con:
- **Title**: `[FEAT]: descripción corta` o `[FIX]: descripción`
- **Labels**: 1 priority (`p0`/`p1`/`p2`/`p3`) + 1 area (`api`/`web`/`db`/`auth`/`interview`/`ui`/`ai`/`devops`)
- **Milestone**: Asignar al correspondiente (v3.1, v3.2, etc.)
- **Criterios de aceptación**:
  ```markdown
  - [ ] comportamiento esperado A
  - [ ] comportamiento esperado B
  - [ ] Tests pasan
  - [ ] Typecheck ok
  - [ ] Sin secrets expuestos
  ```

## 2. Branch

Usar `@git-branch-formatter`. Formato obligatorio:
```
<type>/<descripcion>
# Ejemplos:
feat/export-json
fix/jwt-expiry
refactor/groq-logging
chore/ci-pipeline
```

**Prohibido**: `feature/`, CamelCase, spaces.

```bash
git checkout dev && git pull origin dev
git checkout -b feat/<descripcion>
git push origin feat/<descripcion> --set-upstream
```

## 3. Implementación — 4 Capas Obligatorias + Fases

### 3.1. División en Fases
Cada feature DEBE dividirse en fases atómicas (máximo 1-2 archivos por fase). Cada fase implementa una o dos de las 4 capas y sigue el Protocolo de Stops.

**Ejemplo de división en fases para una feature:**
```
Fase 1: Schema GraphQL + type definitions (Capa 1)
Fase 2: Resolver + service logic (Capa 2)
Fase 3: Query/Mutation del frontend (Capa 3)
Fase 4: UI Component (Capa 4)
```

### 3.2. Las 4 Capas Obligatorias

Toda feature con datos persistentes DEBE implementar:

```
Capa 1: Schema (GraphQL type)    → apps/api/src/graphql/
Capa 2: Resolver (lógica)        → apps/api/src/graphql/modules/<area>/*.resolvers.ts
Capa 3: Query/Mutation (frontend) → apps/web/modules/<area>/*.api.ts
Capa 4: UI Component             → apps/web/views/<area>/**/*.tsx
```

**Prohibido**:
- ❌ Maquetación sin persistencia
- ❌ Endpoints sin consumir desde frontend
- ❌ Lógica de negocio en componentes UI

### Template para nuevo resolver
```typescript
import { GraphQLError } from 'graphql-yoga';
import { prisma } from '@cubiculo/db';
import { GraphQLContext } from '../../context.js';

export const resolvers = {
  Query: {
    myQuery: async (_: any, args: any, { currentUser }: GraphQLContext) => {
      if (!currentUser) throw new GraphQLError("No autorizado", {
        extensions: { code: "UNAUTHORIZED", http: { status: 401 } }
      });
      // implementar lógica
    }
  },
  Mutation: {
    myMutation: async (_: any, args: any, { currentUser }: GraphQLContext) => {
      if (!currentUser) throw new GraphQLError("No autorizado", {
        extensions: { code: "UNAUTHORIZED", http: { status: 401 } }
      });
      // validación server-side
      // lógica de negocio
      // retornar MutationResponse
    }
  }
};
```

### Template para nuevo componente
```tsx
"use client";

interface Props {
  title: string;
  onAction: () => void;
}

export const MyComponent = ({ title, onAction }: Props) => {
  return (
    <div className="bg-white dark:bg-[#111722] transition-colors duration-300">
      <h2 className="text-gray-900 dark:text-white">{title}</h2>
      <button onClick={onAction}
        className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg">
        Action
      </button>
    </div>
  );
};
```

## 4. Testing

- Unit: resolver retorna datos cuando autenticado, lanza error cuando no
- Integration: mutation completa con response structure
- Coverage mínimo: 80% líneas nuevas, 70% ramas
- Mock externo: NO llamar APIs reales (Groq, Redis, Firebase)

### Template para test de resolver
```typescript
import { describe, it, expect, vi } from 'vitest';

describe('myNewResolver', () => {
  it('should return data when authenticated', async () => {
    const result = await myResolver.Query.myQuery(_, {}, { currentUser: { userId: '123' } });
    expect(result).toBeDefined();
  });

  it('should throw when unauthenticated', async () => {
    await expect(
      myResolver.Query.myQuery(_, {}, { currentUser: undefined })
    ).rejects.toThrow('No autorizado');
  });
});
```

## 5. Pre-commit Checklist (OBLIGATORIO)

> ⚠️ El build check es BLOQUEANTE. NO hacer commit si el build falla.

Antes de cada commit, verificar:
```markdown
- [ ] Build check: `pnpm run build` (o `build:api`/`build:web`) — 0 errores (BLOQUEANTE)
- [ ] `pnpm exec tsc --noEmit` — 0 errors
- [ ] Tests nuevos escritos y pasando
- [ ] Dark mode implementado (si aplica UI)
- [ ] JWT expiry presente (si aplica auth)
- [ ] Sin secrets en el diff
- [ ] Sin código comentado
- [ ] Sin imports de OpenAI
- [ ] fetchPolicy explícito en nuevas queries GraphQL
- [ ] Branch name sigue convención
- [ ] PR description template seguido
```

## 6. Commit y PR

### Commit (usar `@git-commit-formatter`)
```
<type>(<scope>): <descripción en imperativo>
# Ejemplos:
feat(auth): add JWT expiry to signup and login
fix(api): handle null response from Groq service
refactor(interview): replace sort shuffle with Fisher-Yates
```

Tipos: `feat`, `fix`, `refactor`, `chore`, `test`, `docs`, `style`, `perf`
Scope común: `auth`, `api`, `web`, `db`, `ai`, `dashboard`, `interview`, `export`, `deps`, `ci`, `config`

**Regla de oro**: cada commit atómico (una sola responsabilidad).

### Pull Request
| Regla | Detalle |
|-------|---------|
| Base branch | SIEMPRE `dev`. NUNCA `main`. |
| Title | Mismo formato que commit |
| Description | Template: qué + por qué + cómo + archivos + screenshots |
| Reviewer | Auto-asignar code-reviewer |
| Merge | Squash merge a `dev` |

## 8. Protocolo de Stops por Fase (NO NEGOCIABLE)

Toda implementación DEBE dividirse en fases. Por cada fase:

1. **🛑 STOP** — Detente después de implementar los cambios de UNA fase. NO continúes a la siguiente.
2. **🏗️ BUILD** — Ejecuta `pnpm run build` (o `build:api`/`build:web`). Debe dar 0 errores. Si falla, corrige.
3. **💾 COMMIT** — Solo después de build verde. Usa `@git-commit-formatter`. Un commit por fase.
4. **📤 PUSH** — Sube los cambios inmediatamente a la rama remota.
5. **📝 LOG** — Actualiza `.bitacoras/actual.md` con el progreso de la fase (después del push, ANTES de pedir aprobación).
6. **✅ APPROVAL** — Espera la aprobación explícita del usuario. Envía un mensaje claro de STOP.
7. **🔄 NEXT** — Solo después de aprobación, pasa a la siguiente fase.

### 🔴 Reglas Absolutas (Zero Tolerance)
| # | Regla | Consecuencia |
|---|-------|-------------|
| PZ-01 | No hay commit sin build verde (0 errores) | La fase se considera fallida. Rehacer. |
| PZ-02 | No hay siguiente fase sin aprobación del usuario | No es una sugerencia. Hay que esperar. |
| PZ-03 | No hay PR sin tarea COMPLETADA + auto-mantenimiento | El PR no se crea hasta que la tarea esté COMPLETADA, bitácora archivada Y auto-mantenimiento post-flight ejecutado. |
| PZ-04 | No hay COMPLETADO sin aprobación explícita del usuario | La tarea nunca se auto-completa. |

### 🚦 Flujo Completo del Ciclo de Vida
```
IDEA
  ↓
ISSUE → (crear issue con criterios de aceptación)
  ↓
BRANCH → (@git-branch-formatter, desde dev)
  ↓
┌──────────────────────────────────────────────────────┐
│  FASE 1: Capa 1 (Schema)                            │
│    → BUILD CHECK → COMMIT → PUSH → LOG → APPROVAL   │
├──────────────────────────────────────────────────────┤
│  FASE 2: Capa 2 (Resolver)                          │
│    → BUILD CHECK → COMMIT → PUSH → LOG → APPROVAL   │
├──────────────────────────────────────────────────────┤
│  FASE 3: Capa 3 (Query/Mutation)                    │
│    → BUILD CHECK → COMMIT → PUSH → LOG → APPROVAL   │
├──────────────────────────────────────────────────────┤
│  FASE 4: Capa 4 (UI Component)                      │
│    → BUILD CHECK → COMMIT → PUSH → LOG → APPROVAL   │
└──────────────────────────────────────────────────────┘
  ↓
TEST → (tests unitarios + integración)
  ↓
PR → (solo si tarea está COMPLETADA, base = dev)
  ↓
MERGE → (squash merge a dev)
```

## 7. Referencia Rápida de Comandos

```bash
# Branch
git checkout dev && git pull origin dev
git checkout -b feat/<descripcion>

# Quality
pnpm exec tsc --noEmit
pnpm run lint
pnpm run test

# Build
pnpm run build:db && pnpm run build:api && pnpm run build:web

# Commit
git add .
git commit -m "feat(area): descripción en imperativo"
git push
```
