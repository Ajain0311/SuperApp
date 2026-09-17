# SuperApp Environment Configuration Guide

This document defines the **Configuration-First, Environment-Driven** architecture of the SuperApp platform. The application is completely decoupled from hardcoded credentials, enabling seamless transitions across **Development**, **Staging**, and **Production** environments strictly through configuration.

---

## 1. Core Architectural Tenets

1. **Zero Hardcoded Secrets**: No connection strings, API keys, JWT secrets, passwords, or cloud endpoints are hardcoded in source code.
2. **Provider-Agnostic Abstractions**: All external dependencies (SMS/OTP, Maps, Payments, Storage, Notifications) are behind dependency-injected interfaces (`IOtpService`, `IMapService`, `IPaymentService`, `IStorageService`, `INotificationService`).
3. **Zero-Dependency Development**: The app ships with `Mock` and `Local` providers enabled by default. Developers can boot, run, and test the full feature set offline without third-party vendor accounts.
4. **Configuration Precedence**:
   $$\text{Environment Variables (OS/Docker/K8s)} \longrightarrow \text{appsettings.\{Environment\}.json} \longrightarrow \text{appsettings.json} \longrightarrow \text{Sensible Offline Defaults}$$

---

## 2. Backend Environment Variables Reference

| Variable | Default (Dev) | Production Example | Description |
|---|---|---|---|
| `ASPNETCORE_ENVIRONMENT` | `Development` | `Production` | Controls Swagger exposure, exception verbosity, and static file caching. |
| `DATABASE_PROVIDER` | `SqlServer` | `SqlServer` | Database provider (`SqlServer` or `InMemory`). |
| `DATABASE_CONNECTION_STRING` | *(Local instance)* | `Server=superapp-db,1433;Database=SuperAppDB;User Id=sa;Password=...;Encrypt=True` | Full ADO.NET connection string. Overrides `ConnectionStrings:DefaultConnection`. |
| `JWT_SECRET` | *(Dev key)* | `<Random 64+ character cryptographic secret>` | Symmetric key used to sign and verify HMAC-SHA256 bearer tokens. |
| `JWT_ISSUER` | `SuperApp` | `SuperAppProduction` | Issuer claim validation. |
| `JWT_AUDIENCE` | `SuperApp` | `SuperAppAudience` | Audience claim validation. |
| `JWT_EXPIRY_DAYS` | `30` | `30` | Token validity duration in days. |
| `OTP_PROVIDER` | `Mock` | `Karix` / `Twilio` | Active SMS provider. When `Mock`, OTP `123456` is universally valid. |
| `OTP_API_URL` | *N/A* | `https://api.karix.io/send-sms` | Vendor SMS gateway REST endpoint. |
| `OTP_API_KEY` | *N/A* | `<Vendor API key>` | SMS gateway authentication key. |
| `OTP_SENDER_ID` | *N/A* | `SUPAPP` | Registered DLT alphanumeric sender header. |
| `MAP_PROVIDER` | `Mock` | `Google` / `Mapbox` | Geolocation and routing engine. When `Mock`, uses Haversine + city turns. |
| `MAP_API_KEY` | *N/A* | `<Google Maps Server Key>` | Geocoding, reverse geocoding, and Direction matrix API key. |
| `PAYMENT_PROVIDER` | `Mock` | `Razorpay` / `Cashfree` | Active checkout payment gateway. |
| `PAYMENT_KEY` | *N/A* | `rzp_live_...` | Public API key ID. |
| `PAYMENT_SECRET` | *N/A* | `<Razorpay API Secret>` | Gateway secret for server-to-server signature validation. |
| `STORAGE_PROVIDER` | `Local` | `Azure` / `S3` | File asset storage. When `Local`, assets are stored in `wwwroot/uploads/`. |
| `STORAGE_CONNECTION_STRING` | *N/A* | `DefaultEndpointsProtocol=https;AccountName=...` | Azure Blob Storage connection string. |
| `STORAGE_CONTAINER_NAME` | `superapp-assets` | `superapp-prod-assets` | Cloud storage container / bucket name. |
| `NOTIFICATION_PROVIDER` | `Mock` | `Firebase` | Push notification service. |
| `FIREBASE_PROJECT_ID` | *N/A* | `superapp-fcm-prod` | Google Cloud Firebase project identifier. |
| `REDIS_CONNECTION_STRING` | *N/A* | `superapp-redis:6379,password=...` | Distributed caching & SignalR backplane connection string. |

---

## 3. Frontend (Flutter) Configuration

The Flutter customer client dynamically configures its endpoints at build-time or runtime using `--dart-define`.

### Environment Class: `AppEnvironment` ([`app_environment.dart`](file:///D:/HTTPclient1/super_app/lib/core/config/app_environment.dart))

```dart
// Resolves automatically based on build flag:
AppEnvironment.baseUrl;     // e.g., 'http://10.0.2.2:5000/api' or 'https://api.superapp.com/api'
AppEnvironment.rideHubUrl;  // e.g., 'https://api.superapp.com/hubs/ride'
AppEnvironment.isProduction;
```

### Build & Run Commands

```bash
# 1. Local Development (Android Emulator default 10.0.2.2:5000)
flutter run

# 2. Local Development (Physical Device / Custom LAN IP)
flutter run --dart-define=API_BASE_URL=http://192.168.1.100:5000/api

# 3. Staging Build
flutter build apk --dart-define=ENV=staging

# 4. Production Release Build
flutter build appbundle --release --dart-define=ENV=prod --dart-define=API_BASE_URL=https://api.superapp.com/api
```

---

## 4. Secret Management & Git Hygiene

| File | Status | Purpose |
|---|---|---|
| [`.env.example`](file:///D:/HTTPclient1/.env.example) | **Tracked in Git** | Master environment variable template with blank placeholders. |
| `.env` | **Ignored (`.gitignore`)** | Local active environment file. Never committed. |
| [`docs/CREDENTIALS.example.md`](file:///D:/HTTPclient1/docs/CREDENTIALS.example.md) | **Tracked in Git** | Documented human checklist with blank placeholders. |
| `docs/CREDENTIALS.local.md` | **Ignored (`.gitignore`)** | Operator's private local credentials checklist. Never committed. |
| [`SuperApp.API/appsettings.json`](file:///D:/HTTPclient1/SuperApp.API/appsettings.json) | **Tracked in Git** | Base configuration with safe offline `Mock` / `Local` providers. |
| [`SuperApp.API/appsettings.Production.json.example`](file:///D:/HTTPclient1/SuperApp.API/appsettings.Production.json.example) | **Tracked in Git** | Example production template with placeholder keys. |
| `SuperApp.API/appsettings.Production.json` | **Ignored (`.gitignore`)** | Production configuration file deployed directly onto production servers. |
