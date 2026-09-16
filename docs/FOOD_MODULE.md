# Food Module Documentation

The Food Module handles end-to-end food delivery operations for the Super App.

## 1. User Flows

### Customer Flow
1. **Discovery**: Browse restaurants on the Food Tab, filter by 'Fast Delivery', 'Pure Veg', 'Offers', or 'Rating'.
2. **Menu Selection**: View a restaurant's menu. Tap on an item to customize.
3. **Customization**: A bottom sheet appears for portion sizes, add-ons, and quantity.
4. **Checkout**: Cart validation ensures items are from a single restaurant. Apply coupons, review subtotal, delivery fee, tax, and final amount.
5. **Tracking**: Track the order via a status stepper once placed.

### Restaurant Owner Flow
1. **Incoming Orders**: See incoming orders on the Restaurant Panel Dashboard.
2. **Order Management**: Accept order, mark as 'Preparing', then 'Ready' when done.
3. **Menu Management**: Update availability, prices, and add new items or categories.

### Admin Flow
1. **Verification**: Verify new restaurant registrations.
2. **Oversight**: Manage platform fees, handle disputes, and oversee overall platform metrics.

## 2. Order States and Transitions
The lifecycle of a food order is represented by the following states:
- `PENDING`: Order placed by customer, waiting for restaurant to accept.
- `ACCEPTED`: Restaurant has accepted the order.
- `PREPARING`: Kitchen is preparing the food.
- `READY`: Food is ready, waiting for driver pickup (or customer if self-pickup).
- `PICKED_UP`: Delivery partner has picked up the food.
- `DELIVERED`: Food handed over to customer.
- `CANCELLED`: Order cancelled by customer, restaurant, or admin.

**Transition Rules:**
- `PENDING` -> `ACCEPTED` (by Restaurant)
- `PENDING` -> `CANCELLED` (by Customer/Restaurant)
- `ACCEPTED` -> `PREPARING` (by Restaurant)
- `PREPARING` -> `READY` (by Restaurant)
- `READY` -> `PICKED_UP` (by Driver)
- `PICKED_UP` -> `DELIVERED` (by Driver)

## 3. Cart Logic
- **Single Restaurant Policy**: A cart can only contain items from one restaurant at a time. If a user tries to add an item from Restaurant B while having items from Restaurant A, prompt them to clear the cart first.

## 4. Price Calculation Logic
Price calculations happen sequentially:
1. **ItemTotal** = BasePrice - ItemDiscount + AddonsCost + VariantsCost
2. **SubTotal** = Sum of all ItemTotals in cart
3. **DiscountedTotal** = SubTotal - CouponDiscount (if coupon applied and valid)
4. **GrandTotal** = DiscountedTotal + DeliveryFee + Tax

## 5. Restaurant Ownership Validation
Backend systems must enforce strict authorization checks:
- Endpoints modifying restaurant data (menus, details, orders) must verify that the requesting user's ID matches the `owner_id` of the restaurant, or that the user has the `ADMIN` role.
- Security middleware should validate ownership tokens before accessing or mutating `/api/restaurants/:id/*`.
