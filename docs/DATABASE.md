# Super App Database Design

## Overview
This document outlines the complete database schema for the Super App (Food, Ride, Marketplace). Backend: ASP.NET Core, Database: SQL Server with EF Core.

## Tables

### Users
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| MobileNumber | NVARCHAR(15) | UNIQUE | |
| FullName | NVARCHAR(100) | | |
| Email | NVARCHAR(255) | NULL | |
| ProfileImageUrl | NVARCHAR(500) | NULL | |
| PasswordHash | NVARCHAR(255) | NULL | |
| IsActive | BIT | DEFAULT 1 | |
| CreatedAt | DATETIME2 | | |
| UpdatedAt | DATETIME2 | NULL | |
| LastLoginAt | DATETIME2 | NULL | |

### Roles
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | INT | PK | |
| Name | NVARCHAR(50) | UNIQUE | e.g. Admin, Customer, RestaurantOwner, Driver |
| Description | NVARCHAR(255) | NULL | |
| IsActive | BIT | DEFAULT 1 | |
| CreatedAt | DATETIME2 | | |
| UpdatedAt | DATETIME2 | NULL | |

### UserRoles
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| UserId | BIGINT | FK -> Users(Id) | |
| RoleId | INT | FK -> Roles(Id) | |
| CreatedAt | DATETIME2 | | |

### OtpRequests
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| MobileNumber | NVARCHAR(15) | | |
| OtpCode | NVARCHAR(10) | | |
| Purpose | NVARCHAR(50) | | Login, Reset, etc. |
| IsUsed | BIT | | |
| ExpiresAt | DATETIME2 | | |
| CreatedAt | DATETIME2 | | |
| AttemptCount | INT | DEFAULT 0 | |

### Addresses
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| UserId | BIGINT | FK -> Users(Id) | |
| Label | NVARCHAR(50) | | Home, Work, etc. |
| AddressLine1 | NVARCHAR(255) | | |
| AddressLine2 | NVARCHAR(255) | NULL | |
| City | NVARCHAR(100) | | |
| State | NVARCHAR(100) | | |
| PinCode | NVARCHAR(10) | | |
| Latitude | DECIMAL(10,7) | NULL | |
| Longitude | DECIMAL(10,7) | NULL | |
| IsDefault | BIT | | |
| IsActive | BIT | | |
| CreatedAt | DATETIME2 | | |
| UpdatedAt | DATETIME2 | NULL | |

### Restaurants
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| Name | NVARCHAR(200) | | |
| Description | NVARCHAR(1000) | NULL | |
| ImageUrl | NVARCHAR(500) | | |
| Phone | NVARCHAR(15) | | |
| Email | NVARCHAR(255) | NULL | |
| AddressLine | NVARCHAR(500) | | |
| City | NVARCHAR(100) | | |
| Latitude | DECIMAL(10,7) | NULL | |
| Longitude | DECIMAL(10,7) | NULL | |
| Rating | DECIMAL(3,2) | DEFAULT 0 | |
| TotalRatings | INT | DEFAULT 0 | |
| IsVeg | BIT | DEFAULT 0 | |
| OpeningTime | TIME | | |
| ClosingTime | TIME | | |
| MinOrderAmount | DECIMAL(10,2)| DEFAULT 0 | |
| DeliveryFee | DECIMAL(10,2) | DEFAULT 0 | |
| AvgDeliveryTimeMinutes | INT | DEFAULT 30 | |
| IsActive | BIT | | |
| IsFeatured | BIT | DEFAULT 0 | |
| CreatedAt | DATETIME2 | | |
| UpdatedAt | DATETIME2 | NULL | |

### RestaurantUsers
*Note: Maps owners/managers to restaurants. One restaurant can have multiple owners/managers, and one user can own/manage multiple restaurants.*
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| RestaurantId | BIGINT | FK -> Restaurants(Id) | |
| UserId | BIGINT | FK -> Users(Id) | |
| IsActive | BIT | | |
| CreatedAt | DATETIME2 | | |

### RestaurantCategories
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| RestaurantId | BIGINT | FK -> Restaurants(Id) | |
| Name | NVARCHAR(100) | | |
| Description | NVARCHAR(255) | NULL | |
| SortOrder | INT | DEFAULT 0 | |
| IsActive | BIT | | |
| CreatedAt | DATETIME2 | | |
| UpdatedAt | DATETIME2 | NULL | |

### FoodItems
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| RestaurantCategoryId | BIGINT | FK -> RestaurantCategories(Id) | |
| RestaurantId | BIGINT | FK -> Restaurants(Id) | |
| Name | NVARCHAR(200) | | |
| Description | NVARCHAR(1000) | NULL | |
| ImageUrl | NVARCHAR(500) | NULL | |
| BasePrice | DECIMAL(10,2) | | |
| DiscountPercent | DECIMAL(5,2) | DEFAULT 0 | |
| DiscountedPrice | DECIMAL(10,2) | COMPUTED | BasePrice - (BasePrice * DiscountPercent / 100) |
| IsVeg | BIT | | |
| IsAvailable | BIT | DEFAULT 1 | |
| IsBestseller | BIT | DEFAULT 0 | |
| IsCustomizable| BIT | DEFAULT 0 | |
| SortOrder | INT | DEFAULT 0 | |
| IsActive | BIT | | |
| CreatedAt | DATETIME2 | | |
| UpdatedAt | DATETIME2 | NULL | |

### FoodItemAddons
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| FoodItemId | BIGINT | FK -> FoodItems(Id) | |
| GroupName | NVARCHAR(100) | | e.g. Toppings, Drinks |
| Name | NVARCHAR(200) | | |
| Price | DECIMAL(10,2) | | |
| IsDefault | BIT | DEFAULT 0 | |
| IsActive | BIT | | |
| SortOrder | INT | DEFAULT 0 | |
| CreatedAt | DATETIME2 | | |

### FoodItemVariants
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| FoodItemId | BIGINT | FK -> FoodItems(Id) | |
| Name | NVARCHAR(200) | | e.g. Small, Medium, Large |
| AdditionalPrice | DECIMAL(10,2)| DEFAULT 0 | |
| IsDefault | BIT | | |
| IsActive | BIT | | |
| SortOrder | INT | DEFAULT 0 | |
| CreatedAt | DATETIME2 | | |

### FoodOrders
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| OrderNumber | NVARCHAR(20) | UNIQUE | |
| UserId | BIGINT | FK -> Users(Id) | |
| RestaurantId | BIGINT | FK -> Restaurants(Id) | |
| AddressId | BIGINT | FK -> Addresses(Id) | NULL |
| Status | NVARCHAR(20) | | Pending, Preparing, Ready, Delivered, Cancelled |
| SubTotal | DECIMAL(10,2) | | |
| DiscountAmount| DECIMAL(10,2) | DEFAULT 0 | |
| CouponId | BIGINT | FK -> Coupons(Id) | NULL |
| CouponDiscount| DECIMAL(10,2) | DEFAULT 0 | |
| DeliveryFee | DECIMAL(10,2) | | |
| TaxAmount | DECIMAL(10,2) | DEFAULT 0 | |
| GrandTotal | DECIMAL(10,2) | | |
| PaymentMethod | NVARCHAR(20) | | Cash, Card, UPI |
| PaymentStatus | NVARCHAR(20) | | Pending, Success, Failed |
| Notes | NVARCHAR(500) | NULL | |
| EstimatedDeliveryMinutes | INT | NULL | |
| CreatedAt | DATETIME2 | | |
| UpdatedAt | DATETIME2 | NULL | |

### FoodOrderItems
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| FoodOrderId | BIGINT | FK -> FoodOrders(Id) | |
| FoodItemId | BIGINT | FK -> FoodItems(Id) | |
| ItemName | NVARCHAR(200) | | Snapshot at time of order |
| Quantity | INT | | |
| UnitPrice | DECIMAL(10,2) | | Snapshot of price at order |
| VariantName | NVARCHAR(200) | NULL | Snapshot |
| VariantPrice | DECIMAL(10,2) | DEFAULT 0 | Snapshot |
| AddonsJson | NVARCHAR(MAX) | NULL | Serialized addons selected |
| TotalPrice | DECIMAL(10,2) | | |
| CreatedAt | DATETIME2 | | |

### Drivers
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| UserId | BIGINT | FK -> Users(Id) | UNIQUE |
| LicenseNumber | NVARCHAR(50) | | |
| IsVerified | BIT | DEFAULT 0 | |
| IsOnline | BIT | DEFAULT 0 | |
| CurrentLatitude | DECIMAL(10,7) | NULL | |
| CurrentLongitude| DECIMAL(10,7) | NULL | |
| Rating | DECIMAL(3,2) | DEFAULT 0 | |
| TotalRides | INT | DEFAULT 0 | |
| IsActive | BIT | | |
| CreatedAt | DATETIME2 | | |
| UpdatedAt | DATETIME2 | NULL | |

### Vehicles
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| DriverId | BIGINT | FK -> Drivers(Id) | |
| Type | NVARCHAR(20) | | Bike, Auto, Sedan, SUV |
| Make | NVARCHAR(100) | | |
| Model | NVARCHAR(100) | | |
| Year | INT | NULL | |
| RegistrationNumber| NVARCHAR(20)| | |
| Color | NVARCHAR(50) | NULL | |
| IsActive | BIT | | |
| CreatedAt | DATETIME2 | | |
| UpdatedAt | DATETIME2 | NULL | |

### Rides
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| RideNumber | NVARCHAR(20) | UNIQUE | |
| UserId | BIGINT | FK -> Users(Id) | |
| DriverId | BIGINT | FK -> Drivers(Id) | NULL (until assigned) |
| VehicleId | BIGINT | FK -> Vehicles(Id) | NULL |
| VehicleType | NVARCHAR(20) | | Requested vehicle type |
| PickupAddress | NVARCHAR(500) | | |
| PickupLatitude | DECIMAL(10,7) | | |
| PickupLongitude| DECIMAL(10,7) | | |
| DropoffAddress | NVARCHAR(500) | | |
| DropoffLatitude| DECIMAL(10,7) | | |
| DropoffLongitude| DECIMAL(10,7) | | |
| DistanceKm | DECIMAL(10,2) | NULL | |
| EstimatedFare | DECIMAL(10,2) | | |
| ActualFare | DECIMAL(10,2) | NULL | |
| Status | NVARCHAR(20) | | Requested, Accepted, Started, Completed, Cancelled |
| OtpCode | NVARCHAR(10) | NULL | Ride start OTP |
| PaymentMethod | NVARCHAR(20) | NULL | |
| PaymentStatus | NVARCHAR(20) | NULL | |
| StartedAt | DATETIME2 | NULL | |
| CompletedAt | DATETIME2 | NULL | |
| CancelledAt | DATETIME2 | NULL | |
| CancellationReason| NVARCHAR(500)| NULL | |
| CreatedAt | DATETIME2 | | |
| UpdatedAt | DATETIME2 | NULL | |

### MarketplaceCategories
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | INT | PK | |
| Name | NVARCHAR(100) | | |
| IconUrl | NVARCHAR(500) | NULL | |
| SortOrder | INT | DEFAULT 0 | |
| IsActive | BIT | | |
| CreatedAt | DATETIME2 | | |
| UpdatedAt | DATETIME2 | NULL | |

### MarketplaceListings
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| UserId | BIGINT | FK -> Users(Id) | Seller |
| CategoryId | INT | FK -> MarketplaceCategories(Id)| |
| Title | NVARCHAR(200) | | |
| Description | NVARCHAR(2000)| NULL | |
| Price | DECIMAL(12,2) | | |
| Condition | NVARCHAR(20) | | New, Used, etc. |
| Location | NVARCHAR(200) | | |
| Latitude | DECIMAL(10,7) | NULL | |
| Longitude | DECIMAL(10,7) | NULL | |
| Status | NVARCHAR(20) | DEFAULT 'ACTIVE' | ACTIVE, SOLD, HIDDEN |
| IsFeatured | BIT | DEFAULT 0 | |
| ViewCount | INT | DEFAULT 0 | |
| IsActive | BIT | | |
| CreatedAt | DATETIME2 | | |
| UpdatedAt | DATETIME2 | NULL | |

### ListingImages
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| ListingId | BIGINT | FK -> MarketplaceListings(Id)| |
| ImageUrl | NVARCHAR(500) | | |
| SortOrder | INT | DEFAULT 0 | |
| CreatedAt | DATETIME2 | | |

### Favorites
*Note: UNIQUE constraint on (UserId, ListingId)*
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| UserId | BIGINT | FK -> Users(Id) | |
| ListingId | BIGINT | FK -> MarketplaceListings(Id)| |
| CreatedAt | DATETIME2 | | |

### Coupons
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| Code | NVARCHAR(20) | UNIQUE | |
| Description | NVARCHAR(255) | NULL | |
| DiscountType | NVARCHAR(20) | | PERCENTAGE, FLAT |
| DiscountValue | DECIMAL(10,2) | | |
| MinOrderAmount | DECIMAL(10,2) | DEFAULT 0 | |
| MaxDiscount | DECIMAL(10,2) | NULL | |
| StartDate | DATETIME2 | | |
| ExpiryDate | DATETIME2 | | |
| TotalUsageLimit| INT | NULL | |
| PerUserLimit | INT | DEFAULT 1 | |
| CurrentUsageCount| INT | DEFAULT 0 | |
| ApplicableModule| NVARCHAR(20) | | FOOD, RIDE, ALL |
| IsActive | BIT | | |
| CreatedAt | DATETIME2 | | |
| UpdatedAt | DATETIME2 | NULL | |

### CouponUsages
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| CouponId | BIGINT | FK -> Coupons(Id) | |
| UserId | BIGINT | FK -> Users(Id) | |
| OrderId | BIGINT | NULL | Reference to FoodOrders etc. |
| UsedAt | DATETIME2 | | |

### Banners
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| Title | NVARCHAR(200) | | |
| ImageUrl | NVARCHAR(500) | | |
| TargetType | NVARCHAR(50) | NULL | e.g. RESTAURANT, LISTING |
| TargetId | NVARCHAR(50) | NULL | |
| Module | NVARCHAR(20) | | FOOD, RIDE, MARKETPLACE |
| SortOrder | INT | DEFAULT 0 | |
| IsActive | BIT | | |
| StartDate | DATETIME2 | NULL | |
| EndDate | DATETIME2 | NULL | |
| CreatedAt | DATETIME2 | | |
| UpdatedAt | DATETIME2 | NULL | |

### Reviews
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| UserId | BIGINT | FK -> Users(Id) | |
| TargetType | NVARCHAR(20) | | RESTAURANT, DRIVER, LISTING |
| TargetId | BIGINT | | Target ID |
| Rating | INT | | 1 to 5 |
| Comment | NVARCHAR(1000)| NULL | |
| CreatedAt | DATETIME2 | | |

### Notifications
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| UserId | BIGINT | FK -> Users(Id) | |
| Title | NVARCHAR(200) | | |
| Body | NVARCHAR(1000)| | |
| Type | NVARCHAR(50) | | |
| ReferenceId | NVARCHAR(50) | NULL | |
| IsRead | BIT | DEFAULT 0 | |
| CreatedAt | DATETIME2 | | |

### Payments
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | BIGINT | PK | |
| UserId | BIGINT | FK -> Users(Id) | |
| Module | NVARCHAR(20) | | FOOD, RIDE |
| OrderId | BIGINT | | Reference to FoodOrders/Rides |
| Amount | DECIMAL(10,2) | | |
| PaymentMethod | NVARCHAR(20) | | |
| TransactionId | NVARCHAR(100) | NULL | Provider trans ID |
| Status | NVARCHAR(20) | | |
| CreatedAt | DATETIME2 | | |
| UpdatedAt | DATETIME2 | NULL | |

### AppSettings
| Column | Type | Constraints | Description |
|---|---|---|---|
| Id | INT | PK | |
| SettingKey | NVARCHAR(100) | UNIQUE | |
| SettingValue | NVARCHAR(1000)| | |
| Description | NVARCHAR(255) | NULL | |
| UpdatedAt | DATETIME2 | | |

## Relationships
- A `User` can have multiple `UserRoles`.
- A `User` can have multiple `Addresses`.
- A `User` can own/manage multiple `Restaurants` via `RestaurantUsers`, and a `Restaurant` can have multiple `Users` (owners/managers).
- A `Restaurant` has multiple `RestaurantCategories` and `FoodItems`.
- A `RestaurantCategory` groups multiple `FoodItems`.
- A `FoodItem` has multiple `FoodItemAddons` and `FoodItemVariants`.
- A `FoodOrder` belongs to one `User`, one `Restaurant`, one `Address` (optional), and may have one `Coupon`.
- A `FoodOrder` contains multiple `FoodOrderItems` (each linking to a `FoodItem`).
- A `User` can have one `Driver` profile (1-to-1).
- A `Driver` has multiple `Vehicles` (or at least one).
- A `Ride` belongs to one `User`, can have one `Driver` and `Vehicle`, and is tracked by locations.
- A `User` can have multiple `MarketplaceListings`.
- A `MarketplaceListing` belongs to a `MarketplaceCategory` and has multiple `ListingImages`.
- A `User` can favorite multiple listings (`Favorites`).
- A `Coupon` has multiple `CouponUsages` linking back to `Users` and `Orders`.
- `Reviews` flexibly link to different target entities (Drivers, Restaurants, Listings) via `TargetType` and `TargetId`.
- `Payments` flexibly link to different module orders.

## Index Recommendations
1. `Users` -> Non-Clustered Index on `MobileNumber`, `Email`.
2. `FoodItems` -> Non-Clustered Index on `RestaurantId`, `IsActive`, `IsBestseller`.
3. `Restaurants` -> Spatial/Index on `Latitude, Longitude` for geospatial queries, and `City, IsActive`.
4. `Rides` -> Non-Clustered Index on `UserId`, `DriverId`, `Status`.
5. `FoodOrders` -> Non-Clustered Index on `UserId`, `RestaurantId`, `Status`.
6. `MarketplaceListings` -> Non-Clustered Index on `CategoryId`, `Status`, `IsActive`, `Latitude, Longitude`.
7. `Favorites` -> Unique Constraint / Index on `(UserId, ListingId)`.
8. `Coupons` -> Non-Clustered Index on `Code`.
9. `Drivers` -> Index on `IsOnline`, `CurrentLatitude, CurrentLongitude`.

## Discount Calculation Priority
1. **Item Discount First:** The base price of the food item is discounted first via `DiscountPercent` directly applied to get `DiscountedPrice`.
2. **Coupon Discount Second:** Any global or order-level coupon (e.g., flat amount or percentage on the entire order) is calculated on the *sum of the discounted prices* (the SubTotal), not the original BasePrices.
3. Order: `Subtotal` = SUM(`DiscountedPrice` * Quantity) + Addons. Then `CouponDiscount` is applied. Finally, `GrandTotal` = `Subtotal` - `CouponDiscount` + `DeliveryFee` + `TaxAmount`.

## Seed Data for Roles
| Id | Name | Description |
|---|---|---|
| 1 | Admin | Super Administrator |
| 2 | Customer | Regular User |
| 3 | RestaurantOwner | Vendor / Restaurant Manager |
| 4 | Driver | Ride Hailing Driver |

