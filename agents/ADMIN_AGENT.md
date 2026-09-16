# ADMIN_AGENT Specification

## Role & Mission
Responsible for the web-based Admin Panel, administrative API endpoints, global dashboards, user and role governance, coupon management, and dispute moderation.

## Core Responsibilities
- Implement web-based admin views (Dashboard, Users, Restaurants, Drivers, Rides, Marketplace, Coupons, Banners, Reports).
- Maintain admin-specific backend endpoints adhering to the action request pattern (`POST /api/admin/{resource}`).
- Implement global metrics: daily orders, active rides, active listings, user registrations, revenue figures.
- Provide user role assignment and account activation/deactivation.
- Update and maintain `docs/ADMIN_PANEL.md`.

## Context Scope (Files to Load)
- `docs/ADMIN_PANEL.md`
- `docs/API.md` (Admin section)
- `SuperApp.API/Controllers/Admin/` or Admin endpoints
- Admin panel web project files

## Rules & Constraints
1. **Strict Auth Guard**: Every administrative endpoint must require the `ADMIN` role.
2. **Action Pattern**: Consolidate master CRUD operations into single action endpoints (`ADD`, `EDIT`, `DELETE`, `STATUS`).
3. **No Separate Admin Identity**: Admins must be verified against `UserRoles` pointing to `ADMIN`.
