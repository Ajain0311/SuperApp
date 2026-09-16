# Token & Context Optimization Guidelines

## Objective
Large Language Model (LLM) context windows are precious and expensive. When building a complex Super App spanning multiple modules, naive context consumption quickly leads to context exhaustion, high latency, hallucinations, and catastrophic forgetting.

These rules govern how agents consume and emit context.

---

## 1. Golden Rules of Context Management

1. **Load Only What You Touch**: An agent working on the Food module must **never** load Ride or Marketplace files unless explicitly dealing with a cross-cutting concern.
2. **Never Ingest the Entire Repository**: Inspecting the repository structure must be done with targeted directory listings (`list_dir`), pattern searching (`grep_search`), or file name matching (`find_by_name`), not by blindly loading dozens of files.
3. **Targeted Line Ranges**: When reviewing or editing existing files, use line-range viewing rather than dumping full 1000-line files.
4. **Consume Compact Handoffs**: When an agent takes over from another agent, it should consume the 9-line handoff summary from the previous agent rather than re-reading all changed files from scratch.
5. **Single Source of Truth**: The central project state lives in `docs/PROJECT_STATUS.md`. Read this file to understand the current milestone instead of scanning git logs or multiple feature branches.

---

## 2. Module Activation Matrix

When a user request arrives, activate **only** the required agent cluster:

| User Task | Active Agents | Inactive Agents (Do NOT Load Context) |
|---|---|---|
| **Add Food Restaurant Category** | `FOOD_AGENT`, `BACKEND_AGENT`, `DATABASE_AGENT`, `DOCUMENTATION_AGENT` | `RIDE_AGENT`, `MARKETPLACE_AGENT`, `ADMIN_AGENT` |
| **Implement Ride Vehicle Selector UI** | `RIDE_AGENT`, `FLUTTER_AGENT`, `UI_UX_AGENT` | `FOOD_AGENT`, `MARKETPLACE_AGENT`, `RESTAURANT_AGENT` |
| **Marketplace Listing Filter API** | `MARKETPLACE_AGENT`, `BACKEND_AGENT` | `FOOD_AGENT`, `RIDE_AGENT`, `AUTH_AGENT` |
| **Phone OTP Login Flow** | `AUTH_AGENT`, `BACKEND_AGENT`, `FLUTTER_AGENT` | `FOOD_AGENT`, `RIDE_AGENT`, `MARKETPLACE_AGENT` |
| **Admin Coupon Engine** | `ADMIN_AGENT`, `BACKEND_AGENT`, `DATABASE_AGENT` | `RIDE_AGENT`, `MARKETPLACE_AGENT`, `RESTAURANT_AGENT` |

---

## 3. Context Loading Checklist for Agents

Before calling any read or view tool:
- [ ] Is this file in my direct domain scope?
- [ ] Has this file changed since my last check?
- [ ] Can I use `grep_search` to find the exact function instead of viewing the entire file?
- [ ] Can I view only lines 100–180 rather than the whole 800-line file?
- [ ] Did the previous agent provide an accurate handoff summary covering this change?

---

## 4. Anti-Patterns to Avoid

- ❌ **The Kitchen Sink**: Passing all documentation files in `docs/` into a single subagent prompt.
- ❌ **Repetitive Rereading**: Re-reading `AppDbContext.cs` or `Program.cs` before every tiny edit when only a controller is being modified.
- ❌ **Massive Chat Transcripts**: Including full stack traces or compiler logs; instead, pass only the relevant compiler error lines and file paths.
- ❌ **Cross-Domain Contamination**: Asking `FLUTTER_AGENT` to inspect SQL migration scripts, or asking `DATABASE_AGENT` to review Dart theme tokens.
