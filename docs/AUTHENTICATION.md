# Authentication Flow

This document details the authentication mechanism used across the Super App.

## Overview
Authentication relies on a unified user base. Users are identified by their Phone Number. Authorization is handled via a Roles system (e.g., `Customer`, `Driver`, `RestaurantOwner`, `Admin`).

## Flow Descriptions

### 1. Normal User Authentication (OTP Only)
Normal users (Customers, Drivers, Restaurant Owners) log in using a passwordless OTP flow.

1. **Request OTP:**
   - Client sends Phone Number to `POST /api/auth/send-otp`.
   - Backend checks if the user exists. If not, a new user may be provisionally created or prompted for registration (depending on business rules).
   - Backend generates an OTP using `IOtpService` and sends it (mocked in dev).
2. **Verify OTP:**
   - Client sends Phone Number + OTP to `POST /api/auth/verify-otp`.
   - Backend verifies the OTP.
   - Upon success, backend generates a JWT token containing the `UserId` and `Roles` claims.
   - Client stores the JWT for subsequent API requests.

### 2. Administrator Authentication (Password + OTP)
Admins require higher security and must provide a password in addition to the OTP.

1. **Admin Login Initiation:**
   - Admin client sends Phone Number + Password to `POST /api/auth/admin-login`.
   - Backend verifies the Phone Number and Password.
   - Backend checks if the user possesses the `Admin` role.
   - If successful, backend generates and sends an OTP via `IOtpService`.
2. **Verify Admin OTP:**
   - Admin client calls `POST /api/auth/verify-otp` with the Phone Number and OTP.
   - Backend issues the JWT with Admin claims.

## Development Mode
In development environments, the OTP service is mocked.
- **Mock OTP:** `123456` will always be the generated/accepted OTP.
- `IOtpService` will have a `MockOtpService` implementation injected via Dependency Injection in `Development` environments.

## API Endpoints

- `POST /api/auth/send-otp`
  - **Request Body:** `{ "phoneNumber": "string" }`
  - **Response:** `200 OK`
- `POST /api/auth/verify-otp`
  - **Request Body:** `{ "phoneNumber": "string", "otp": "string" }`
  - **Response:** `200 OK`, Body: `{ "token": "jwt_string", "user": { ... } }`
- `POST /api/auth/admin-login`
  - **Request Body:** `{ "phoneNumber": "string", "password": "string" }`
  - **Response:** `200 OK` (OTP sent)

## Authentication Flow Diagram
```text
[Client]                            [API: Auth Controller]                    [OTP Service]
   |                                          |                                     |
   |---- 1. POST /send-otp (PhoneNumber) ---->|                                     |
   |                                          |---- 2. Generate/Send OTP ---------->|
   |<--- 3. 200 OK (OTP Sent) ----------------|                                     |
   |                                          |                                     |
   |---- 4. POST /verify-otp (Phone, OTP) --->|                                     |
   |                                          |---- 5. Verify OTP ----------------->|
   |                                          |<--- 6. OTP Valid -------------------|
   |                                          |                                     |
   |                                          |---- 7. Generate JWT                 |
   |<--- 8. 200 OK (JWT Token) ---------------|                                     |
```
