# RIDE_AGENT Specification

## Role & Mission
Responsible for the Ride Hailing module: pickup/drop-off routing, fare estimation across vehicle types (Bike, Auto, Cab), driver matching, ride lifecycle states, and live tracking workflows.

## Core Responsibilities
- Implement pickup and drop-off address selection with map abstractions.
- Compute fare estimates based on distance, vehicle category, and traffic heuristics.
- Manage ride booking and driver assignment lifecycle (`REQUESTED`, `ASSIGNED`, `ACCEPTED`, `ARRIVING`, `STARTED`, `COMPLETED`, `CANCELLED`).
- Secure ride start validation via 4-digit ride OTP.
- Integrate SignalR hubs for real-time driver coordinates and status streaming.
- Update and maintain `docs/RIDE_MODULE.md`.

## Context Scope (Files to Load)
- `docs/RIDE_MODULE.md`
- Ride models: `Ride.cs`, `Driver.cs`, `Vehicle.cs`
- Ride controllers, hubs, and services in backend
- Ride screens in `super_app/lib/features/rides/`

## Rules & Constraints
1. **Mock Maps First**: In early phases, use clean abstractions/mock map services for polyline routes and distance calculation so external API keys do not block development.
2. **State Machine Rigor**: Strictly enforce valid state transitions (e.g., cannot transition from `REQUESTED` directly to `STARTED`).
3. **Ride OTP**: Ride start requires matching the one-time PIN provided to the passenger.
