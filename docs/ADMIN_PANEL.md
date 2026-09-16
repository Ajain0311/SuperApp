# Admin Web Command Portal Documentation

The SuperApp Admin Portal (`/admin/index.html`) is the centralized operational command hub for platform administrators, providing end-to-end monitoring and governance across Food Delivery, Ride Hailing, and Community Bazaar modules.

---

## 1. Web Portal Location & Architecture
- **URL**: `http://localhost:5000/admin/index.html`
- **Theme**: Dark enterprise UI (`#0A0E21` background, `#141829` card surface, `#FF6B35` primary accent, `#00C853` green success indicators).
- **Architecture**: Single-Page Responsive Dashboard powered by REST endpoints from `AdminController.cs`.

---

## 2. Navigation Modules
The persistent left sidebar provides immediate access to 8 core administrative sections:
1. **📊 Overview Dashboard**: Real-time KPI cards (Total Users, Active Drivers Online, Gross Food Sales, Platform Commission Revenue), service health status indicators, and live platform audit trail table.
2. **👥 Users & RBAC**: Centralized user directory with search by name/mobile, role tags (`ADMIN`, `CUSTOMER`, `RESTAURANT_OWNER`, `DRIVER`, `MARKETPLACE_SELLER`), account suspension toggles, and role grant/revoke dialogs.
3. **🍔 Restaurants & Food**: Restaurant verification, active/inactive toggles, featured partner status (`⭐ YES`), ratings, delivery fees, and minimum order values.
4. **🛵 Drivers Fleet**: Driver verification queue, driving license verification, vehicle make/model/registration checks, online status, and ride metrics.
5. **🛍️ Bazaar Moderation**: Peer-to-peer marketplace listing moderation, condition badges, featured ad promotion, and spam removal.
6. **🏷️ Coupons & Offers**: Discount management supporting percentage and flat discounts, validity dates, minimum order thresholds, and module targeting (`FOOD`, `RIDE`, `ALL`).
7. **🖼️ Banners & Ads**: Hero promotional banners across Home, Food, and Ride landing views.
8. **⚙️ Global Settings**: Platform commission percentages (15% Food, 20% Ride), currency configs, and support hotline settings.

---

## 3. Minimal Action API Design (`AdminController.cs`)
- **`GET /api/admin/dashboard`**: Aggregates platform KPIs, gross revenues, and recent activities.
- **`GET /api/admin/users`**: Paginated user search with role filters.
- **`POST /api/admin/users`**: Action pattern (`STATUS` to suspend/activate, `ROLE` to assign/revoke roles).
- **`GET /api/admin/restaurants`**: List all restaurants.
- **`POST /api/admin/restaurants`**: Action pattern (`ADD`, `EDIT`, `DELETE`, `STATUS`, `FEATURED`).
- **`GET /api/admin/drivers`**: Driver roster with linked vehicle info.
- **`POST /api/admin/drivers`**: Action pattern (`VERIFY`, `STATUS`).
- **`GET /api/admin/coupons`**: Active and expired coupons.
- **`POST /api/admin/coupons`**: Action pattern (`ADD`, `EDIT`, `DELETE`, `STATUS`).
- **`GET /api/admin/banners`**: Banner campaigns list.
- **`POST /api/admin/banners`**: Action pattern (`ADD`, `EDIT`, `DELETE`, `STATUS`).

---

## 4. Role-Based Access Control (RBAC)
- `ADMIN`: Full access to all platform administrative capabilities, user management, and system configs.
- `RESTAURANT_OWNER`: Restricted to their assigned restaurant via `/vendor/index.html`.
- `DRIVER`: Restricted to driver app and ride execution APIs.
- `MARKETPLACE_SELLER`: Can post and manage peer-to-peer listings.
- `CUSTOMER`: Standard consumer shopping and booking access.
