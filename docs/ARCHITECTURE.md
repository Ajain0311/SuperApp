# Architecture Document: Super App

## System Overview
The Super App is built as a **Modular Monolith**. It consolidates three major business domains—Food Ordering, Ride Booking, and Marketplace—into a single backend service, offering a unified user experience on the client side.

### High-Level Architecture Diagram
```text
+-----------------------+       +-------------------------+       +-------------------+
|      Mobile App       |       |       Admin Panel       |       |  Restaurant Panel |
|       (Flutter)       |       | (Web SPA / Razor Pages) |       |    (Web SPA)      |
+-----------------------+       +-------------------------+       +-------------------+
            |                               |                               |
            | HTTP / REST (JSON)            | HTTP / REST (JSON)            | HTTP / REST
            | WebSocket (SignalR)           |                               |
            v                               v                               v
+-----------------------------------------------------------------------------------------+
|                                    SuperApp.API                                         |
|                                (ASP.NET Core Web API)                                   |
|                                                                                         |
|  +----------------+ +----------------+ +----------------+ +--------------------------+  |
|  | Authentication | |  Food Module   | |  Ride Module   | |    Marketplace Module    |  |
|  +----------------+ +----------------+ +----------------+ +--------------------------+  |
|                                                                                         |
|  +----------------+ +----------------+ +----------------+ +--------------------------+  |
|  |   Middleware   | |   Services     | |      Hubs      | |           Data           |  |
|  +----------------+ +----------------+ +----------------+ +--------------------------+  |
+-----------------------------------------------------------------------------------------+
            |
            | EF Core (LINQ to SQL)
            v
+-----------------------+
|      SQL Server       |
|    (Single DB)        |
+-----------------------+
```

## Project Structure: Backend (SuperApp.API)
The ASP.NET Core project uses a clean directory structure:
- `Controllers/`: API Endpoints (using Minimal APIs or MVC Controllers with Action Parameter pattern)
- `Models/`: Domain entities representing database tables.
- `Data/`: EF Core `DbContext` and repository abstractions (if any) or generic repository implementations.
- `Services/`: Business logic layer (e.g., `OtpService`, `OrderService`, `RideService`).
- `Hubs/`: SignalR hubs for real-time communication (`RideTrackingHub`, `ChatHub`).
- `Middleware/`: Custom middlewares for global error handling, logging, etc.
- `DTOs/`: Data Transfer Objects for request and response mapping.

## Project Structure: Frontend (Flutter)
The mobile app employs a feature-first architectural pattern.
- `lib/core/`: Application-wide utilities, themes, routing, and HTTP client configurations.
- `lib/shared/`: Reusable UI widgets and cross-feature services.
- `lib/features/`: Isolated feature modules.
  - `auth/`
  - `home/`
  - `food/`
  - `ride/`
  - `marketplace/`
  - `profile/`

## Web Panels
- **Admin Panel:** Designed for system administrators to manage users, drivers, restaurants, and marketplace listings. Can be built using Razor Pages or a modern SPA framework (e.g., Blazor, React, Angular).
- **Restaurant Panel:** Dedicated dashboard for restaurant owners to manage menus, receive orders, and update statuses.

## Database
- **Provider:** SQL Server
- **ORM:** Entity Framework Core (EF Core)
- **Identity:** Unified users table with Roles. A `UserRoles` joining table will handle mapping. No separate Admin table will be used.

## Real-time Capabilities (SignalR)
SignalR will be heavily utilized for:
- Live tracking of rides (Driver location updates).
- Real-time order status updates for the Food module.
- Instant messaging in the Marketplace chat feature.

## Authentication
- Users authenticate using their Phone Number + OTP.
- Administrators authenticate using Phone Number + Password + OTP.
- The system employs JWT (JSON Web Tokens) for maintaining stateless authentication.

## API Design
- Endpoints will favor action parameters (e.g., `POST /api/users/{id}/deactivate`) for clear intention.
- Minimal APIs can be used where appropriate for lean, fast endpoint declaration.
