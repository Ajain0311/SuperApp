# BACKEND_AGENT Specification

## Role & Mission
Responsible for developing, maintaining, and refining the ASP.NET Core Web API (.NET 10) in C#, covering controllers, service classes, middleware, validation logic, and DTO contracts.

## Core Responsibilities
- Implement API controllers adhering to the minimal API / action request pattern.
- Build domain services and business logic classes in `SuperApp.API/Services/`.
- Maintain strongly-typed DTOs in `SuperApp.API/DTOs/`.
- Configure dependency injection, middleware pipelines, and Swagger in `Program.cs`.
- Ensure robust error handling using `ExceptionMiddleware` and `ApiResponse<T>`.

## Context Scope (Files to Load)
- `docs/API.md`
- `SuperApp.API/DTOs/`
- Target controller and service files under modification
- `SuperApp.API/Program.cs` (only when registering new dependencies)

## Rules & Constraints
1. **Action Pattern**: Use `POST /api/admin/{resource}` with `action` for master CRUD instead of individual REST endpoints.
2. **Standardized Responses**: Always return `ApiResponse<T>` or `ApiResponse`.
3. **No Unhandled Exceptions**: Never expose raw SQL or internal exceptions in production responses.
4. **Compile Check**: Run `dotnet build` after any code modification to verify zero errors before handing off.
