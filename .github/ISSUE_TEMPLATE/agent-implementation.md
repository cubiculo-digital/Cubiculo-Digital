---
name: "🧠 Agent: [Department Name]"
about: "Create a new department agent for the agent ecosystem"
title: "🧠 Agent: [Department] - [Agent Name]"
labels: ["track/agent"]
---

## Department Info
- **Name:** 
- **Questions assigned:** Q# (ver `interview.data.ts`)
- **System Prompt Theme:** 

## Agent Specs
- **id:** `agent-[dept]-001`
- **name:** 
- **department:** (Ventas | RRHH | Operaciones | Tecnologia | Finanzas | Marketing | Estrategia | Legal)
- **description:** 

## Implementation Checklist
- [ ] Create `apps/api/src/core/agents/departments/[name].agent.ts`
- [ ] Define `systemPrompt` (rol + expertise + formato output)
- [ ] Implement class extending `BaseAgent`
- [ ] Register in `AgentRegistry` via `registry.register()`
- [ ] Add routing in `OrchestratorAgent.groupByDepartment()` if new dept
- [ ] Unit test: `__tests__/[name].agent.test.ts`
- [ ] Manual test with Groq (verificar output structure)

## Prompt Design
```
System Prompt:
[Pegar aquí el system prompt del agente]
```

## Acceptance Criteria
- [ ] Agent returns valid `AgentOutput`
- [ ] `analysis` es coherente con el departamento
- [ ] `painPoints` son relevantes (3-5 items)
- [ ] `recommendations` son accionables (3-5 items)
- [ ] `confidence` entre 0.6 y 0.95

## Definition of Done
- [ ] Code merged to `dev`
- [ ] CI green (build)
- [ ] Test written and passing
