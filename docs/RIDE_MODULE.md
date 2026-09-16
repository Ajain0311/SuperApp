# Ride Module Documentation

The Ride Module facilitates point-to-point transportation booking.

## 1. Ride Flow
1. **Discovery**: Customer enters destination on the Rides Tab.
2. **Selection**: Customer reviews routes on the map and selects a vehicle type (Bike, Auto, Cab).
3. **Request**: Customer requests the ride.
4. **Matching**: System assigns a nearby driver.
5. **Execution**: Driver arrives, asks for OTP, starts the ride, and drops the customer off.
6. **Completion**: Payment (if cash) and rating.

## 2. Vehicle Types
- **BIKE**: Bike Taxi. Fast, cheap, for 1 person.
- **AUTO**: Auto Rickshaw. Mid-tier pricing, up to 3 people.
- **CAB**: Economy Cab. Premium pricing, comfort, up to 4 people.

## 3. Fare Calculation
Fares are estimated upfront and calculated via:
- `BaseFare`: Initial cost for booking.
- `PerKmRate`: Cost per kilometer of distance.
- `PerMinuteRate`: Cost per minute of estimated duration.
**Total Fare** = BaseFare + (Distance * PerKmRate) + (Duration * PerMinuteRate)
*Note: Surge pricing multiplier can be applied to the total fare during high demand.*

## 4. Mock Map Implementation Strategy
For the initial development phase, real Google Maps integration might be too costly or complex.
- **Map UI**: Use a static map image or Mapbox/Leaflet with open-source tiles.
- **Geocoding**: Provide a list of pre-defined "hotspots" (e.g., Station, Airport, Mall) instead of full free-text search.
- **Route Line**: Draw a straight SVG line between pickup and dropoff on a simplified map canvas, or use a basic mock polyline.
- **Distance/ETA**: Hardcode random realistic values based on coordinate distances.

## 5. Driver Assignment Logic
- Fetch active drivers matching the requested vehicle type.
- Filter drivers within a specific radius (e.g., 5km) from the pickup location.
- Send the ride request to drivers in a round-robin or broadcast fashion.
- The first driver to accept is assigned to the ride.

## 6. Ride States and Transitions
- `REQUESTED`: Ride requested, waiting for driver.
- `ASSIGNED`: Driver matched, waiting for driver to accept.
- `ACCEPTED`: Driver accepted, on the way to pickup.
- `ARRIVING`: Driver is near pickup location.
- `STARTED`: Driver entered the 4-digit OTP provided by the customer, journey begins.
- `COMPLETED`: Destination reached, ride finished.
- `CANCELLED`: Ride aborted before completion.

**Crucial Step:** `ACCEPTED` -> `STARTED` requires OTP verification by the driver app to ensure the right customer is picked up.
