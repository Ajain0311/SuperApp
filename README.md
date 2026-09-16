# SuperApp — Unified Multi-Service Platform

[![.NET 10](https://img.shields.io/badge/.NET-10.0-512BD4?logo=dotnet)](https://dotnet.microsoft.com/)
[![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?logo=flutter)](https://flutter.dev/)
[![SQL Server](https://img.shields.io/badge/SQL%20Server-2022-CC292B?logo=microsoftsqlserver)](https://www.microsoft.com/sql-server)
[![Architecture](https://img.shields.io/badge/Architecture-Modular%20Monolith-blue)](#architecture--modules)
[![Status](https://img.shields.io/badge/Status-Phase%201%20Complete%20%7C%20Phase%202%20Active-brightgreen)](#current-development-status)

A modern, production-grade **Super App** platform combining three high-frequency on-demand services into one customer mobile application, backed by a unified ASP.NET Core modular monolith backend, SQL Server database, and dedicated web management panels.

---

## Architecture & Modules

```
                                  SUPER APP PLATFORM
                                          │
                  ┌───────────────────────┼───────────────────────┐
                  ▼                       ▼                       ▼
            ORDER FOOD                  RIDE                 MARKETPLACE
      (Swiggy/Zomato Concept)      (Rapido Concept)         (OLX Concept)
       Restaurants & Dishes       Bikes, Autos, Cabs      P2P Local Buy & Sell
                  │                       │                       │
                  └───────────────────────┼───────────────────────┘
                                          ▼
                               Common Customer Identity
                                          │
                  ┌───────────────────────┴───────────────────────┐
                  ▼                                               ▼
          Customer Mobile App                             Web Admin & Vendor
         (Flutter iOS/Android)                            Management Panels
                  │                                               │
                  └───────────────────────┬───────────────────────┘
                                          ▼
                                 ASP.NET Core Web API
                                  (Modular Monolith)
                                          │
                                      SQL Server
```

### 1. Customer Mobile App (Flutter)
One single mobile application for iOS and Android containing:
- **Food Delivery**: Restaurant discovery, item customizations (portions, add-ons), cart management, real-time order tracking, and coupon applications.
- **Ride Booking**: Pickup/destination selection, route visualization, fare estimates across vehicle tiers (Bike Taxi, Auto Rickshaw, Economy Cab), driver assignment, and OTP ride validation.
- **Marketplace (Bazaar)**: P2P classified listings, category filters, verified seller items, image galleries, and listing management.
- **Unified Identity**: Single sign-on with phone number and OTP verification, profile management, saved addresses, and unified order history.

### 2. Admin Web Panel
System-wide administrative control:
- Platform analytics and live order/ride dashboards
- User & role management (Customers, Drivers, Sellers, Admins)
- Restaurant onboarding & menu approvals
- Coupon engine, promotions, and global banners
- Dispute moderation & support

### 3. Restaurant / Vendor Panel
Dedicated portal for restaurant owners:
- Live order management with kitchen workflow states (`PENDING` → `ACCEPTED` → `PREPARING` → `READY` → `PICKED_UP`)
- Menu category & item management with custom add-ons and portions
- Store availability, operating hours, and daily sales metrics

### 4. Backend & Database
- **Framework**: ASP.NET Core Web API (.NET 10)
- **Architecture**: Modular Monolith (simple, clean, no microservices overhead)
- **Database**: Microsoft SQL Server with Entity Framework Core
- **Real-Time**: SignalR for live tracking, order state transitions, and messaging
- **Security**: Role-based access control (RBAC) powered by a unified `Users`, `Roles`, and `UserRoles` schema (no fragmented identity tables)

---

## Technology Stack

| Layer | Technologies |
|---|---|
| **Mobile App** | Flutter 3.47+, Dart, Riverpod, GoRouter, Dio |
| **Backend API** | ASP.NET Core 10 Web API, C#, EF Core 10, BCrypt.Net |
| **Database** | Microsoft SQL Server 2022 / LocalDB / Azure SQL |
| **API Documentation** | OpenAPI / Swashbuckle Swagger UI |
| **Real-Time Engine** | ASP.NET Core SignalR |
| **State & Navigation** | Flutter Riverpod 2.6, GoRouter 14.8 |
| **UI Design System** | Custom Dark Theme (`#0A0E21`), Orange Accent (`#FF6B35`), Green Accent (`#00C853`) |

---

## Repository Structure

```text
SuperApp/
├── .gitignore                   # Root-level Git ignore covering .NET, Flutter, IDEs, OS, secrets
├── SuperApp.sln                 # Classic Visual Studio solution file
├── SuperApp.slnx                # Modern .NET 10 solution file
├── README.md                    # Root project documentation
│
├── SuperApp.API/                # ASP.NET Core Web API (.NET 10)
│   ├── Controllers/             # REST controllers (AuthController, Admin, Vendor, Customer)
│   ├── Data/                    # AppDbContext with Fluent API mappings and seed data
│   ├── DTOs/                    # Request/Response Data Transfer Objects
│   ├── Middleware/              # Global ExceptionMiddleware and pipeline filters
│   ├── Models/                  # EF Core entities (27 domain models)
│   ├── Services/                # Service layer (IOtpService, ITokenService, etc.)
│   ├── appsettings.json         # Development configuration
│   └── Program.cs               # Application entry point, DI, Swagger, and middleware
│
├── super_app/                   # Flutter Mobile Application
│   ├── lib/
│   │   ├── core/                # Core theme, router, network client, and constants
│   │   ├── features/            # Feature modules (auth, splash, home, food, rides, bazaar)
│   │   ├── shared/              # Reusable UI widgets (AppButton, Badges, SearchBar, etc.)
│   │   └── main.dart            # Flutter entry point
│   └── pubspec.yaml             # Flutter dependencies and asset configuration
│
├── agents/                      # Multi-Agent Architecture Specifications & Workflows
│   ├── README.md                # Multi-agent framework overview and routing rules
│   ├── COORDINATION.md          # Orchestrator patterns and sequential/parallel execution
│   ├── TOKEN_OPTIMIZATION.md    # Strict token and context preservation guidelines
│   └── *.md                     # 14 specialized agent role specifications
│
└── docs/                        # Complete Technical & Product Documentation
    ├── PROJECT_STATUS.md        # Single Source of Truth for roadmap and phase status
    ├── CHANGELOG.md             # Chronological record of meaningful changes
    ├── ARCHITECTURE.md          # Architectural decisions and module relationships
    ├── DATABASE.md              # Complete DB schema, relationships, and index strategy
    ├── API.md                   # Endpoint specifications and action pattern documentation
    ├── AUTHENTICATION.md        # Phone + OTP and Admin auth workflow
    ├── DESIGN_SYSTEM.md         # Theme colors, typography, and component specifications
    ├── SCREEN_FLOW.md           # End-to-end screen transitions and user journeys
    ├── FOOD_MODULE.md           # Food ordering domain documentation
    ├── RIDE_MODULE.md           # Ride hailing domain documentation
    ├── MARKETPLACE_MODULE.md    # Marketplace classifieds documentation
    ├── ADMIN_PANEL.md           # Admin portal functional specifications
    ├── RESTAURANT_PANEL.md      # Restaurant vendor portal functional specifications
    └── DEVELOPMENT_ROADMAP.md   # 10-phase execution roadmap
```

---

## Current Development Status

> **Single Source of Truth**: Refer to [`docs/PROJECT_STATUS.md`](docs/PROJECT_STATUS.md) for live phase tracking.

- **Phase 1 (Setup, Architecture, Documentation, Design System)**: **COMPLETED ✅**
  - Full documentation suite established in `/docs/`
  - .NET 10 Web API and Flutter projects initialized and building with 0 errors
  - Core design system, UI components, and Dark Theme configured
  - Multi-agent development architecture formalized in `/agents/`
- **Phase 2 (Database & Authentication)**: **IN PROGRESS 🔄**
  - 27 EF Core models with complete Fluent API constraints and seed data created
  - Mock OTP (`123456`) and JWT authentication service implemented
  - Customer phone login and Admin password + OTP login endpoints live
  - Flutter Splash, Phone Entry, OTP Verification, and Main Navigation Shell active
- **Phase 3 (Customer App Shell & Unified Home)**: **QUEUED ⏳**
- **Phase 4–10 (Feature Modules, Panels, Real-Time, Polish)**: **PLANNED ⏳**

---

## Local Development Setup

### Prerequisites
- [.NET 10 SDK](https://dotnet.microsoft.com/)
- [Flutter SDK 3.47+](https://flutter.dev/)
- [SQL Server 2022 / LocalDB / Docker SQL](https://www.microsoft.com/sql-server)

### 1. Backend Setup (`SuperApp.API`)
```bash
# Clone the repository
git clone https://github.com/Ajain0311/SuperApp.git
cd SuperApp

# Restore dependencies and build
dotnet restore
dotnet build

# Update connection string in SuperApp.API/appsettings.json if needed:
# "Server=localhost;Database=SuperAppDb;Trusted_Connection=true;TrustServerCertificate=true;"

# Run the API server
cd SuperApp.API
dotnet run
```
*Swagger UI is available at:* `https://localhost:5001/swagger` or `http://localhost:5000/swagger`

### 2. Mobile App Setup (`super_app`)
```bash
cd super_app

# Install Flutter dependencies
flutter pub get

# Run on connected device / emulator
flutter run
```

---

## Multi-Agent Architecture & Token Optimization

To guarantee high code quality, prevent cross-domain regression, and drastically minimize LLM token/context consumption, development in this repository is partitioned across **14 specialized agents**:

| Agent | Domain Responsibility |
|---|---|
| [`ARCHITECTURE_AGENT`](agents/ARCHITECTURE_AGENT.md) | High-level system structure, modular boundaries, cross-module contracts |
| [`BACKEND_AGENT`](agents/BACKEND_AGENT.md) | ASP.NET Core APIs, controllers, services, business logic, DTOs |
| [`DATABASE_AGENT`](agents/DATABASE_AGENT.md) | SQL Server schema, EF Core migrations, relationships, indexes |
| [`AUTH_AGENT`](agents/AUTH_AGENT.md) | Phone+OTP flows, JWT security, user roles, admin auth |
| [`FLUTTER_AGENT`](agents/FLUTTER_AGENT.md) | Mobile app screens, state management, widgets, API wiring |
| [`FOOD_AGENT`](agents/FOOD_AGENT.md) | Food ordering, restaurants, menus, cart, orders, coupons |
| [`RIDE_AGENT`](agents/RIDE_AGENT.md) | Ride hailing, vehicle tiers, driver matching, ride states |
| [`MARKETPLACE_AGENT`](agents/MARKETPLACE_AGENT.md) | P2P listings, categories, seller profiles, favorites |
| [`ADMIN_AGENT`](agents/ADMIN_AGENT.md) | System-wide admin web dashboard and management sections |
| [`RESTAURANT_AGENT`](agents/RESTAURANT_AGENT.md) | Vendor dashboard, menu management, kitchen orders |
| [`UI_UX_AGENT`](agents/UI_UX_AGENT.md) | Design system, dark theme polish, component library |
| [`TESTING_AGENT`](agents/TESTING_AGENT.md) | API integration tests, Flutter widget/unit tests, regressions |
| [`DOCUMENTATION_AGENT`](agents/DOCUMENTATION_AGENT.md) | Keeping `/docs/` and `PROJECT_STATUS.md` perfectly in sync |
| [`CODE_REVIEW_AGENT`](agents/CODE_REVIEW_AGENT.md) | Hygiene checks, deduplication, security, architectural compliance |

### Token Optimization Guidelines
1. **Targeted Context Loading**: Agents only load documentation and source files directly required for their current assignment.
2. **Standardized Handoffs**: Communication between agents uses a standardized compact schema (`COMPLETED`, `FILES CHANGED`, `API CHANGES`, `NEXT AGENT`).
3. **Single Source of Truth**: All progress flows through [`docs/PROJECT_STATUS.md`](docs/PROJECT_STATUS.md) rather than re-evaluating the entire codebase.

See [`agents/README.md`](agents/README.md) and [`agents/TOKEN_OPTIMIZATION.md`](agents/TOKEN_OPTIMIZATION.md) for full operational protocols.

---

## Development Workflow & Change Control

1. **Check Status**: Consult `docs/PROJECT_STATUS.md` before initiating any task.
2. **Assign Specialized Agent**: Identify domain requirements and route to the corresponding agent.
3. **Execute & Verify**: Build and test changes locally (`dotnet build`, `flutter test`).
4. **Document Immediately**: Update `docs/PROJECT_STATUS.md` and `docs/CHANGELOG.md`.
5. **Git Hygiene**: Clean status, no generated files or secrets committed. Explicit confirmation required for pushes.

---

## License
Proprietary — All rights reserved.
