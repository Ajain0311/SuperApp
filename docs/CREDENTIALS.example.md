# SuperApp Credentials

## 1. SMS / OTP Provider

Provider Name: 
API Base URL: 
API Key: 
API Secret / Auth Token: 
Sender ID: 
DLT Entity ID: 
DLT Template ID: 
OTP Template: 
Additional Headers: 
Webhook URL (if required): 

Status: [ ] Configured

---

## 2. Maps / Location

Provider: 
Google Maps / Mapbox: 

API Key: 
Android API Key: 
iOS API Key: 
Web API Key: 

Required APIs:
- Maps
- Geocoding
- Reverse Geocoding
- Routes / Directions
- Places / Autocomplete

Status: [ ] Configured

---

## 3. Payment Gateway

Provider: 
Razorpay / Cashfree / Other: 

Key ID / Client ID: 
Key Secret / Client Secret: 
Webhook Secret: 
Merchant ID: 
Environment: 

Status: [ ] Configured

---

## 4. Firebase / Push Notifications

Firebase Project ID: 
Android Configuration: 
iOS Configuration: 
Service Account / Server Credential: 
FCM Configuration: 
APNs Configuration: 

Status: [ ] Configured

---

## 5. Azure Blob Storage

Storage Account Name: 
Account Key: 
Connection String: 
Container Name: 
Blob Endpoint: 
SAS / Presigned URL Configuration: 

Status: [ ] Configured

---

## 6. SQL Server

Server: 
Port: 
Database: 
Username: 
Password: 
Connection String: 

Database Name should be:

SuperAppDB

Status: [ ] Configured

---

## 7. JWT / Authentication

JWT Secret: 
Issuer: 
Audience: 
Access Token Expiry: 
Refresh Token Secret (if required): 

IMPORTANT:
Generate/use a NEW SuperApp secret.
Do NOT reuse secrets from any previous project.

Status: [ ] Configured

---

## 8. Email — OPTIONAL

Provider: 
SMTP Host: 
SMTP Port: 
Username: 
Password/API Key: 
From Email: 
From Name: 

Status: [ ] Configured

---

## 9. WhatsApp — OPTIONAL

Provider: 
Meta / Gupshup / Other: 

API Base URL: 
Access Token / API Key: 
Phone Number ID: 
Business Account ID: 
Webhook Verify Token: 
Template IDs: 
Language: 

Status: [ ] Configured

---

## 10. Redis — OPTIONAL / LATER

Host: 
Port: 
Username: 
Password: 
Connection String: 

Status: [ ] Configured

---

## 11. RabbitMQ — OPTIONAL / LATER

Host: 
Port: 
Username: 
Password: 
Virtual Host: 
Exchange: 
Queue: 
Routing Key: 

Status: [ ] Configured

---

## 12. Production Domains — LATER

Backend API: 
Admin Panel: 
Restaurant Panel: 
Customer App API: 
Payment Webhook: 
Other: 

Status: [ ] Configured

---

## 13. Android Release — LATER

Package Name: 
Keystore Path: 
Key Alias: 
Keystore Password: 
Key Password: 

Status: [ ] Configured

---

## 14. iOS Release — LATER

Bundle ID: 
Apple Developer Team ID: 
APNs Configuration: 
Signing Certificate: 
Provisioning Profile: 

Status: [ ] Configured

---

# PRIORITY

## REQUIRED NOW

[ ] SMS / OTP
[ ] Maps
[ ] SQL Server
[ ] JWT
[ ] Azure Storage

## REQUIRED BEFORE REAL PAYMENTS

[ ] Payment Gateway
[ ] Payment Webhook

## REQUIRED BEFORE PRODUCTION RELEASE

[ ] Firebase Push Notifications
[ ] Production Domains
[ ] Android Signing
[ ] iOS Signing

## OPTIONAL / LATER

[ ] WhatsApp
[ ] Email
[ ] Redis
[ ] RabbitMQ

---

# IMPORTANT SECURITY RULES

NEVER commit this file if it contains real credentials.

Add:

/docs/CREDENTIALS.local.md

to .gitignore.

Also create:

/docs/CREDENTIALS.example.md

This second file must contain the same structure but ONLY blank placeholders and MUST be safe to commit.

The application must read actual credentials from environment variables or secure/local configuration, NOT directly from Git-tracked documentation.

Do not hardcode credentials into source code.
