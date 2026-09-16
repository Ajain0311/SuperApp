# Admin Panel Documentation

The Admin Panel is the centralized hub for managing all aspects of the Super App ecosystem.

## 1. Navigation Structure
A persistent left sidebar provides access to:
- **Dashboard**: Overview metrics.
- **Users**: Manage all user accounts (Customers, Drivers, Owners).
- **Food Module**:
  - Restaurants: Verify, suspend, or manage restaurants.
  - Cuisines/Categories: Global food category management.
- **Ride Module**:
  - Drivers: Verify driver licenses, vehicles, and status.
  - Vehicles: Manage vehicle categories and base pricing.
- **Marketplace**:
  - Categories: Manage bazaar categories.
  - Listings Moderation: Review reported items.
- **System Settings**: Global configs (platform fees, terms).

## 2. Dashboard Metrics
- **Total Users**: Broken down by active/inactive.
- **Today's Orders**: Total food orders placed.
- **Today's Rides**: Total rides requested/completed.
- **Revenue**: Estimated platform commission.
- **Active Listings**: Number of active items in the Bazaar.

## 3. Management Sections Features
- **Data Tables**: Standardized tables for all entities with sortable columns.
- **Search & Filters**: Quick search by ID, Name, or Phone. Filters by status (Active, Pending Verification).
- **CRUD Dialogs**: Modals or separate pages for adding/editing records to prevent losing context.

## 4. Role-Based Access Control (RBAC)
- `SUPER_ADMIN`: Full access to all modules and system settings.
- `SUPPORT_STAFF`: Read-only access to most modules, can refund orders or cancel rides.
- `MODERATOR`: Access to Marketplace Moderation to approve/remove listings.
