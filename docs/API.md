# Super App API Documentation

## 1. Authentication Module (AUTH)

### Send OTP
- **Method:** POST
- **URL:** `/api/auth/send-otp`
- **Auth/Role:** Public
- **Request Body:** `{ "mobileNumber": "string" }`
- **Response:** `200 OK`
- **Status Codes:** 200, 400

### Verify OTP
- **Method:** POST
- **URL:** `/api/auth/verify-otp`
- **Auth/Role:** Public
- **Request Body:** `{ "mobileNumber": "string", "otpCode": "string" }`
- **Response:** `{ "token": "jwt_string", "user": { ... }, "roles": ["Customer"] }`
- **Status Codes:** 200, 400, 401

### Admin Login
- **Method:** POST
- **URL:** `/api/auth/admin-login`
- **Auth/Role:** Public
- **Request Body:** `{ "mobileNumber": "string", "password": "string", "otpCode": "string" }`
- **Response:** `{ "token": "jwt_string", "user": { ... }, "roles": ["Admin"] }`
- **Status Codes:** 200, 400, 401

### Get Profile
- **Method:** GET
- **URL:** `/api/auth/profile`
- **Auth/Role:** Requires Auth
- **Request Body:** N/A
- **Response:** User details JSON
- **Status Codes:** 200, 401

### Update Profile
- **Method:** PUT
- **URL:** `/api/auth/profile`
- **Auth/Role:** Requires Auth
- **Request Body:** `{ "fullName": "string", "email": "string", "profileImage": "url" }`
- **Response:** `200 OK`
- **Status Codes:** 200, 400, 401

---

## 2. Administrator Module (ADMIN)

*All endpoints require Auth and 'Admin' role.*

### Users CRUD
- **Method:** POST
- **URL:** `/api/admin/users`
- **Request Body:** `{ "action": "ADD|EDIT|STATUS", "data": { ... } }`
- **Response:** Status and updated data

### Restaurants CRUD
- **Method:** POST
- **URL:** `/api/admin/restaurants`
- **Request Body:** `{ "action": "ADD|EDIT|DELETE|STATUS", "data": { ... } }`
- **Response:** Status and updated data

### Food Categories CRUD
- **Method:** POST
- **URL:** `/api/admin/food-categories`
- **Request Body:** `{ "action": "ADD|EDIT|DELETE|STATUS", "data": { ... } }`
- **Response:** Status and updated data

### Food Items CRUD
- **Method:** POST
- **URL:** `/api/admin/food-items`
- **Request Body:** `{ "action": "ADD|EDIT|DELETE|STATUS", "data": { ... } }`
- **Response:** Status and updated data

### Drivers CRUD
- **Method:** POST
- **URL:** `/api/admin/drivers`
- **Request Body:** `{ "action": "ADD|EDIT|STATUS", "data": { ... } }`
- **Response:** Status and updated data

### Marketplace Categories CRUD
- **Method:** POST
- **URL:** `/api/admin/marketplace-categories`
- **Request Body:** `{ "action": "ADD|EDIT|DELETE|STATUS", "data": { ... } }`
- **Response:** Status and updated data

### Coupons CRUD
- **Method:** POST
- **URL:** `/api/admin/coupons`
- **Request Body:** `{ "action": "ADD|EDIT|DELETE|STATUS", "data": { ... } }`
- **Response:** Status and updated data

### Banners CRUD
- **Method:** POST
- **URL:** `/api/admin/banners`
- **Request Body:** `{ "action": "ADD|EDIT|DELETE|STATUS", "data": { ... } }`
- **Response:** Status and updated data

### Offers CRUD
- **Method:** POST
- **URL:** `/api/admin/offers`
- **Request Body:** `{ "action": "ADD|EDIT|DELETE|STATUS", "data": { ... } }`
- **Response:** Status and updated data

### Get Dashboard Stats
- **Method:** GET
- **URL:** `/api/admin/dashboard`
- **Response:** Aggregate statistics JSON

### Admin Get Queries
- `GET /api/admin/users?role=&search=&page=&pageSize=`
- `GET /api/admin/restaurants?search=&page=&pageSize=`
- `GET /api/admin/orders?status=&page=&pageSize=`
- `GET /api/admin/rides?status=&page=&pageSize=`
- `GET /api/admin/listings?status=&page=&pageSize=`

---

## 3. Restaurant Owner Module (RESTAURANT OWNER)

*All endpoints require Auth and 'RestaurantOwner' role.*

### Get My Restaurant
- **Method:** GET
- **URL:** `/api/vendor/my-restaurant`
- **Response:** Restaurant details

### Update Restaurant Details
- **Method:** PUT
- **URL:** `/api/vendor/restaurant`
- **Request Body:** `{ ...details... }`
- **Response:** `200 OK`

### Categories CRUD
- **Method:** POST
- **URL:** `/api/vendor/categories`
- **Request Body:** `{ "action": "ADD|EDIT|DELETE|STATUS", "data": { ... } }`

### Food Items CRUD
- **Method:** POST
- **URL:** `/api/vendor/food-items`
- **Request Body:** `{ "action": "ADD|EDIT|DELETE|STATUS", "data": { ... } }`

### Vendor Orders Query
- **Method:** GET
- **URL:** `/api/vendor/orders?status=&page=&pageSize=`

### Update Order Status
- **Method:** PUT
- **URL:** `/api/vendor/orders/{id}/status`
- **Request Body:** `{ "status": "string" }`

### Vendor Dashboard Stats
- **Method:** GET
- **URL:** `/api/vendor/dashboard`

---

## 4. Customer - Food Module (CUSTOMER - FOOD)

### Get Restaurants
- **Method:** GET
- **URL:** `/api/restaurants?search=&category=&lat=&lng=&page=&pageSize=`
- **Auth/Role:** Public / Customer
- **Response:** Paged list of restaurants

### Get Restaurant Details
- **Method:** GET
- **URL:** `/api/restaurants/{id}`
- **Auth/Role:** Public / Customer

### Get Restaurant Menu
- **Method:** GET
- **URL:** `/api/restaurants/{id}/menu`
- **Auth/Role:** Public / Customer

### Place Food Order
- **Method:** POST
- **URL:** `/api/food-orders`
- **Auth/Role:** Requires Auth (Customer)
- **Request Body:** `{ "items": [...], "addressId": 1, "couponCode": "string", "paymentMethod": "string" }`

### Get My Food Orders
- **Method:** GET
- **URL:** `/api/food-orders`
- **Auth/Role:** Requires Auth (Customer)

### Get Food Order Details
- **Method:** GET
- **URL:** `/api/food-orders/{id}`
- **Auth/Role:** Requires Auth (Customer)

### Cancel Food Order
- **Method:** POST
- **URL:** `/api/food-orders/{id}/cancel`
- **Auth/Role:** Requires Auth (Customer)

### Validate Coupon
- **Method:** POST
- **URL:** `/api/coupons/validate`
- **Auth/Role:** Requires Auth
- **Request Body:** `{ "code": "string", "orderAmount": 100.0, "module": "FOOD" }`

---

## 5. Customer - Ride Module (CUSTOMER - RIDE)

### Estimate Ride
- **Method:** POST
- **URL:** `/api/rides/estimate`
- **Auth/Role:** Requires Auth (Customer)
- **Request Body:** `{ "pickup": {...}, "dropoff": {...}, "vehicleType": "string" }`
- **Response:** Estimated Fare

### Book Ride
- **Method:** POST
- **URL:** `/api/rides/book`
- **Auth/Role:** Requires Auth (Customer)
- **Request Body:** `{ "pickup": {...}, "dropoff": {...}, "vehicleType": "string", "paymentMethod": "string" }`

### Get Ride Details
- **Method:** GET
- **URL:** `/api/rides/{id}`
- **Auth/Role:** Requires Auth (Customer)

### Get My Rides
- **Method:** GET
- **URL:** `/api/rides`
- **Auth/Role:** Requires Auth (Customer)

### Cancel Ride
- **Method:** POST
- **URL:** `/api/rides/{id}/cancel`
- **Auth/Role:** Requires Auth (Customer)

### Rate Ride
- **Method:** POST
- **URL:** `/api/rides/{id}/rate`
- **Auth/Role:** Requires Auth (Customer)
- **Request Body:** `{ "rating": 5, "comment": "string" }`

---

## 6. Customer - Marketplace Module (CUSTOMER - MARKETPLACE)

### Browse Listings
- **Method:** GET
- **URL:** `/api/marketplace?category=&search=&minPrice=&maxPrice=&page=&pageSize=`
- **Auth/Role:** Public / Customer

### Get Listing Details
- **Method:** GET
- **URL:** `/api/marketplace/{id}`
- **Auth/Role:** Public / Customer

### Marketplace Listings CRUD (My Listings)
- **Method:** POST
- **URL:** `/api/marketplace/listings`
- **Auth/Role:** Requires Auth (Customer)
- **Request Body:** `{ "action": "ADD|EDIT|DELETE|STATUS", "data": { ... } }`

### Get My Listings
- **Method:** GET
- **URL:** `/api/marketplace/my-listings`
- **Auth/Role:** Requires Auth (Customer)

### Add Favorite
- **Method:** POST
- **URL:** `/api/marketplace/favorites`
- **Auth/Role:** Requires Auth (Customer)
- **Request Body:** `{ "listingId": 1 }`

### Remove Favorite
- **Method:** DELETE
- **URL:** `/api/marketplace/favorites/{listingId}`
- **Auth/Role:** Requires Auth (Customer)

### Get Favorites
- **Method:** GET
- **URL:** `/api/marketplace/favorites`
- **Auth/Role:** Requires Auth (Customer)

---

## 7. Common Module (COMMON)

### Get Addresses
- **Method:** GET
- **URL:** `/api/addresses`
- **Auth/Role:** Requires Auth

### Addresses CRUD
- **Method:** POST
- **URL:** `/api/addresses`
- **Auth/Role:** Requires Auth
- **Request Body:** `{ "action": "ADD|EDIT|DELETE|STATUS", "data": { ... } }`

### Get Notifications
- **Method:** GET
- **URL:** `/api/notifications`
- **Auth/Role:** Requires Auth

### Mark Notification as Read
- **Method:** PUT
- **URL:** `/api/notifications/{id}/read`
- **Auth/Role:** Requires Auth

### Get Banners
- **Method:** GET
- **URL:** `/api/banners?module=FOOD`
- **Auth/Role:** Public

### Add Review
- **Method:** POST
- **URL:** `/api/reviews`
- **Auth/Role:** Requires Auth
- **Request Body:** `{ "targetType": "string", "targetId": 1, "rating": 5, "comment": "string" }`

---
