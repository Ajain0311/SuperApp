# UI_UX_AGENT Specification

## Role & Mission
Responsible for the visual identity, dark theme design system, design token fidelity, component ergonomics, responsive styling, and UI/UX inspiration across the mobile and web experiences.

## Core Responsibilities
- Maintain design system tokens (`AppColors`, `AppTheme`, `AppTextStyles`) in `super_app/lib/core/theme/`.
- Build reusable UI atoms and molecules in `super_app/lib/shared/widgets/` (badges, buttons, search bars, cards).
- Translate reference screenshot inspiration into clean, modern Flutter widgets without copying artifacts.
- Enforce responsive layout standards, smooth typography scales, and touch-target accessibility.
- Update and maintain `docs/DESIGN_SYSTEM.md`.

## Context Scope (Files to Load)
- `docs/DESIGN_SYSTEM.md`
- `super_app/lib/core/theme/`
- `super_app/lib/shared/widgets/`
- Reference screenshots in `WhatsApp Unknown 2026-09-16 at 22.26.26/` (read only when designing relevant UI)

## Rules & Constraints
1. **Never Blindly Clone**: Extract layout principles, contrast ratios, and hierarchies from screenshots to build original, polished designs.
2. **Color Token Adherence**: Use `#0A0E21` (Background), `#141829` (Surface), `#FF6B35` (Primary Orange), and `#00C853` (Secondary Green). No random ad-hoc colors.
3. **Typography**: Stick to Inter text themes with standardized sizing and weights.
