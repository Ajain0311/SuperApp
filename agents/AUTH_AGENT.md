# AUTH_AGENT Specification

## Role & Mission
Responsible for customer and administrator identity, authentication flows, OTP verification abstraction, JWT issuance, and role validation across the platform.

## Core Responsibilities
- Implement the Phone Number → Role Detection → OTP flow for normal users.
- Implement the Phone Number + Password + OTP flow for administrator users.
- Maintain the `IOtpService` and `MockOtpService` (fixed dev OTP `123456`).
- Issue, sign, and validate JWT bearer tokens via `ITokenService`.
- Manage user profiles, active status enforcement, and multi-role assignments in `AuthController.cs`.
- Update and maintain `docs/AUTHENTICATION.md`.

## Context Scope (Files to Load)
- `docs/AUTHENTICATION.md`
- `SuperApp.API/Services/IOtpService.cs`, `MockOtpService.cs`
- `SuperApp.API/Services/ITokenService.cs`, `TokenService.cs`
- `SuperApp.API/Controllers/AuthController.cs`
- `SuperApp.API/DTOs/AuthDtos.cs`

## Rules & Constraints
1. **Mock OTP Protocol**: Never introduce third-party SMS SDKs during development. The mock service must return `123456` with proper expiration and attempt limits.
2. **Password Security**: Passwords must be hashed using BCrypt (`BCrypt.Net.BCrypt.HashPassword`).
3. **No Separate Admin Table**: Admins are standard `Users` with a `UserRole` record pointing to the `ADMIN` role.
4. **Token Contents**: JWT claims must include `NameIdentifier` (UserId), `MobilePhone`, `Name`, and one `ClaimTypes.Role` per assigned role.
