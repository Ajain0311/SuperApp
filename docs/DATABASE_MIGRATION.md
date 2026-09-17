# SuperApp Database Migration & Portability Guide

This document defines the database architecture, schema migration strategy, and data portability practices for **SuperAppDB** across Development, Staging, and Production environments.

---

## 1. Centralized Schema Architecture

The single source of truth for the SuperApp database is:
📁 [`database/SuperApp_Database.sql`](file:///D:/HTTPclient1/database/SuperApp_Database.sql)

### Guarantees
- **Database Name**: Strictly standardized as `SuperAppDB`.
- **Full Idempotency**: All `CREATE TABLE`, `CREATE INDEX`, and seed operations use `IF NOT EXISTS` guards. The script can be executed repeatedly on existing or fresh databases without data corruption or syntax failures.
- **Ordered Execution Hierarchy**:
  1. `DATABASE INITIALIZATION` (`SuperAppDB`)
  2. `IDENTITY & ACCESS MANAGEMENT` (`Users`, `Roles`, `UserRoles`, `OtpRequests`, `Addresses`)
  3. `FOOD MODULE` (`Restaurants`, `RestaurantUsers`, `RestaurantCategories`, `FoodItems`, `FoodItemAddons`, `FoodItemVariants`, `FoodOrders`, `FoodOrderItems`)
  4. `RIDE MODULE` (`Drivers`, `Vehicles`, `Rides`)
  5. `MARKETPLACE BAZAAR` (`MarketplaceCategories`, `MarketplaceListings`, `ListingImages`, `Favorites`)
  6. `COMMON MARKETING & PLATFORM` (`Coupons`, `CouponUsages`, `Banners`, `Reviews`, `Notifications`, `Payments`, `AppSettings`)
  7. `SYSTEM PERFORMANCE INDEXES`
  8. `IDEMPOTENT SEED DATA` (Default roles, admin accounts, restaurant menu seeds, marketplace categories)

---

## 2. Execution Across Environments

### 2.1 Local Development (Bare-Metal SQL Server)
```bash
# Execute against local SQL Server instance (Windows / SSMS / sqlcmd)
sqlcmd -S localhost -E -i database/SuperApp_Database.sql
```

### 2.2 Containerized Environments (Docker / Kubernetes)
In container environments, the script is mounted directly into the SQL Server initialization volume or executed via the CLI tools:
```bash
# Executing inside the running Docker container
docker exec -i superapp-sql-server /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'SuperApp_Prod_Password_2026!' -C \
  -i /docker-entrypoint-initdb.d/init.sql
```

### 2.3 Staging & Production (Azure SQL / Managed Cloud Instance)
```bash
sqlcmd -S <cloud-server>.database.windows.net,1433 \
  -d master \
  -U <cloud-admin-user> \
  -P '<strong-password>' \
  -C \
  -i database/SuperApp_Database.sql
```

---

## 3. Database Portability & Separation of Concerns

To ensure portability and ease of migration, the codebase enforces strict boundaries:
- **Entity Independence**: EF Core entity models in `SuperApp.API/Models/` contain zero proprietary SQL Server dialect dependencies.
- **Fluent API Isolation**: Schema constraints, foreign keys, cascade deletes, and computed column delegates are encapsulated cleanly in [`AppDbContext.cs`](file:///D:/HTTPclient1/SuperApp.API/Data/AppDbContext.cs).
- **In-Memory Testing**: `Microsoft.EntityFrameworkCore.InMemory` is supported out-of-the-box (`DATABASE_PROVIDER=InMemory`), enabling unit and integration test execution with zero live database dependencies.
- **Standardized Calculations**: Business logic calculations (such as food discounts and ride fare formulas) are computed in domain services or controller layers, preventing stored-procedure vendor lock-in.

---

## 4. Schema Evolution & Migration Workflow

When introducing new database tables or columns:
1. **Model First Update**: Add or update the C# POCO model in `SuperApp.API/Models/`.
2. **DbContext Mapping**: Update `AppDbContext.cs` entity configurations if relationships, unique indexes, or cascade deletes changed.
3. **Script Synchronization**: Immediately update [`database/SuperApp_Database.sql`](file:///D:/HTTPclient1/database/SuperApp_Database.sql) with the corresponding idempotent SQL statement:
   ```sql
   IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND name = N'NewColumn')
   BEGIN
       ALTER TABLE [dbo].[Users] ADD [NewColumn] NVARCHAR(100) NULL;
   END
   GO
   ```
4. **Automated Verification**: Run `dotnet test SuperApp.sln` to confirm model mapping and tests remain 100% green.

---

## 5. Backup, Disaster Recovery & Rollback

### Full Database Backup (SQL Server)
```sql
BACKUP DATABASE [SuperAppDB] 
TO DISK = N'/var/opt/mssql/backup/SuperAppDB_PreMigration.bak' 
WITH FORMAT, MEDIANAME = 'SuperAppBackup', NAME = 'Full Backup of SuperAppDB';
GO
```

### Database Restoration
```sql
USE [master];
ALTER DATABASE [SuperAppDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE [SuperAppDB] 
FROM DISK = N'/var/opt/mssql/backup/SuperAppDB_PreMigration.bak' 
WITH REPLACE;
ALTER DATABASE [SuperAppDB] SET MULTI_USER;
GO
```
