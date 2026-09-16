# Marketplace (Bazaar) Module Documentation

The Community Bazaar module allows users to buy and sell pre-loved and brand new items within their local community, inspired by the OLX peer-to-peer commerce concept.

---

## 1. Architecture & Data Flow

```
┌─────────────────────────────────────────────────────────────┐
│                 Customer Flutter App (Bazaar)               │
│  - Category Pills (Mobiles, Vehicles, Electronics, etc.)    │
│  - 2-Column Responsive Product Grid                         │
│  - Image Carousel & Full Listing Details                    │
│  - "Sell Item" Quick Post Wizard                            │
│  - Direct In-App Chat & Call Actions                        │
└──────────────────────────────┬──────────────────────────────┘
                               │ HTTP / JSON
                               ▼
┌─────────────────────────────────────────────────────────────┐
│               MarketplaceController.cs (Backend)            │
│  - GET /api/marketplace/categories                          │
│  - GET /api/marketplace (search, filter, pagination)        │
│  - GET /api/marketplace/{id} (increments view count)        │
│  - POST /api/marketplace/listings (ADD, EDIT, DELETE, STATUS)│
│  - GET /api/marketplace/my-listings                         │
│  - POST/DELETE /api/marketplace/favorites/{listingId}       │
└──────────────────────────────┬──────────────────────────────┘
                               │ EF Core 10.0
                               ▼
┌─────────────────────────────────────────────────────────────┐
│               SQL Server Database (SuperAppDb)              │
│  - MarketplaceCategories (8 default categories)             │
│  - MarketplaceListings (Price, Condition, Status, Location) │
│  - ListingImages (1:N image gallery)                        │
│  - Favorites (User bookmarks)                               │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Listing Flow
- **Browsing**: Users browse items via category pills (All, Mobiles, Vehicles, Electronics, Furniture, Fashion, Books, Sports, Others) or cross-service search bar.
- **Listing View**: A 2-column responsive grid layout showing product image, condition badge (`LIKE NEW`, `BRAND NEW`, `GENTLY USED`), favorite heart button, bold price (`₹68,000`), title, and location with timestamp.
- **Detail View (`/bazaar/detail/:id`)**: Tapping a product shows a carousel of high-res images with page indicators, full description, highlights chips (Authentic Guaranteed, Original Bill & Box), seller profile card with verification badge, safety advisory, and bottom action bar with "Chat" and "Make an Offer" modal.
- **Add Listing (`/bazaar/add`)**: Users tap the floating "Sell Item" button, select up to 5 photos, choose category, enter title, set price, specify condition, and add description and location.

---

## 3. Listing States & Lifecycle
Listings adhere to the following lifecycle states:
- `ACTIVE`: Visible to all users in search and categories.
- `SOLD`: Item has been marked as sold by seller, retained for transaction history.
- `EXPIRED`: Listing has surpassed its validity duration (e.g. 30 days).
- `REMOVED`: Soft-deleted by the seller or moderated by platform admin.

---

## 4. Minimal Action API Design (`POST /api/marketplace/listings`)
Following the platform's action parameter pattern:
- **`ADD`**: Validates mandatory fields, automatically attaches the `MARKETPLACE_SELLER` role to the user, inserts `MarketplaceListing`, and saves attached `ListingImage` records.
- **`EDIT`**: Verifies listing ownership or Admin authority and updates mutable attributes.
- **`DELETE`**: Verifies ownership and soft-deletes (`IsActive = false`, `Status = "REMOVED"`).
- **`STATUS`**: Allows sellers to transition the item to `SOLD` or `EXPIRED`.

---

## 5. Trust & Safety Features
- **Seller Verification Badge**: Blue checkmark for users with verified phone numbers or admin verification.
- **Safety Advisory**: Prominent warnings to meet in well-lit public places and never send advance booking deposits before inspecting goods in person.
- **Offer Engine**: Buyers can submit binding counter-offers directly via bottom sheet without exposing personal phone numbers.
- **Favorites Sync**: Heart toggle persists user bookmarks across sessions.
