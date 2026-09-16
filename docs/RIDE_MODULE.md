# Ride Module Documentation

The Ride Module facilitates rapid point-to-point urban transit (inspired by Rapido), supporting Bike Taxi, Auto Rickshaw, and Economy Cab tiers with upfront fare estimation, driver matching, passenger OTP verification, and real-time transit status tracking.

---

## 1. User Flows & Screens

### Customer Booking Flow (`RideBookingScreen`)
1. **Pickup & Destination Selection**:
   - Live location pickup point ("Connaught Place, Central Delhi").
   - Destination address input ("Terminal 3, IGI Airport (DEL)").
   - Route stats banner: "16.4 km • ~34 mins • Moderate Traffic".
2. **Interactive Mock Route Visualizer**:
   - Custom-painted styled route curve between pickup pin and destination pin with GPS online status indicator.
3. **Vehicle Tier Selector**:
   - **Bike Taxi** (`FASTEST` green badge): "Beat traffic • Helmet provided • 3m away" — ₹45.
   - **Auto Rickshaw** (`VALUE` blue badge): "Direct drop • Max 3 seats • 5m away" — ₹65.
   - **Economy Cab** (`COMFORT` purple badge): "AC Hatchback • Luggage space • 7m away" — ₹125.
4. **Booking CTA**:
   - Payment method toggle: "Cash / UPI".
   - One-tap booking action with dynamic fare display.

### Active Ride Transit Experience (`ActiveRideScreen`)
1. **Status & ETA Banner**:
   - "Rapido Bike In Transit" • "3 mins away (0.8 km)".
   - Quick-access "SOS Emergency" shield button.
2. **Start Ride OTP Box**:
   - Prominently styled 4-digit verification code (`4 8 2 9`) in dedicated high-contrast numeric boxes.
   - Security advisory: "Share this code only after sitting on the vehicle".
3. **Driver & Vehicle Details Card**:
   - Driver profile: "Amit Singh" • 4.9 ★ (1,240 trips).
   - Vehicle specifications: "Hero Splendor Plus (Black)".
   - License plate badge: `DL 04 AB 9821`.
   - Direct Call Driver & In-App Chat buttons.
4. **Trip Status Stepper**:
   - `Driver Assigned` (Completed) → `Arriving at Pickup` (Active) → `Ride Started` → `Drop-off Completed`.
5. **Trip Controls**:
   - Clean "Cancel Ride" option with confirmation.

---

## 2. Ride Lifecycle State Machine

```
[ REQUESTED ] ──▶ [ ASSIGNED ] ──▶ [ ACCEPTED ] ──▶ [ ARRIVING ]
                                                         │
                                               Passenger OTP Verified
                                                         │
                                                         ▼
[ CANCELLED ] ◀─────────────────────────────────── [ STARTED ]
                                                         │
                                                         ▼
                                                  [ COMPLETED ]
```

---

## 3. Implemented Backend APIs

| Endpoint | Method | Description |
|---|---|---|
| `/api/rides/estimate` | `POST` | Calculates distance, ETA, and vehicle options (Bike, Auto, Cab) with fare breakdown |
| `/api/rides/book` | `POST` | Books a ride, assigns nearest driver, and generates 4-digit ride verification OTP |
| `/api/rides/{id}` | `GET` | Fetches live ride details, coordinates, driver profile, and status |
| `/api/rides/{id}/start` | `POST` | Validates passenger OTP to start trip |
| `/api/rides/{id}/complete` | `POST` | Finalizes trip, records actual fare and payment status |
| `/api/rides/{id}/cancel` | `POST` | Cancels ride request before trip start |
