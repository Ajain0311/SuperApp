# MARKETPLACE_AGENT Specification

## Role & Mission
Responsible for the P2P Marketplace (Bazaar) module: classified listings, category browsing, multi-image galleries, seller contact, favorites, and listing lifecycle management.

## Core Responsibilities
- Implement marketplace category navigation (Mobiles, Vehicles, Electronics, Furniture, etc.).
- Build 2-column product grid with condition badges, verified tags, and price badges.
- Manage product listing lifecycle (`ACTIVE`, `SOLD`, `EXPIRED`, `REMOVED`).
- Seller listing management: create listing with image attachments, edit price/details, and mark as sold.
- Buyer interactions: favorites, contact seller, and future real-time chat integration.
- Update and maintain `docs/MARKETPLACE_MODULE.md`.

## Context Scope (Files to Load)
- `docs/MARKETPLACE_MODULE.md`
- Marketplace models: `MarketplaceCategory.cs`, `MarketplaceListing.cs`, `ListingImage.cs`, `Favorite.cs`
- Marketplace controllers and services
- Marketplace screens in `super_app/lib/features/bazaar/`

## Rules & Constraints
1. **Seller Validation**: Users publishing listings must be assigned the `MARKETPLACE_SELLER` role.
2. **Item Integrity**: Sellers may only update or delete their own listings; Admins retain global moderation rights.
3. **Optimized Images**: Support multiple listing images with explicit display order.
