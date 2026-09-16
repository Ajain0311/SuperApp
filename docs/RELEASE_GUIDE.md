# SuperApp Production Release & Deployment Guide

This document provides end-to-end instructions for building, containerizing, releasing, and deploying the unified **Super App** platform across all components:
- **Backend API & Web Panels:** ASP.NET Core 10, SignalR hubs, Admin Command Portal, and Restaurant Vendor Portal
- **Database:** Microsoft SQL Server 2022
- **Mobile Client:** Flutter cross-platform app (Android APK / AAB, iOS IPA)

---

## 1. System Requirements & Prerequisites

| Component | Minimum Version | Production Recommendation |
|---|---|---|
| **.NET SDK** | 10.0+ | .NET 10 LTS Container Image |
| **Flutter SDK** | 3.29+ / Dart 3.8+ | Stable Channel |
| **SQL Server** | 2022 Express / Developer | Enterprise / Azure SQL Database |
| **Docker & Compose** | Docker 24+, Compose v2 | Docker Engine / Kubernetes (EKS, GKE, AKS) |
| **Java JDK** | OpenJDK 17 | Eclipse Temurin 17 |
| **Node / Web Host** | N/A (Static files served by Kestrel) | Nginx / Caddy reverse proxy |

---

## 2. Database Provisioning & Execution

The SuperApp database structure is maintained as a single idempotent script located at [`database/SuperApp_Database.sql`](file:///D:/HTTPclient1/database/SuperApp_Database.sql).

### Execution via `sqlcmd`
```bash
# Connect to your production SQL Server instance
sqlcmd -S <server-host>,1433 -U sa -P '<strong-password>' -C -i database/SuperApp_Database.sql
```

### Key Database Guarantees
- **Unified Identity**: Contains `Users`, `Roles`, and `UserRoles` (no separate admin table).
- **Seed Roles**: Automatically seeds `CUSTOMER`, `ADMIN`, `RESTAURANT_OWNER`, `DRIVER`, and `MARKETPLACE_SELLER`.
- **System Indexes**: Pre-indexed by mobile numbers, order numbers, ride numbers, status, and geospatial coordinates (`Latitude`, `Longitude`).
- **Discount Precedence**: Enforces item-level discount first, followed by coupon discount calculation.

---

## 3. Backend Deployment (Docker Compose)

For instant, reproducible deployment of both the API and database, use the root orchestration file [`docker-compose.yml`](file:///D:/HTTPclient1/docker-compose.yml).

### Starting Services
```bash
# 1. Clone repository
git clone https://github.com/Ajain0311/SuperApp.git
cd SuperApp

# 2. Start database and API
docker compose up -d --build

# 3. Verify container health
docker compose ps
```

### Accessing Endpoints
- **Customer API & Swagger**: `http://localhost:5000/swagger`
- **Admin Command Portal**: `http://localhost:5000/admin/index.html`
- **Restaurant Vendor Portal**: `http://localhost:5000/vendor/index.html`
- **SignalR Hubs**:
  - Ride Tracking: `http://localhost:5000/hubs/ride-tracking`
  - Food Order Status: `http://localhost:5000/hubs/order-status`
  - Marketplace Chat: `http://localhost:5000/hubs/chat`

---

## 4. Standalone Backend Build (Kestrel / IIS / Linux Service)

To deploy directly to a Linux or Windows VM without Docker:

```bash
# 1. Restore & publish Release binaries
dotnet publish SuperApp.sln -c Release -o /var/www/superapp-api /p:UseAppHost=false

# 2. Configure production settings
export ASPNETCORE_ENVIRONMENT=Production
export ConnectionStrings__DefaultConnection="Server=<sql-host>;Database=SuperAppDb;User Id=sa;Password=<password>;TrustServerCertificate=true;Encrypt=True"
export Jwt__Secret="<secure-64-character-production-key>"

# 3. Launch application
dotnet /var/www/superapp-api/SuperApp.API.dll
```

### Systemd Service Template (`/etc/systemd/system/superapp.service`)
```ini
[Unit]
Description=SuperApp ASP.NET Core API Service
After=network.target

[Service]
WorkingDirectory=/var/www/superapp-api
ExecStart=/usr/bin/dotnet /var/www/superapp-api/SuperApp.API.dll
Restart=always
RestartSec=10
KillSignal=SIGINT
SyslogIdentifier=superapp-api
User=www-data
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false

[Install]
WantedBy=multi-user.target
```

---

## 5. Mobile Application Compilation (Flutter)

Navigate to the `super_app` directory:
```bash
cd super_app
flutter pub get
```

### Static Analysis & Testing
Before building release artifacts, ensure all quality gates pass:
```bash
# Run static analysis (must report 0 issues)
flutter analyze

# Run unit and widget test suite (must report 100% pass)
flutter test
```

### Android Release Packaging

#### 1. Standalone APK (for testing & direct distribution)
```bash
flutter build apk --release --split-per-abi
```
Output location:
`build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`

#### 2. Android App Bundle (for Google Play Store submission)
```bash
flutter build appbundle --release
```
Output location:
`build/app/outputs/bundle/release/app-release.aab`

#### Android Signing Setup (`android/key.properties`)
Create `super_app/android/key.properties` (never commit this file to Git):
```properties
storePassword=YourKeystorePassword
keyPassword=YourKeyPassword
keyAlias=superapp-key
storeFile=/path/to/upload-keystore.jks
```

### iOS Release Packaging (macOS Host)
```bash
flutter build ipa --release --export-options-plist=ExportOptions.plist
```
Output location:
`build/ios/archive/Runner.xcarchive`

---

## 6. Reverse Proxy & SSL Configuration (Nginx)

```nginx
server {
    listen 80;
    server_name api.superapp.com admin.superapp.com vendor.superapp.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.superapp.com;

    ssl_certificate /etc/letsencrypt/live/api.superapp.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.superapp.com/privkey.pem;

    # API and static panels
    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # SignalR real-time WebSocket connection handling
    location /hubs/ {
        proxy_pass http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
    }
}
```

---

## 7. Security Hardening Checklist

- [x] **Non-Root Execution**: Container runs under standard unprivileged `$APP_UID`.
- [x] **Secure Token Lifecycle**: JWT tokens signed using HMAC-SHA256 with minimum 256-bit entropy.
- [x] **CORS Constraints**: Restrict allowed cross-origin domains to trusted vendor and admin portal hosts.
- [x] **Database Isolation**: Never expose SQL Server port 1433 to public networks without VPN / IP whitelisting.
- [x] **Android Permissions**: Minimal necessary runtime permissions declared in `AndroidManifest.xml`.
- [x] **Input Sanitization**: Action-based parameter pattern validates all entity modifications against tenant ownership.
