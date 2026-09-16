# Screen Flow Documentation

This document outlines the screen flow and navigation hierarchy for all applications in the Super App ecosystem.

## CUSTOMER APP

### 1. Onboarding Flow
```text
[Splash Screen]
      |
      v
[Phone Entry] --> (Input mobile number)
      |
      v
[OTP Verification] --> (Enter 4/6 digit OTP)
      |
      +--> [Home Screen]
```

### 2. Main Navigation (Bottom Nav)
- **Home**: Aggregated dashboard
- **Food**: Food delivery module
- **Rides**: Ride booking module
- **Bazaar**: Marketplace module

### 3. Home Screen
- Location selector bar at the top (dropdown)
- Global search bar (dark background, rounded, search icon)
- Module selector section:
  - **Food Delivery Card**
  - **Book Rides Card**
  - **Marketplace Card**
- Spotlight deals & personalized recommendations

### 4. Food Module Flow
```text
[Food Tab (Home)]
      |
      +-- Search Bar
      +-- Filter Chips (Rating, Fast Delivery, Pure Veg, Offers)
      +-- Category Chips (Pizza, Biryani, Burgers, etc.)
      |
      v
[Restaurant List] --> (List of Restaurant Cards)
      |
      v
[Restaurant Detail Screen]
      |
      +-- Header Image & Info (Rating, Delivery Time, Distance)
      +-- Search Dishes
      +-- Category Tabs (Recommended, Starters, Mains, etc.)
      |
      v
[Food Item Customization] (Bottom Sheet)
      |
      +-- Portion selection (radio buttons)
      +-- Add-ons (checkboxes)
      +-- Quantity adjuster
      +-- "Add Item" button (with price)
      |
      v
[Cart] (Bottom Sheet or Screen)
      |
      +-- Order summary
      +-- Subtotal, Delivery Fee, Taxes
      +-- Coupon input
      +-- Grand Total
      +-- "Place Order" button
      |
      v
[Order Tracking]
      |
      +-- Status stepper
      +-- Estimated time
      +-- Order details
```

### 5. Ride Module Flow
```text
[Rides Tab (Home)]
      |
      +-- Search destination
      +-- Pickup / Dropoff inputs
      +-- Recent places chips
      |
      v
[Route Map & Vehicle Selection]
      |
      +-- Route line on map, Distance, ETA
      +-- Vehicle Cards:
          - Bike Taxi (price, ETA)
          - Auto Rickshaw (price, ETA)
          - Economy Cab (price, ETA)
      |
      v
[Ride Tracking]
      |
      +-- Driver info & Rating
      +-- 4-Digit OTP for driver
      +-- Real-time map tracking
      +-- Status updates
```

### 6. Bazaar (Marketplace) Flow
```text
[Bazaar Tab (Home)]
      |
      +-- Search & Category Chips
      +-- Product Grid (2 columns: image, price badge, title, location, time)
      |
      v
[Product Detail Screen]
      |
      +-- Images carousel
      +-- Price & Description
      +-- Seller info, Location
      +-- Contact Seller button
```
**Add Listing Flow:**
```text
[Add Listing] (Floating Action Button / Profile)
      |
      +-- Form: Upload images, Title, Category, Price
      +-- Condition, Description, Location
      +-- "Post Ad" button
```

### 7. Profile & Settings
- Avatar, Name, Phone
- Addresses (Home, Work, Other)
- Orders/Activity Tabs: Food Orders, Rides, Marketplace Listings
- App Settings (Theme, Notifications, Support)

---

## ADMIN PANEL

### Flow
```text
[Login]
      |
      v
[Dashboard] --> (Overview metrics)
      |
      +--> [Users Management] (List, Search, Edit)
      +--> [Restaurants Management]
      +--> [Drivers Management]
      +--> [Bazaar Categories]
```
- Standard layout: Left sidebar navigation, top app bar (user info), main content area.
- Main area usually contains data tables with pagination, search, filters, and action buttons (Edit, Delete, View).

---

## RESTAURANT PANEL

### Flow
```text
[Login]
      |
      v
[Dashboard] --> (Today's orders, sales summary, live active orders)
      |
      +--> [My Restaurant] (Info, status, timing)
      +--> [Categories] (Manage food categories)
      +--> [Menu Items] (Manage dishes, prices, availability)
      +--> [Orders] (History and past records)
      +--> [Settings]
```
- Focuses on real-time order management (Accepting, marking as Ready).
