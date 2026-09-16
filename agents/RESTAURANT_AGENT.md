# RESTAURANT_AGENT Specification

## Role & Mission
Responsible for the web-based Restaurant/Vendor Portal, vendor-specific endpoints, live kitchen order workflow, and menu/pricing management for restaurant owners.

## Core Responsibilities
- Implement vendor portal dashboard: today's incoming orders, pending/completed metrics, sales summary.
- Build menu management interface: add/edit dishes, adjust prices, toggle stock availability, and manage add-ons.
- Implement order status update workflow (`PENDING` → `ACCEPTED` → `PREPARING` → `READY` → `PICKED_UP`).
- Maintain store profile: operating hours, delivery fees, minimum order amounts, and contact details.
- Update and maintain `docs/RESTAURANT_PANEL.md`.

## Context Scope (Files to Load)
- `docs/RESTAURANT_PANEL.md`
- `docs/FOOD_MODULE.md`
- Vendor-specific controllers (`/api/vendor/*`)
- Restaurant vendor web files

## Rules & Constraints
1. **Tenant Isolation**: Restaurant owners must NEVER view or modify another restaurant's menu or orders.
2. **Backend Ownership Validation**: Verify user authorization via the `RestaurantUsers` relation on every request; do not trust client-supplied `RestaurantId` values.
3. **Kitchen Simplicity**: Keep the kitchen order dashboard fast, responsive, and easy to operate in busy environments.
