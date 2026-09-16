# Food Module Documentation

The Food Module handles end-to-end food delivery operations for the Super App, spanning customer discovery, dish customization, order placement, backend validation, and the restaurant vendor kitchen console.

---

## 1. User Flows

### Customer Flow
1. **Discovery (`FoodHomeScreen`)**:
   - Location-aware restaurant feed.
   - Filter chips: `Rating 4.0+`, `Fast Delivery`, `Pure Veg`, `Offers`.
   - Category navigation: `Biryani`, `North Indian`, `South Indian`, `Burgers`, `Rolls`, `Desserts`.
   - Restaurant cards with time badges (`22 mins`), offer overlays (`60% OFF UPTO ₹120`), rating badges, and price for two.
2. **Menu Selection (`RestaurantDetailScreen`)**:
   - Restaurant hero details with rating and cuisines.
   - Category selector tabs: `All`, `Biryani Specials`, `Starters`, `Desserts`.
   - Food item cards with Veg/Non-Veg indicators, `BESTSELLER` badges, descriptions, and `ADD +` buttons with `CUSTOMISABLE` labels.
3. **Item Customization (`ItemCustomizationSheet`)**:
   - Portion selection: `Regular Portion` (Included) vs `Jumbo Pack` (+₹210).
   - Add-ons checklist: `Boondi Raita Bowl` (+₹35), `Extra Mirchi Ka Salan` (+₹45).
   - Dynamic total price recalculation and quantity stepper `[- 1 +]`.
4. **Cart Summary & Checkout (`CartSummarySheet`)**:
   - Single restaurant policy enforcement.
   - Live item list with portion and addon summaries.
   - Bill breakdown: Item Total, Free Delivery Partner Fee, Govt. Taxes & Packaging (5%), and Grand Total.
5. **Live Tracking (`FoodOrderTrackingScreen`)**:
   - ETA countdown banner ("22 Mins • On Time").
   - Multi-step progress tracker (`Order Received` → `Kitchen Preparing` → `Ready for Pickup` → `Out for Delivery` → `Delivered`).
   - Delivery partner contact card with direct call capability.

### Restaurant Owner Flow
1. **Vendor Portal (`/vendor/index.html`)**:
   - Live metrics: Today's Orders, Kitchen Pending, Completed Today, Today's Sales.
   - Live Kitchen Queue table with order action buttons (`Accept Order`, `Mark Ready`).
   - Menu & In-Stock Management: In-stock toggle and dish creation.
   - Strict tenant isolation: owners can only access restaurants linked via `RestaurantUsers`.

---

## 2. Order States and Lifecycle Transitions

```
[ PENDING ] ──▶ [ ACCEPTED ] ──▶ [ PREPARING ] ──▶ [ READY ] ──▶ [ PICKED_UP ] ──▶ [ DELIVERED ]
     │                 │
     ▼                 ▼
[ CANCELLED ]    [ CANCELLED ]
```

---

## 3. Implemented Backend APIs

| Endpoint | Method | Description |
|---|---|---|
| `/api/restaurants` | `GET` | List active restaurants with search, veg-only filter, and pagination |
| `/api/restaurants/{id}` | `GET` | Full restaurant details with categories, food items, variants, and addons |
| `/api/food-orders` | `POST` | Place food order with server-side price recalculation and coupon application |
| `/api/food-orders` | `GET` | Customer order history |
| `/api/food-orders/{id}` | `GET` | Single order details |
| `/api/food-orders/{id}/cancel` | `POST` | Cancel pending/accepted order |
| `/api/coupons/validate` | `POST` | Validate coupon code, check min order amount, calculate percentage/flat discounts |
| `/api/vendor/my-restaurant` | `GET` | Vendor store profile |
| `/api/vendor/food-items` | `POST` | Minimal API action pattern (`ADD`, `EDIT`, `DELETE`, `STATUS`) for dishes |
| `/api/vendor/orders` | `GET` | Vendor kitchen queue |
| `/api/vendor/orders/{id}/status` | `PUT` | Advance kitchen order status |
| `/api/vendor/dashboard` | `GET` | Vendor metrics (today's orders, pending, completed, sales) |
| `/vendor/index.html` | `GET` | Responsive vendor web management application |

---

## 4. Price & Discount Calculation Formula

All calculations are enforced on the backend to prevent client tampering:
1. `UnitBasePrice` = Item `DiscountedPrice` (computed: `BasePrice * (1 - DiscountPercent / 100)`)
2. `LineItemPrice` = `(UnitBasePrice + VariantAdditionalPrice + Sum(SelectedAddons)) * Quantity`
3. `SubTotal` = `Sum(LineItemPrices)`
4. `CouponDiscount` = Calculated on `SubTotal` (Percentage with `MaxDiscount` cap or Flat)
5. `TaxAmount` = `(SubTotal - CouponDiscount) * 0.05` (5% GST)
6. `GrandTotal` = `SubTotal - CouponDiscount + DeliveryFee + TaxAmount`
