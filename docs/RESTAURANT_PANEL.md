# Restaurant Panel Documentation

The Restaurant Panel provides tools for restaurant owners to manage their operations on the Super App.

## 1. Dashboard
- **Live Orders**: Real-time view of `PENDING` and `PREPARING` orders. Alerts for new orders.
- **Today's Sales**: Total revenue and order count for the current day.
- **Status Toggle**: A prominent switch to toggle the restaurant's status (`OPEN` or `CLOSED`) manually.

## 2. Restaurant Management
- **Profile**: Update restaurant name, cover image, logo, and description.
- **Timings**: Set operating hours for different days of the week.
- **Details**: Update address, contact info, and tax identifiers.

## 3. Menu Management
- **Categories**: Create and organize menu categories (e.g., "Starters", "Desserts").
- **Items**: 
  - Add new food items with name, description, price, food type (Veg/Non-Veg).
  - Upload item images.
  - Manage stock status (mark an item "Out of Stock" instantly).
- **Variants/Add-ons**: Define choices (e.g., Regular/Large) and extra add-ons (e.g., Extra Cheese).

## 4. Order Management
- **Active Orders View**: Kanban or list view of orders currently in progress.
- **Order Details**: Full breakdown of items, special instructions, and customer details (masked if necessary).
- **Order History**: Searchable list of past orders (Delivered, Cancelled) for reconciliation and analytics.

## 5. Ownership Validation
- The application relies on strict token validation to ensure that a user can only access the panel for the restaurant(s) they own.
- The `owner_id` mapped to the Restaurant entity must match the authenticated user's ID.
