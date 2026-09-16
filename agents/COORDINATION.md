# Multi-Agent Coordination & Workflow Engine

## 1. Orchestration Architecture

The SuperApp development process utilizes an **Orchestrator-Worker** pattern. The Lead / Orchestrator Agent handles requirement analysis, task decomposition, and dispatching, while Domain Agents execute bounded tasks.

```
                           User Request / Phase Goal
                                      │
                                      ▼
                             Lead / Orchestrator
                         (Reads PROJECT_STATUS.md)
                                      │
        ┌─────────────────────────────┼─────────────────────────────┐
        ▼                             ▼                             ▼
   Schema Work                   API Work                     UI / Mobile Work
(DATABASE_AGENT)              (BACKEND_AGENT)                 (FLUTTER_AGENT)
        │                             │                             │
        └─────────────────────────────┼─────────────────────────────┘
                                      ▼
                        Handoff to Verification Phase
                                      │
                   ┌──────────────────┴──────────────────┐
                   ▼                                     ▼
            TESTING_AGENT                         CODE_REVIEW_AGENT
                   │                                     │
                   └──────────────────┬──────────────────┘
                                      ▼
                             DOCUMENTATION_AGENT
                 (Updates PROJECT_STATUS.md & CHANGELOG.md)
```

---

## 2. Execution Protocols: Sequential vs. Parallel

### Sequential Workflows (Strict Dependencies)
When a feature requires end-to-end implementation across the stack, agents execute in strict dependency order to prevent contract mismatches:

```
DATABASE_AGENT  ──▶  BACKEND_AGENT  ──▶  FLUTTER_AGENT  ──▶  TESTING_AGENT  ──▶  DOCUMENTATION_AGENT
(Schema & Migrations) (APIs & Services)   (Screens & State)    (Verification)     (Status Sync)
```

**Rule**: The dependent agent must NOT begin until the prerequisite agent completes and provides its handoff summary.

### Parallel Workflows (Decoupled Domains)
When tasks do not modify overlapping files or share immediate runtime dependencies, they run concurrently:
- `UI_UX_AGENT` creating reusable widgets **in parallel with** `BACKEND_AGENT` building API endpoints.
- `FOOD_AGENT` backend logic **in parallel with** `MARKETPLACE_AGENT` documentation.
- `TESTING_AGENT` writing backend integration tests **in parallel with** `DOCUMENTATION_AGENT` drafting API specs.

**Conflict Avoidance Rule**: Never run two agents in parallel if they write to the same files, same controllers, or same DbContext.

---

## 3. Standardized Agent Handoff Format

Whenever an agent finishes its assignment and passes work to the next agent or the Orchestrator, it MUST report in this exact compact schema:

```markdown
### AGENT HANDOFF SUMMARY
- **AGENT**: [Name of completing agent, e.g., DATABASE_AGENT]
- **COMPLETED**: [Concise summary of accomplished tasks]
- **FILES CHANGED**: 
  - `path/to/file1` (Created / Modified)
  - `path/to/file2` (Created / Modified)
- **DATABASE CHANGES**: [New tables, migrations, indexes, or seed records]
- **API CHANGES**: [New or altered endpoints, action requests, DTOs]
- **UI CHANGES**: [New screens, widgets, router changes]
- **TESTS**: [Build status, compile verification, unit/integration test results]
- **KNOWN ISSUES**: [Non-blocking anomalies or technical debt to track]
- **NEXT AGENT**: [Target recipient agent, e.g., BACKEND_AGENT]
- **CONTEXT NEEDED**: [Specific documentation or files the next agent should read]
```

---

## 4. Change Control & Architecture Preservation

Before modifying existing code, every agent must respect these invariants:

1. **Check Before Writing**: Verify whether the entity, service, controller, or widget already exists. Never introduce duplicate models or helpers.
2. **Minimal APIs**: Preserve the single POST action endpoint pattern (`ADD`, `EDIT`, `DELETE`, `STATUS`) for master data. Do not generate individual REST endpoints for trivial CRUD operations.
3. **Identity Purity**: Never create separate identity tables for Admins, Drivers, or Sellers. All actors are represented in `Users` + `Roles` + `UserRoles`.
4. **Architecture Decision Changes**: If a technical decision must be altered, document:
   - `OLD DECISION`:
   - `NEW DECISION`:
   - `REASON`:
   - `IMPACT`:
5. **No Speculative Microservices**: Maintain the modular monolith design. Do not split projects into independent microservice APIs or introduce distributed messaging buses.
