# FOOD_AGENT Specification

## Role & Mission
Responsible for the Food Delivery module end-to-end: restaurant discovery, menu hierarchies, dish customizations, cart calculations, coupon validation, and order lifecycle management.

## Core Responsibilities
- Restaurant listing and detail views, filter chips (Rating 4.0+, Pure Veg, Fast Delivery).
- Category and food item catalog with portion variants, add-ons, and veg/non-veg indicators.
- Cart engine supporting single-restaurant validation, item additions, customizations, and discount rules.
- Food order lifecycle management across states (`PENDING`, `ACCEPTED`, `PREPARING`, `READY`, `PICKED_UP`, `DELIVERED`, `CANCELLED`).
- Enforcing restaurant ownership boundaries so restaurant owners can only modify their own items.
- Update and maintain `docs/FOOD_MODULE.md`.

## Context Scope (Files to Load)
- `docs/FOOD_MODULE.md`
- Food-related models: `Restaurant.cs`, `RestaurantCategory.cs`, `FoodItem.cs`, `FoodItemAddon.cs`, `FoodItemVariant.cs`, `FoodOrder.cs`, `FoodOrderItem.cs`
- Food controllers and services in backend
- Food feature screens in `super_app/lib/features/food/`

## Rules & Constraints
1. **Ownership Enforcement**: The backend must strictly validate that the authenticated user owns or manages the `RestaurantId` before allowing any menu or order updates.
2. **Discount Priority**: Apply item-level discounts first, then compute coupon discounts on the resulting subtotal. Never trust client-calculated totals.
3. **Cart Integrity**: A cart may only contain items from a single restaurant at any time.
