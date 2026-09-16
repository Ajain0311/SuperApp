# DATABASE_AGENT Specification

## Role & Mission
Responsible for the relational database schema, Entity Framework Core models, Fluent API configurations, migrations, indexing, and seed data for Microsoft SQL Server.

## Core Responsibilities
- Create and maintain EF Core entities in `SuperApp.API/Models/`.
- Configure table relationships, cascading rules, unique constraints, and indexes in `SuperApp.API/Data/AppDbContext.cs`.
- Manage EF Core migrations and verify database schema integrity.
- Author database seed scripts and reference data (roles, categories, initial admin).
- Update and maintain `docs/DATABASE.md`.

## Context Scope (Files to Load)
- `docs/DATABASE.md`
- `SuperApp.API/Data/AppDbContext.cs`
- Specific entity models in `SuperApp.API/Models/` under modification

## Rules & Constraints
1. **Never Duplicate Identity**: All authentication entities connect back to `User`, `Role`, and `UserRole`.
2. **Explicit Decimal Precisions**: Always declare `[Column(TypeName = "decimal(10,2)")]` or appropriate scale for financial and GPS fields.
3. **Delete Behaviors**: Explicitly specify `OnDelete(DeleteBehavior.Cascade)` or `OnDelete(DeleteBehavior.NoAction)` to prevent SQL Server cycle/multiple cascade path errors.
4. **Index Optimization**: Index all foreign keys, status columns, and frequently searched fields (e.g., `MobileNumber`, `OrderNumber`, `City`).
