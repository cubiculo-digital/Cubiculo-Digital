---
name: "🎯 Feature: [Feature Name]"
about: "Implement a new product feature"
title: "🎯 [F-XX] [Feature Name]"
labels: ["track/feature"]
---

## Description
<!-- What does this feature do? Why is it valuable? Link to PLAN_DE_GUERRA.md, roadmap, or PRD -->

## Dependencies
<!-- Issues or milestones that must be completed first. Use #issue-number -->

## API Changes
- [ ] New GraphQL types in `schema.graphql`
- [ ] New resolver in `apps/api/src/graphql/modules/[feature]/`
- [ ] Error handling (códigos: UNAUTHORIZED, NOT_FOUND, VALIDATION_ERROR)
- [ ] Unit test: resolver

## Frontend Changes
- [ ] New page/component in `apps/web/views/[feature]/`
- [ ] GraphQL queries/mutations in `apps/web/modules/[feature]/`
- [ ] Loading state (skeleton o spinner)
- [ ] Error state (mensaje + retry)
- [ ] Empty state (mensaje + CTA)
- [ ] Dark mode support

## Data Layer
- [ ] Prisma migration (si aplica)
- [ ] Seed data (si aplica)

## Acceptance Criteria
- [ ] Feature works end-to-end
- [ ] All tests pass
- [ ] No TypeScript errors
- [ ] i18n strings extracted (EN + ES)
- [ ] Dark mode OK

## Definition of Done
- [ ] Code merged to `dev`
- [ ] CI green (build)
- [ ] Test coverage for new code
