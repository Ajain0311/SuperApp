# SuperApp Multi-Agent Framework

## Overview
To prevent context overflow, minimize LLM token consumption, avoid regression bugs, and ensure modular development across our .NET 10 backend and Flutter mobile codebase, the SuperApp development lifecycle is partitioned across **14 domain-specialized agents** coordinated by a central Orchestrator.

---

## Agent Roster & Domain Scope

| Agent | Scope & Domain Files | Key Dependencies | Primary Output |
|---|---|---|---|
| **`ARCHITECTURE_AGENT`** | System topology, boundary enforcement, modular monolith structure | `docs/ARCHITECTURE.md`, `docs/PROJECT_STATUS.md` | ADRs, system blueprints |
| **`BACKEND_AGENT`** | `SuperApp.API/Controllers/`, `Services/`, `DTOs/`, `Middleware/`, `Program.cs` | `docs/API.md`, `docs/ARCHITECTURE.md` | Minimal APIs, action endpoints, services |
| **`DATABASE_AGENT`** | `SuperApp.API/Models/`, `Data/AppDbContext.cs`, Migrations, SQL Server | `docs/DATABASE.md` | EF Core entities, Fluent mappings, seed data |
| **`AUTH_AGENT`** | Authentication endpoints, `IOtpService`, `ITokenService`, JWT, User/Role tables | `docs/AUTHENTICATION.md` | Phone+OTP flows, Admin login, token issuance |
| **`FLUTTER_AGENT`** | `super_app/lib/` (Core, Shared Widgets, Routing, Shell) | `docs/DESIGN_SYSTEM.md`, `docs/SCREEN_FLOW.md` | Flutter screens, Riverpod state, navigation |
| **`FOOD_AGENT`** | Food delivery models, menu controllers, cart logic, order lifecycle | `docs/FOOD_MODULE.md`, `docs/API.md` | Restaurant discovery, food orders, cart engine |
| **`RIDE_AGENT`** | Ride booking, vehicle tiers, driver matching, ride state transitions | `docs/RIDE_MODULE.md`, `docs/API.md` | Fare estimates, booking flow, ride tracking |
| **`MARKETPLACE_AGENT`** | P2P classified listings, categories, favorites, seller moderation | `docs/MARKETPLACE_MODULE.md` | Listing discovery, filter engine, listing CRUD |
| **`ADMIN_AGENT`** | Admin web portal, global platform control, coupons, user moderation | `docs/ADMIN_PANEL.md` | System dashboard, admin management tools |
| **`RESTAURANT_AGENT`** | Vendor web portal, restaurant profile, kitchen order management | `docs/RESTAURANT_PANEL.md` | Kitchen order queue, menu/price management |
| **`UI_UX_AGENT`** | Theme, color tokens, typography, component library, reference screenshots | `docs/DESIGN_SYSTEM.md`, Screenshots | Reusable widgets, visual consistency |
| **`TESTING_AGENT`** | Unit tests, integration tests, API smoke tests, Flutter widget tests | All test projects & suites | Automated test suites, regression reports |
| **`DOCUMENTATION_AGENT`** | Synchronizing `docs/`, `PROJECT_STATUS.md`, `CHANGELOG.md`, `README.md` | All active changes | Updated docs & changelog entries |
| **`CODE_REVIEW_AGENT`** | Code hygiene, deduplication, anti-pattern detection, security audits | Pull requests & file diffs | Quality review & compliance checks |

---

## Token & Context Optimization Rules

1. **Strict Context Isolation**: Each agent must load *only* its designated documentation file and the specific source files it needs to modify. Never load the entire repository into context.
2. **Consult Single Source of Truth**: Always read [`docs/PROJECT_STATUS.md`](../docs/PROJECT_STATUS.md) first to understand the current phase and pending milestones.
3. **No Redundant Reading**: Do not re-read unchanged files. Use file link references and grep/targeted views.
4. **Standardized Handoff**: Every agent hands off work to the next agent using the standardized 9-point handoff schema defined in [`COORDINATION.md`](COORDINATION.md).
5. **No Speculative Implementations**: Focus strictly on the assigned phase and task. Do not jump ahead into unassigned modules.

---

## Orchestrator Pattern

When a feature or task is requested:
1. **Orchestrator** reads `docs/PROJECT_STATUS.md`.
2. **Orchestrator** decomposes the task into atomic sub-tasks.
3. **Orchestrator** dispatches to the appropriate specialized agent(s) sequentially or in parallel.
4. When work is complete, **`DOCUMENTATION_AGENT`** and **`CODE_REVIEW_AGENT`** ensure synchronization and quality.

For full coordination workflow, see [`COORDINATION.md`](COORDINATION.md).  
For token optimization details, see [`TOKEN_OPTIMIZATION.md`](TOKEN_OPTIMIZATION.md).
