-- ==============================================================================
-- SuperApp Centralized Database Script
-- Platform: Microsoft SQL Server 2019 / 2022 / Azure SQL
-- Description: Complete idempotent schema for SuperApp (Food, Ride, Marketplace, Admin)
-- Execution: Safe to execute manually from top to bottom
-- ==============================================================================

USE [master];
GO

-- ------------------------------------------------------------------------------
-- 01. DATABASE INITIALIZATION
-- ------------------------------------------------------------------------------
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'SuperAppDb')
BEGIN
    CREATE DATABASE [SuperAppDb];
    PRINT 'Database SuperAppDb created successfully.';
END
ELSE
BEGIN
    PRINT 'Database SuperAppDb already exists.';
END
GO

USE [SuperAppDb];
GO

-- ------------------------------------------------------------------------------
-- 02. ROLES TABLE & CONSTANTS
-- ------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Roles]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Roles] (
        [Id] INT IDENTITY(1,1) NOT NULL,
        [Name] NVARCHAR(50) NOT NULL,
        [Description] NVARCHAR(255) NULL,
        [IsActive] BIT NOT NULL CONSTRAINT [DF_Roles_IsActive] DEFAULT (1),
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_Roles_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        [UpdatedAt] DATETIME2(7) NULL,
        CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED ([Id] ASC)
    );
    CREATE UNIQUE NONCLUSTERED INDEX [IX_Roles_Name] ON [dbo].[Roles] ([Name] ASC);
    PRINT 'Created table [Roles].';
END
GO

-- ------------------------------------------------------------------------------
-- 03. USERS TABLE (CENTRAL IDENTITY)
-- ------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Users] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [MobileNumber] NVARCHAR(15) NOT NULL,
        [FullName] NVARCHAR(100) NULL,
        [Email] NVARCHAR(255) NULL,
        [ProfileImageUrl] NVARCHAR(500) NULL,
        [PasswordHash] NVARCHAR(255) NULL, -- Nullable for OTP-only users
        [IsActive] BIT NOT NULL CONSTRAINT [DF_Users_IsActive] DEFAULT (1),
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_Users_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        [UpdatedAt] DATETIME2(7) NULL,
        [LastLoginAt] DATETIME2(7) NULL,
        CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC)
    );
    CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_MobileNumber] ON [dbo].[Users] ([MobileNumber] ASC);
    CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_Email] ON [dbo].[Users] ([Email] ASC) WHERE [Email] IS NOT NULL;
    PRINT 'Created table [Users].';
END
GO

-- ------------------------------------------------------------------------------
-- 04. USER ROLES (MANY-TO-MANY IDENTITY MAPPING)
-- ------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserRoles]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[UserRoles] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [UserId] BIGINT NOT NULL,
        [RoleId] INT NOT NULL,
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_UserRoles_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_UserRoles_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_UserRoles_Roles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles] ([Id]) ON DELETE CASCADE
    );
    CREATE UNIQUE NONCLUSTERED INDEX [IX_UserRoles_UserId_RoleId] ON [dbo].[UserRoles] ([UserId] ASC, [RoleId] ASC);
    PRINT 'Created table [UserRoles].';
END
GO

-- ------------------------------------------------------------------------------
-- 05. OTP REQUESTS (AUTH VERIFICATION & RETRY TRACKING)
-- ------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OtpRequests]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[OtpRequests] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [MobileNumber] NVARCHAR(15) NOT NULL,
        [OtpCode] NVARCHAR(10) NOT NULL,
        [Purpose] NVARCHAR(50) NOT NULL CONSTRAINT [DF_OtpRequests_Purpose] DEFAULT (N'LOGIN'),
        [IsUsed] BIT NOT NULL CONSTRAINT [DF_OtpRequests_IsUsed] DEFAULT (0),
        [AttemptCount] INT NOT NULL CONSTRAINT [DF_OtpRequests_AttemptCount] DEFAULT (0),
        [ExpiresAt] DATETIME2(7) NOT NULL,
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_OtpRequests_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT [PK_OtpRequests] PRIMARY KEY CLUSTERED ([Id] ASC)
    );
    CREATE NONCLUSTERED INDEX [IX_OtpRequests_MobileNumber_ExpiresAt] ON [dbo].[OtpRequests] ([MobileNumber] ASC, [ExpiresAt] ASC);
    PRINT 'Created table [OtpRequests].';
END
GO

-- ------------------------------------------------------------------------------
-- 06. USER ADDRESSES
-- ------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Addresses]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Addresses] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [UserId] BIGINT NOT NULL,
        [Label] NVARCHAR(50) NULL, -- 'Home', 'Work', 'Other'
        [AddressLine1] NVARCHAR(255) NOT NULL,
        [AddressLine2] NVARCHAR(255) NULL,
        [City] NVARCHAR(100) NOT NULL,
        [State] NVARCHAR(100) NOT NULL,
        [PinCode] NVARCHAR(10) NOT NULL,
        [Latitude] DECIMAL(10, 7) NULL,
        [Longitude] DECIMAL(10, 7) NULL,
        [IsDefault] BIT NOT NULL CONSTRAINT [DF_Addresses_IsDefault] DEFAULT (0),
        [IsActive] BIT NOT NULL CONSTRAINT [DF_Addresses_IsActive] DEFAULT (1),
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_Addresses_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        [UpdatedAt] DATETIME2(7) NULL,
        CONSTRAINT [PK_Addresses] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_Addresses_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE
    );
    CREATE NONCLUSTERED INDEX [IX_Addresses_UserId] ON [dbo].[Addresses] ([UserId] ASC);
    PRINT 'Created table [Addresses].';
END
GO

-- ------------------------------------------------------------------------------
-- 07. RESTAURANTS & RESTAURANT USERS (OWNERSHIP RELATION)
-- ------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Restaurants]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Restaurants] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [Name] NVARCHAR(200) NOT NULL,
        [Description] NVARCHAR(1000) NULL,
        [ImageUrl] NVARCHAR(500) NULL,
        [Phone] NVARCHAR(15) NULL,
        [Email] NVARCHAR(255) NULL,
        [AddressLine] NVARCHAR(500) NULL,
        [City] NVARCHAR(100) NULL,
        [Latitude] DECIMAL(10, 7) NULL,
        [Longitude] DECIMAL(10, 7) NULL,
        [Rating] DECIMAL(3, 2) NOT NULL CONSTRAINT [DF_Restaurants_Rating] DEFAULT (0.00),
        [TotalRatings] INT NOT NULL CONSTRAINT [DF_Restaurants_TotalRatings] DEFAULT (0),
        [IsVeg] BIT NOT NULL CONSTRAINT [DF_Restaurants_IsVeg] DEFAULT (0),
        [OpeningTime] TIME(7) NULL,
        [ClosingTime] TIME(7) NULL,
        [MinOrderAmount] DECIMAL(10, 2) NOT NULL CONSTRAINT [DF_Restaurants_MinOrder] DEFAULT (0.00),
        [DeliveryFee] DECIMAL(10, 2) NOT NULL CONSTRAINT [DF_Restaurants_DeliveryFee] DEFAULT (0.00),
        [AvgDeliveryTimeMinutes] INT NOT NULL CONSTRAINT [DF_Restaurants_AvgDeliveryTime] DEFAULT (30),
        [IsActive] BIT NOT NULL CONSTRAINT [DF_Restaurants_IsActive] DEFAULT (1),
        [IsFeatured] BIT NOT NULL CONSTRAINT [DF_Restaurants_IsFeatured] DEFAULT (0),
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_Restaurants_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        [UpdatedAt] DATETIME2(7) NULL,
        CONSTRAINT [PK_Restaurants] PRIMARY KEY CLUSTERED ([Id] ASC)
    );
    CREATE NONCLUSTERED INDEX [IX_Restaurants_City_IsActive] ON [dbo].[Restaurants] ([City] ASC, [IsActive] ASC);
    CREATE NONCLUSTERED INDEX [IX_Restaurants_IsFeatured] ON [dbo].[Restaurants] ([IsFeatured] ASC);
    PRINT 'Created table [Restaurants].';
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RestaurantUsers]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[RestaurantUsers] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [RestaurantId] BIGINT NOT NULL,
        [UserId] BIGINT NOT NULL,
        [IsActive] BIT NOT NULL CONSTRAINT [DF_RestaurantUsers_IsActive] DEFAULT (1),
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_RestaurantUsers_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT [PK_RestaurantUsers] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_RestaurantUsers_Restaurants_RestaurantId] FOREIGN KEY ([RestaurantId]) REFERENCES [dbo].[Restaurants] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_RestaurantUsers_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE
    );
    CREATE UNIQUE NONCLUSTERED INDEX [IX_RestaurantUsers_RestaurantId_UserId] ON [dbo].[RestaurantUsers] ([RestaurantId] ASC, [UserId] ASC);
    PRINT 'Created table [RestaurantUsers].';
END
GO

-- ------------------------------------------------------------------------------
-- 08. FOOD MENU: CATEGORIES, ITEMS, ADD-ONS, VARIANTS
-- ------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RestaurantCategories]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[RestaurantCategories] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [RestaurantId] BIGINT NOT NULL,
        [Name] NVARCHAR(100) NOT NULL,
        [Description] NVARCHAR(255) NULL,
        [SortOrder] INT NOT NULL CONSTRAINT [DF_RestaurantCategories_SortOrder] DEFAULT (0),
        [IsActive] BIT NOT NULL CONSTRAINT [DF_RestaurantCategories_IsActive] DEFAULT (1),
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_RestaurantCategories_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        [UpdatedAt] DATETIME2(7) NULL,
        CONSTRAINT [PK_RestaurantCategories] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_RestaurantCategories_Restaurants_RestaurantId] FOREIGN KEY ([RestaurantId]) REFERENCES [dbo].[Restaurants] ([Id]) ON DELETE CASCADE
    );
    CREATE NONCLUSTERED INDEX [IX_RestaurantCategories_RestaurantId] ON [dbo].[RestaurantCategories] ([RestaurantId] ASC);
    PRINT 'Created table [RestaurantCategories].';
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FoodItems]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[FoodItems] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [RestaurantId] BIGINT NOT NULL,
        [RestaurantCategoryId] BIGINT NOT NULL,
        [Name] NVARCHAR(200) NOT NULL,
        [Description] NVARCHAR(1000) NULL,
        [ImageUrl] NVARCHAR(500) NULL,
        [BasePrice] DECIMAL(10, 2) NOT NULL,
        [DiscountPercent] DECIMAL(5, 2) NOT NULL CONSTRAINT [DF_FoodItems_DiscountPercent] DEFAULT (0.00),
        [IsVeg] BIT NOT NULL CONSTRAINT [DF_FoodItems_IsVeg] DEFAULT (1),
        [IsAvailable] BIT NOT NULL CONSTRAINT [DF_FoodItems_IsAvailable] DEFAULT (1),
        [IsBestseller] BIT NOT NULL CONSTRAINT [DF_FoodItems_IsBestseller] DEFAULT (0),
        [IsCustomizable] BIT NOT NULL CONSTRAINT [DF_FoodItems_IsCustomizable] DEFAULT (0),
        [SortOrder] INT NOT NULL CONSTRAINT [DF_FoodItems_SortOrder] DEFAULT (0),
        [IsActive] BIT NOT NULL CONSTRAINT [DF_FoodItems_IsActive] DEFAULT (1),
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_FoodItems_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        [UpdatedAt] DATETIME2(7) NULL,
        CONSTRAINT [PK_FoodItems] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_FoodItems_Restaurants_RestaurantId] FOREIGN KEY ([RestaurantId]) REFERENCES [dbo].[Restaurants] ([Id]),
        CONSTRAINT [FK_FoodItems_RestaurantCategories_CategoryId] FOREIGN KEY ([RestaurantCategoryId]) REFERENCES [dbo].[RestaurantCategories] ([Id]) ON DELETE CASCADE
    );
    CREATE NONCLUSTERED INDEX [IX_FoodItems_RestaurantId_IsAvailable] ON [dbo].[FoodItems] ([RestaurantId] ASC, [IsAvailable] ASC);
    CREATE NONCLUSTERED INDEX [IX_FoodItems_RestaurantCategoryId] ON [dbo].[FoodItems] ([RestaurantCategoryId] ASC);
    PRINT 'Created table [FoodItems].';
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FoodItemAddons]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[FoodItemAddons] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [FoodItemId] BIGINT NOT NULL,
        [GroupName] NVARCHAR(100) NOT NULL, -- e.g. 'Add-ons', 'Beverages'
        [Name] NVARCHAR(200) NOT NULL,
        [Price] DECIMAL(10, 2) NOT NULL,
        [IsDefault] BIT NOT NULL CONSTRAINT [DF_FoodItemAddons_IsDefault] DEFAULT (0),
        [IsActive] BIT NOT NULL CONSTRAINT [DF_FoodItemAddons_IsActive] DEFAULT (1),
        [SortOrder] INT NOT NULL CONSTRAINT [DF_FoodItemAddons_SortOrder] DEFAULT (0),
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_FoodItemAddons_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT [PK_FoodItemAddons] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_FoodItemAddons_FoodItems_FoodItemId] FOREIGN KEY ([FoodItemId]) REFERENCES [dbo].[FoodItems] ([Id]) ON DELETE CASCADE
    );
    CREATE NONCLUSTERED INDEX [IX_FoodItemAddons_FoodItemId] ON [dbo].[FoodItemAddons] ([FoodItemId] ASC);
    PRINT 'Created table [FoodItemAddons].';
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FoodItemVariants]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[FoodItemVariants] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [FoodItemId] BIGINT NOT NULL,
        [Name] NVARCHAR(200) NOT NULL, -- e.g. 'Regular Portion', 'Jumbo Pack (Serves 3)'
        [AdditionalPrice] DECIMAL(10, 2) NOT NULL CONSTRAINT [DF_FoodItemVariants_Price] DEFAULT (0.00),
        [IsDefault] BIT NOT NULL CONSTRAINT [DF_FoodItemVariants_IsDefault] DEFAULT (0),
        [IsActive] BIT NOT NULL CONSTRAINT [DF_FoodItemVariants_IsActive] DEFAULT (1),
        [SortOrder] INT NOT NULL CONSTRAINT [DF_FoodItemVariants_SortOrder] DEFAULT (0),
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_FoodItemVariants_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT [PK_FoodItemVariants] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_FoodItemVariants_FoodItems_FoodItemId] FOREIGN KEY ([FoodItemId]) REFERENCES [dbo].[FoodItems] ([Id]) ON DELETE CASCADE
    );
    CREATE NONCLUSTERED INDEX [IX_FoodItemVariants_FoodItemId] ON [dbo].[FoodItemVariants] ([FoodItemId] ASC);
    PRINT 'Created table [FoodItemVariants].';
END
GO

-- ------------------------------------------------------------------------------
-- 09. COUPONS & USAGE
-- ------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Coupons]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Coupons] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [Code] NVARCHAR(20) NOT NULL,
        [Description] NVARCHAR(255) NULL,
        [DiscountType] NVARCHAR(20) NOT NULL CONSTRAINT [DF_Coupons_DiscountType] DEFAULT (N'PERCENTAGE'), -- 'PERCENTAGE', 'FLAT'
        [DiscountValue] DECIMAL(10, 2) NOT NULL,
        [MinOrderAmount] DECIMAL(10, 2) NOT NULL CONSTRAINT [DF_Coupons_MinOrder] DEFAULT (0.00),
        [MaxDiscount] DECIMAL(10, 2) NULL,
        [StartDate] DATETIME2(7) NOT NULL,
        [ExpiryDate] DATETIME2(7) NOT NULL,
        [TotalUsageLimit] INT NULL,
        [PerUserLimit] INT NOT NULL CONSTRAINT [DF_Coupons_PerUserLimit] DEFAULT (1),
        [CurrentUsageCount] INT NOT NULL CONSTRAINT [DF_Coupons_UsageCount] DEFAULT (0),
        [ApplicableModule] NVARCHAR(20) NOT NULL CONSTRAINT [DF_Coupons_Module] DEFAULT (N'FOOD'), -- 'FOOD', 'RIDE', 'ALL'
        [IsActive] BIT NOT NULL CONSTRAINT [DF_Coupons_IsActive] DEFAULT (1),
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_Coupons_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        [UpdatedAt] DATETIME2(7) NULL,
        CONSTRAINT [PK_Coupons] PRIMARY KEY CLUSTERED ([Id] ASC)
    );
    CREATE UNIQUE NONCLUSTERED INDEX [IX_Coupons_Code] ON [dbo].[Coupons] ([Code] ASC);
    PRINT 'Created table [Coupons].';
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CouponUsages]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[CouponUsages] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [CouponId] BIGINT NOT NULL,
        [UserId] BIGINT NOT NULL,
        [OrderId] BIGINT NULL,
        [UsedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_CouponUsages_UsedAt] DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT [PK_CouponUsages] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_CouponUsages_Coupons_CouponId] FOREIGN KEY ([CouponId]) REFERENCES [dbo].[Coupons] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_CouponUsages_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id])
    );
    CREATE NONCLUSTERED INDEX [IX_CouponUsages_CouponId_UserId] ON [dbo].[CouponUsages] ([CouponId] ASC, [UserId] ASC);
    PRINT 'Created table [CouponUsages].';
END
GO

-- ------------------------------------------------------------------------------
-- 10. FOOD ORDERS & ITEMS
-- ------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FoodOrders]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[FoodOrders] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [OrderNumber] NVARCHAR(20) NOT NULL,
        [UserId] BIGINT NOT NULL,
        [RestaurantId] BIGINT NOT NULL,
        [AddressId] BIGINT NULL,
        [Status] NVARCHAR(20) NOT NULL CONSTRAINT [DF_FoodOrders_Status] DEFAULT (N'PENDING'),
        [SubTotal] DECIMAL(10, 2) NOT NULL,
        [DiscountAmount] DECIMAL(10, 2) NOT NULL CONSTRAINT [DF_FoodOrders_Discount] DEFAULT (0.00),
        [CouponId] BIGINT NULL,
        [CouponDiscount] DECIMAL(10, 2) NOT NULL CONSTRAINT [DF_FoodOrders_CouponDiscount] DEFAULT (0.00),
        [DeliveryFee] DECIMAL(10, 2) NOT NULL CONSTRAINT [DF_FoodOrders_DeliveryFee] DEFAULT (0.00),
        [TaxAmount] DECIMAL(10, 2) NOT NULL CONSTRAINT [DF_FoodOrders_TaxAmount] DEFAULT (0.00),
        [GrandTotal] DECIMAL(10, 2) NOT NULL,
        [PaymentMethod] NVARCHAR(20) NULL, -- 'COD', 'UPI', 'CARD'
        [PaymentStatus] NVARCHAR(20) NOT NULL CONSTRAINT [DF_FoodOrders_PaymentStatus] DEFAULT (N'PENDING'),
        [Notes] NVARCHAR(500) NULL,
        [EstimatedDeliveryMinutes] INT NULL,
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_FoodOrders_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        [UpdatedAt] DATETIME2(7) NULL,
        CONSTRAINT [PK_FoodOrders] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_FoodOrders_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]),
        CONSTRAINT [FK_FoodOrders_Restaurants_RestaurantId] FOREIGN KEY ([RestaurantId]) REFERENCES [dbo].[Restaurants] ([Id]),
        CONSTRAINT [FK_FoodOrders_Addresses_AddressId] FOREIGN KEY ([AddressId]) REFERENCES [dbo].[Addresses] ([Id]) ON DELETE SET NULL,
        CONSTRAINT [FK_FoodOrders_Coupons_CouponId] FOREIGN KEY ([CouponId]) REFERENCES [dbo].[Coupons] ([Id]) ON DELETE SET NULL
    );
    CREATE UNIQUE NONCLUSTERED INDEX [IX_FoodOrders_OrderNumber] ON [dbo].[FoodOrders] ([OrderNumber] ASC);
    CREATE NONCLUSTERED INDEX [IX_FoodOrders_UserId_CreatedAt] ON [dbo].[FoodOrders] ([UserId] ASC, [CreatedAt] DESC);
    CREATE NONCLUSTERED INDEX [IX_FoodOrders_RestaurantId_Status] ON [dbo].[FoodOrders] ([RestaurantId] ASC, [Status] ASC);
    PRINT 'Created table [FoodOrders].';
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FoodOrderItems]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[FoodOrderItems] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [FoodOrderId] BIGINT NOT NULL,
        [FoodItemId] BIGINT NOT NULL,
        [ItemName] NVARCHAR(200) NOT NULL,
        [Quantity] INT NOT NULL CONSTRAINT [DF_FoodOrderItems_Quantity] DEFAULT (1),
        [UnitPrice] DECIMAL(10, 2) NOT NULL,
        [VariantName] NVARCHAR(200) NULL,
        [VariantPrice] DECIMAL(10, 2) NOT NULL CONSTRAINT [DF_FoodOrderItems_VariantPrice] DEFAULT (0.00),
        [AddonsJson] NVARCHAR(2000) NULL, -- Serialized selected add-ons list
        [TotalPrice] DECIMAL(10, 2) NOT NULL,
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_FoodOrderItems_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT [PK_FoodOrderItems] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_FoodOrderItems_FoodOrders_OrderId] FOREIGN KEY ([FoodOrderId]) REFERENCES [dbo].[FoodOrders] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_FoodOrderItems_FoodItems_FoodItemId] FOREIGN KEY ([FoodItemId]) REFERENCES [dbo].[FoodItems] ([Id])
    );
    CREATE NONCLUSTERED INDEX [IX_FoodOrderItems_FoodOrderId] ON [dbo].[FoodOrderItems] ([FoodOrderId] ASC);
    PRINT 'Created table [FoodOrderItems].';
END
GO

-- ------------------------------------------------------------------------------
-- 11. DRIVERS, VEHICLES & RIDES
-- ------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Drivers]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Drivers] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [UserId] BIGINT NOT NULL,
        [LicenseNumber] NVARCHAR(50) NULL,
        [IsVerified] BIT NOT NULL CONSTRAINT [DF_Drivers_IsVerified] DEFAULT (0),
        [IsOnline] BIT NOT NULL CONSTRAINT [DF_Drivers_IsOnline] DEFAULT (0),
        [CurrentLatitude] DECIMAL(10, 7) NULL,
        [CurrentLongitude] DECIMAL(10, 7) NULL,
        [Rating] DECIMAL(3, 2) NOT NULL CONSTRAINT [DF_Drivers_Rating] DEFAULT (0.00),
        [TotalRides] INT NOT NULL CONSTRAINT [DF_Drivers_TotalRides] DEFAULT (0),
        [IsActive] BIT NOT NULL CONSTRAINT [DF_Drivers_IsActive] DEFAULT (1),
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_Drivers_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        [UpdatedAt] DATETIME2(7) NULL,
        CONSTRAINT [PK_Drivers] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_Drivers_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE
    );
    CREATE UNIQUE NONCLUSTERED INDEX [IX_Drivers_UserId] ON [dbo].[Drivers] ([UserId] ASC);
    PRINT 'Created table [Drivers].';
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Vehicles]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Vehicles] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [DriverId] BIGINT NOT NULL,
        [Type] NVARCHAR(20) NOT NULL, -- 'BIKE', 'AUTO', 'CAB'
        [Make] NVARCHAR(100) NULL,
        [Model] NVARCHAR(100) NULL,
        [Year] INT NULL,
        [RegistrationNumber] NVARCHAR(20) NOT NULL,
        [Color] NVARCHAR(50) NULL,
        [IsActive] BIT NOT NULL CONSTRAINT [DF_Vehicles_IsActive] DEFAULT (1),
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_Vehicles_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        [UpdatedAt] DATETIME2(7) NULL,
        CONSTRAINT [PK_Vehicles] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_Vehicles_Drivers_DriverId] FOREIGN KEY ([DriverId]) REFERENCES [dbo].[Drivers] ([Id]) ON DELETE CASCADE
    );
    CREATE UNIQUE NONCLUSTERED INDEX [IX_Vehicles_RegistrationNumber] ON [dbo].[Vehicles] ([RegistrationNumber] ASC);
    CREATE NONCLUSTERED INDEX [IX_Vehicles_DriverId] ON [dbo].[Vehicles] ([DriverId] ASC);
    PRINT 'Created table [Vehicles].';
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Rides]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Rides] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [RideNumber] NVARCHAR(20) NOT NULL,
        [UserId] BIGINT NOT NULL,
        [DriverId] BIGINT NULL,
        [VehicleId] BIGINT NULL,
        [VehicleType] NVARCHAR(20) NOT NULL, -- 'BIKE', 'AUTO', 'CAB'
        [PickupAddress] NVARCHAR(500) NOT NULL,
        [PickupLatitude] DECIMAL(10, 7) NOT NULL,
        [PickupLongitude] DECIMAL(10, 7) NOT NULL,
        [DropoffAddress] NVARCHAR(500) NOT NULL,
        [DropoffLatitude] DECIMAL(10, 7) NOT NULL,
        [DropoffLongitude] DECIMAL(10, 7) NOT NULL,
        [DistanceKm] DECIMAL(10, 2) NULL,
        [EstimatedFare] DECIMAL(10, 2) NOT NULL,
        [ActualFare] DECIMAL(10, 2) NULL,
        [Status] NVARCHAR(20) NOT NULL CONSTRAINT [DF_Rides_Status] DEFAULT (N'REQUESTED'),
        [OtpCode] NVARCHAR(10) NULL, -- 4-digit ride verification code
        [PaymentMethod] NVARCHAR(20) NULL,
        [PaymentStatus] NVARCHAR(20) NULL,
        [StartedAt] DATETIME2(7) NULL,
        [CompletedAt] DATETIME2(7) NULL,
        [CancelledAt] DATETIME2(7) NULL,
        [CancellationReason] NVARCHAR(500) NULL,
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_Rides_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        [UpdatedAt] DATETIME2(7) NULL,
        CONSTRAINT [PK_Rides] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_Rides_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]),
        CONSTRAINT [FK_Rides_Drivers_DriverId] FOREIGN KEY ([DriverId]) REFERENCES [dbo].[Drivers] ([Id]),
        CONSTRAINT [FK_Rides_Vehicles_VehicleId] FOREIGN KEY ([VehicleId]) REFERENCES [dbo].[Vehicles] ([Id])
    );
    CREATE UNIQUE NONCLUSTERED INDEX [IX_Rides_RideNumber] ON [dbo].[Rides] ([RideNumber] ASC);
    CREATE NONCLUSTERED INDEX [IX_Rides_UserId_CreatedAt] ON [dbo].[Rides] ([UserId] ASC, [CreatedAt] DESC);
    CREATE NONCLUSTERED INDEX [IX_Rides_DriverId_Status] ON [dbo].[Rides] ([DriverId] ASC, [Status] ASC);
    PRINT 'Created table [Rides].';
END
GO

-- ------------------------------------------------------------------------------
-- 12. MARKETPLACE CATEGORIES, LISTINGS, IMAGES, FAVORITES
-- ------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarketplaceCategories]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[MarketplaceCategories] (
        [Id] INT IDENTITY(1,1) NOT NULL,
        [Name] NVARCHAR(100) NOT NULL,
        [IconUrl] NVARCHAR(500) NULL,
        [SortOrder] INT NOT NULL CONSTRAINT [DF_MarketplaceCategories_SortOrder] DEFAULT (0),
        [IsActive] BIT NOT NULL CONSTRAINT [DF_MarketplaceCategories_IsActive] DEFAULT (1),
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_MarketplaceCategories_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        [UpdatedAt] DATETIME2(7) NULL,
        CONSTRAINT [PK_MarketplaceCategories] PRIMARY KEY CLUSTERED ([Id] ASC)
    );
    CREATE UNIQUE NONCLUSTERED INDEX [IX_MarketplaceCategories_Name] ON [dbo].[MarketplaceCategories] ([Name] ASC);
    PRINT 'Created table [MarketplaceCategories].';
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarketplaceListings]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[MarketplaceListings] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [UserId] BIGINT NOT NULL,
        [CategoryId] INT NOT NULL,
        [Title] NVARCHAR(200) NOT NULL,
        [Description] NVARCHAR(2000) NULL,
        [Price] DECIMAL(12, 2) NOT NULL,
        [Condition] NVARCHAR(20) NOT NULL CONSTRAINT [DF_MarketplaceListings_Condition] DEFAULT (N'USED'), -- 'NEW', 'LIKE_NEW', 'USED', 'FAIR'
        [Location] NVARCHAR(200) NULL,
        [Latitude] DECIMAL(10, 7) NULL,
        [Longitude] DECIMAL(10, 7) NULL,
        [Status] NVARCHAR(20) NOT NULL CONSTRAINT [DF_MarketplaceListings_Status] DEFAULT (N'ACTIVE'), -- 'ACTIVE', 'SOLD', 'EXPIRED', 'REMOVED'
        [IsFeatured] BIT NOT NULL CONSTRAINT [DF_MarketplaceListings_IsFeatured] DEFAULT (0),
        [ViewCount] INT NOT NULL CONSTRAINT [DF_MarketplaceListings_ViewCount] DEFAULT (0),
        [IsActive] BIT NOT NULL CONSTRAINT [DF_MarketplaceListings_IsActive] DEFAULT (1),
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_MarketplaceListings_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        [UpdatedAt] DATETIME2(7) NULL,
        CONSTRAINT [PK_MarketplaceListings] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_MarketplaceListings_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]),
        CONSTRAINT [FK_MarketplaceListings_Categories_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[MarketplaceCategories] ([Id])
    );
    CREATE NONCLUSTERED INDEX [IX_MarketplaceListings_CategoryId_Status] ON [dbo].[MarketplaceListings] ([CategoryId] ASC, [Status] ASC);
    CREATE NONCLUSTERED INDEX [IX_MarketplaceListings_UserId] ON [dbo].[MarketplaceListings] ([UserId] ASC);
    PRINT 'Created table [MarketplaceListings].';
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListingImages]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[ListingImages] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [ListingId] BIGINT NOT NULL,
        [ImageUrl] NVARCHAR(500) NOT NULL,
        [SortOrder] INT NOT NULL CONSTRAINT [DF_ListingImages_SortOrder] DEFAULT (0),
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_ListingImages_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT [PK_ListingImages] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_ListingImages_MarketplaceListings_ListingId] FOREIGN KEY ([ListingId]) REFERENCES [dbo].[MarketplaceListings] ([Id]) ON DELETE CASCADE
    );
    CREATE NONCLUSTERED INDEX [IX_ListingImages_ListingId] ON [dbo].[ListingImages] ([ListingId] ASC);
    PRINT 'Created table [ListingImages].';
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Favorites]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Favorites] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [UserId] BIGINT NOT NULL,
        [ListingId] BIGINT NOT NULL,
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_Favorites_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT [PK_Favorites] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_Favorites_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_Favorites_MarketplaceListings_ListingId] FOREIGN KEY ([ListingId]) REFERENCES [dbo].[MarketplaceListings] ([Id])
    );
    CREATE UNIQUE NONCLUSTERED INDEX [IX_Favorites_UserId_ListingId] ON [dbo].[Favorites] ([UserId] ASC, [ListingId] ASC);
    PRINT 'Created table [Favorites].';
END
GO

-- ------------------------------------------------------------------------------
-- 13. COMMON PLATFORM: BANNERS, REVIEWS, NOTIFICATIONS, PAYMENTS, SETTINGS
-- ------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Banners]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Banners] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [Title] NVARCHAR(200) NOT NULL,
        [ImageUrl] NVARCHAR(500) NULL,
        [TargetType] NVARCHAR(50) NULL, -- 'RESTAURANT', 'FOOD_ITEM', 'LISTING', 'URL'
        [TargetId] NVARCHAR(50) NULL,
        [Module] NVARCHAR(20) NOT NULL CONSTRAINT [DF_Banners_Module] DEFAULT (N'HOME'), -- 'HOME', 'FOOD', 'RIDE', 'MARKETPLACE'
        [SortOrder] INT NOT NULL CONSTRAINT [DF_Banners_SortOrder] DEFAULT (0),
        [IsActive] BIT NOT NULL CONSTRAINT [DF_Banners_IsActive] DEFAULT (1),
        [StartDate] DATETIME2(7) NULL,
        [EndDate] DATETIME2(7) NULL,
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_Banners_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        [UpdatedAt] DATETIME2(7) NULL,
        CONSTRAINT [PK_Banners] PRIMARY KEY CLUSTERED ([Id] ASC)
    );
    CREATE NONCLUSTERED INDEX [IX_Banners_Module_IsActive] ON [dbo].[Banners] ([Module] ASC, [IsActive] ASC);
    PRINT 'Created table [Banners].';
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reviews]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Reviews] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [UserId] BIGINT NOT NULL,
        [TargetType] NVARCHAR(20) NOT NULL, -- 'RESTAURANT', 'DRIVER', 'LISTING'
        [TargetId] BIGINT NOT NULL,
        [Rating] INT NOT NULL, -- 1 to 5
        [Comment] NVARCHAR(1000) NULL,
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_Reviews_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT [PK_Reviews] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_Reviews_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE
    );
    CREATE NONCLUSTERED INDEX [IX_Reviews_TargetType_TargetId] ON [dbo].[Reviews] ([TargetType] ASC, [TargetId] ASC);
    PRINT 'Created table [Reviews].';
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Notifications]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Notifications] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [UserId] BIGINT NOT NULL,
        [Title] NVARCHAR(200) NOT NULL,
        [Body] NVARCHAR(1000) NULL,
        [Type] NVARCHAR(50) NULL, -- 'ORDER', 'RIDE', 'MARKETPLACE', 'PROMO', 'SYSTEM'
        [ReferenceId] NVARCHAR(50) NULL,
        [IsRead] BIT NOT NULL CONSTRAINT [DF_Notifications_IsRead] DEFAULT (0),
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_Notifications_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT [PK_Notifications] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_Notifications_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id]) ON DELETE CASCADE
    );
    CREATE NONCLUSTERED INDEX [IX_Notifications_UserId_IsRead] ON [dbo].[Notifications] ([UserId] ASC, [IsRead] ASC);
    PRINT 'Created table [Notifications].';
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payments]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Payments] (
        [Id] BIGINT IDENTITY(1,1) NOT NULL,
        [UserId] BIGINT NOT NULL,
        [Module] NVARCHAR(20) NOT NULL, -- 'FOOD', 'RIDE'
        [OrderId] BIGINT NOT NULL,
        [Amount] DECIMAL(10, 2) NOT NULL,
        [PaymentMethod] NVARCHAR(20) NOT NULL, -- 'COD', 'UPI', 'CARD', 'WALLET'
        [TransactionId] NVARCHAR(100) NULL,
        [Status] NVARCHAR(20) NOT NULL CONSTRAINT [DF_Payments_Status] DEFAULT (N'PENDING'), -- 'PENDING', 'COMPLETED', 'FAILED', 'REFUNDED'
        [CreatedAt] DATETIME2(7) NOT NULL CONSTRAINT [DF_Payments_CreatedAt] DEFAULT (SYSUTCDATETIME()),
        [UpdatedAt] DATETIME2(7) NULL,
        CONSTRAINT [PK_Payments] PRIMARY KEY CLUSTERED ([Id] ASC),
        CONSTRAINT [FK_Payments_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([Id])
    );
    CREATE NONCLUSTERED INDEX [IX_Payments_UserId] ON [dbo].[Payments] ([UserId] ASC);
    PRINT 'Created table [Payments].';
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AppSettings]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[AppSettings] (
        [Id] INT IDENTITY(1,1) NOT NULL,
        [SettingKey] NVARCHAR(100) NOT NULL,
        [SettingValue] NVARCHAR(1000) NULL,
        [Description] NVARCHAR(255) NULL,
        [UpdatedAt] DATETIME2(7) NULL,
        CONSTRAINT [PK_AppSettings] PRIMARY KEY CLUSTERED ([Id] ASC)
    );
    CREATE UNIQUE NONCLUSTERED INDEX [IX_AppSettings_SettingKey] ON [dbo].[AppSettings] ([SettingKey] ASC);
    PRINT 'Created table [AppSettings].';
END
GO

-- ------------------------------------------------------------------------------
-- 14. SEED DATA (ROLES, ADMIN USER, CATEGORIES, SAMPLE DATA)
-- ------------------------------------------------------------------------------

-- Seed Roles
SET IDENTITY_INSERT [dbo].[Roles] ON;
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [Id] = 1)
    INSERT INTO [dbo].[Roles] ([Id], [Name], [Description]) VALUES (1, N'CUSTOMER', N'Regular customer account');
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [Id] = 2)
    INSERT INTO [dbo].[Roles] ([Id], [Name], [Description]) VALUES (2, N'ADMIN', N'System administrator');
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [Id] = 3)
    INSERT INTO [dbo].[Roles] ([Id], [Name], [Description]) VALUES (3, N'RESTAURANT_OWNER', N'Restaurant owner/manager');
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [Id] = 4)
    INSERT INTO [dbo].[Roles] ([Id], [Name], [Description]) VALUES (4, N'DRIVER', N'Ride driver');
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [Id] = 5)
    INSERT INTO [dbo].[Roles] ([Id], [Name], [Description]) VALUES (5, N'MARKETPLACE_SELLER', N'Marketplace seller');
SET IDENTITY_INSERT [dbo].[Roles] OFF;
GO

-- Seed Default Super Admin (Phone: 9999999999, Password: Admin@123)
-- BCrypt Hash: $2a$11$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy
SET IDENTITY_INSERT [dbo].[Users] ON;
IF NOT EXISTS (SELECT 1 FROM [dbo].[Users] WHERE [Id] = 1)
BEGIN
    INSERT INTO [dbo].[Users] ([Id], [MobileNumber], [FullName], [Email], [PasswordHash], [IsActive], [CreatedAt])
    VALUES (1, N'9999999999', N'Super Admin', N'admin@superapp.com', N'$2a$11$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 1, SYSUTCDATETIME());
END
SET IDENTITY_INSERT [dbo].[Users] OFF;
GO

-- Assign Admin Role to User 1
SET IDENTITY_INSERT [dbo].[UserRoles] ON;
IF NOT EXISTS (SELECT 1 FROM [dbo].[UserRoles] WHERE [Id] = 1)
BEGIN
    INSERT INTO [dbo].[UserRoles] ([Id], [UserId], [RoleId], [CreatedAt])
    VALUES (1, 1, 2, SYSUTCDATETIME());
END
SET IDENTITY_INSERT [dbo].[UserRoles] OFF;
GO

-- Seed Marketplace Categories
SET IDENTITY_INSERT [dbo].[MarketplaceCategories] ON;
IF NOT EXISTS (SELECT 1 FROM [dbo].[MarketplaceCategories] WHERE [Id] = 1)
    INSERT INTO [dbo].[MarketplaceCategories] ([Id], [Name], [SortOrder]) VALUES (1, N'Mobiles', 1);
IF NOT EXISTS (SELECT 1 FROM [dbo].[MarketplaceCategories] WHERE [Id] = 2)
    INSERT INTO [dbo].[MarketplaceCategories] ([Id], [Name], [SortOrder]) VALUES (2, N'Vehicles', 2);
IF NOT EXISTS (SELECT 1 FROM [dbo].[MarketplaceCategories] WHERE [Id] = 3)
    INSERT INTO [dbo].[MarketplaceCategories] ([Id], [Name], [SortOrder]) VALUES (3, N'Electronics', 3);
IF NOT EXISTS (SELECT 1 FROM [dbo].[MarketplaceCategories] WHERE [Id] = 4)
    INSERT INTO [dbo].[MarketplaceCategories] ([Id], [Name], [SortOrder]) VALUES (4, N'Furniture', 4);
IF NOT EXISTS (SELECT 1 FROM [dbo].[MarketplaceCategories] WHERE [Id] = 5)
    INSERT INTO [dbo].[MarketplaceCategories] ([Id], [Name], [SortOrder]) VALUES (5, N'Fashion', 5);
IF NOT EXISTS (SELECT 1 FROM [dbo].[MarketplaceCategories] WHERE [Id] = 6)
    INSERT INTO [dbo].[MarketplaceCategories] ([Id], [Name], [SortOrder]) VALUES (6, N'Books', 6);
IF NOT EXISTS (SELECT 1 FROM [dbo].[MarketplaceCategories] WHERE [Id] = 7)
    INSERT INTO [dbo].[MarketplaceCategories] ([Id], [Name], [SortOrder]) VALUES (7, N'Sports', 7);
IF NOT EXISTS (SELECT 1 FROM [dbo].[MarketplaceCategories] WHERE [Id] = 8)
    INSERT INTO [dbo].[MarketplaceCategories] ([Id], [Name], [SortOrder]) VALUES (8, N'Others', 8);
SET IDENTITY_INSERT [dbo].[MarketplaceCategories] OFF;
GO

-- Seed Sample Coupons
SET IDENTITY_INSERT [dbo].[Coupons] ON;
IF NOT EXISTS (SELECT 1 FROM [dbo].[Coupons] WHERE [Id] = 1)
BEGIN
    INSERT INTO [dbo].[Coupons] ([Id], [Code], [Description], [DiscountType], [DiscountValue], [MinOrderAmount], [MaxDiscount], [StartDate], [ExpiryDate], [ApplicableModule], [IsActive])
    VALUES (1, N'WELCOME50', N'50% off on your first food order', N'PERCENTAGE', 50.00, 150.00, 100.00, SYSUTCDATETIME(), DATEADD(month, 6, SYSUTCDATETIME()), N'FOOD', 1);
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Coupons] WHERE [Id] = 2)
BEGIN
    INSERT INTO [dbo].[Coupons] ([Id], [Code], [Description], [DiscountType], [DiscountValue], [MinOrderAmount], [MaxDiscount], [StartDate], [ExpiryDate], [ApplicableModule], [IsActive])
    VALUES (2, N'FLAT30', N'Flat Rs 30 off on rides', N'FLAT', 30.00, 50.00, 30.00, SYSUTCDATETIME(), DATEADD(month, 6, SYSUTCDATETIME()), N'RIDE', 1);
END
SET IDENTITY_INSERT [dbo].[Coupons] OFF;
GO

-- Seed Sample Banners
SET IDENTITY_INSERT [dbo].[Banners] ON;
IF NOT EXISTS (SELECT 1 FROM [dbo].[Banners] WHERE [Id] = 1)
BEGIN
    INSERT INTO [dbo].[Banners] ([Id], [Title], [ImageUrl], [TargetType], [Module], [SortOrder], [IsActive])
    VALUES (1, N'50% OFF on Top Biryanis', N'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600', N'MODULE', N'FOOD', 1, 1);
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Banners] WHERE [Id] = 2)
BEGIN
    INSERT INTO [dbo].[Banners] ([Id], [Title], [ImageUrl], [TargetType], [Module], [SortOrder], [IsActive])
    VALUES (2, N'Fastest Bike Rides in Town', N'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=600', N'MODULE', N'RIDE', 2, 1);
END
SET IDENTITY_INSERT [dbo].[Banners] OFF;
GO

-- Seed Sample Restaurants & Dishes (Matching Reference Screenshots)
SET IDENTITY_INSERT [dbo].[Restaurants] ON;
IF NOT EXISTS (SELECT 1 FROM [dbo].[Restaurants] WHERE [Id] = 1)
BEGIN
    INSERT INTO [dbo].[Restaurants] ([Id], [Name], [Description], [ImageUrl], [Phone], [AddressLine], [City], [Rating], [TotalRatings], [IsVeg], [OpeningTime], [ClosingTime], [MinOrderAmount], [DeliveryFee], [AvgDeliveryTimeMinutes], [IsActive], [IsFeatured])
    VALUES (1, N'Meghana Foods (Special Biryani)', N'Biryani, Hyderabadi, Andhra, Kebabs', N'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=500', N'9876543210', N'Connaught Place', N'New Delhi', 4.6, 1280, 0, '10:00:00', '23:00:00', 200.00, 0.00, 22, 1, 1);
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[Restaurants] WHERE [Id] = 2)
BEGIN
    INSERT INTO [dbo].[Restaurants] ([Id], [Name], [Description], [ImageUrl], [Phone], [AddressLine], [City], [Rating], [TotalRatings], [IsVeg], [OpeningTime], [ClosingTime], [MinOrderAmount], [DeliveryFee], [AvgDeliveryTimeMinutes], [IsActive], [IsFeatured])
    VALUES (2, N'Haldiram''s Sweets & Thali', N'North Indian, Chaat, Pure Veg, Mithai', N'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=500', N'9876543211', N'Barakhamba Road', N'New Delhi', 4.5, 940, 1, '09:00:00', '22:30:00', 150.00, 25.00, 18, 1, 1);
END
SET IDENTITY_INSERT [dbo].[Restaurants] OFF;
GO

-- Seed Categories for Meghana Foods
SET IDENTITY_INSERT [dbo].[RestaurantCategories] ON;
IF NOT EXISTS (SELECT 1 FROM [dbo].[RestaurantCategories] WHERE [Id] = 1)
BEGIN
    INSERT INTO [dbo].[RestaurantCategories] ([Id], [RestaurantId], [Name], [SortOrder], [IsActive])
    VALUES (1, 1, N'Biryani Specials', 1, 1);
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[RestaurantCategories] WHERE [Id] = 2)
BEGIN
    INSERT INTO [dbo].[RestaurantCategories] ([Id], [RestaurantId], [Name], [SortOrder], [IsActive])
    VALUES (2, 1, N'Starters', 2, 1);
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[RestaurantCategories] WHERE [Id] = 3)
BEGIN
    INSERT INTO [dbo].[RestaurantCategories] ([Id], [RestaurantId], [Name], [SortOrder], [IsActive])
    VALUES (3, 1, N'Desserts', 3, 1);
END
SET IDENTITY_INSERT [dbo].[RestaurantCategories] OFF;
GO

-- Seed Food Items for Meghana Foods
SET IDENTITY_INSERT [dbo].[FoodItems] ON;
IF NOT EXISTS (SELECT 1 FROM [dbo].[FoodItems] WHERE [Id] = 1)
BEGIN
    INSERT INTO [dbo].[FoodItems] ([Id], [RestaurantId], [RestaurantCategoryId], [Name], [Description], [ImageUrl], [BasePrice], [DiscountPercent], [IsVeg], [IsAvailable], [IsBestseller], [IsCustomizable], [SortOrder])
    VALUES (1, 1, 1, N'Meghana Special Chicken Biryani', N'Fragrant Basmati rice topped with boneless spiced chicken marinated in Andhra green chili paste.', N'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=300', 340.00, 0.00, 0, 1, 1, 1, 1);
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[FoodItems] WHERE [Id] = 2)
BEGIN
    INSERT INTO [dbo].[FoodItems] ([Id], [RestaurantId], [RestaurantCategoryId], [Name], [Description], [ImageUrl], [BasePrice], [DiscountPercent], [IsVeg], [IsAvailable], [IsBestseller], [IsCustomizable], [SortOrder])
    VALUES (2, 1, 1, N'Paneer 65 Biryani (Dum Style)', N'Spiced golden paneer cubes layered with saffron long grain basmati rice.', N'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=300', 290.00, 0.00, 1, 1, 1, 1, 2);
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[FoodItems] WHERE [Id] = 3)
BEGIN
    INSERT INTO [dbo].[FoodItems] ([Id], [RestaurantId], [RestaurantCategoryId], [Name], [Description], [ImageUrl], [BasePrice], [DiscountPercent], [IsVeg], [IsAvailable], [IsBestseller], [IsCustomizable], [SortOrder])
    VALUES (3, 1, 2, N'Crispy Boneless Chicken 65', N'Tender chicken bites tossed with south curry leaves, mustard seeds, and Andhra red chili glaze.', N'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?w=300', 310.00, 0.00, 0, 1, 1, 0, 3);
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[FoodItems] WHERE [Id] = 4)
BEGIN
    INSERT INTO [dbo].[FoodItems] ([Id], [RestaurantId], [RestaurantCategoryId], [Name], [Description], [ImageUrl], [BasePrice], [DiscountPercent], [IsVeg], [IsAvailable], [IsBestseller], [IsCustomizable], [SortOrder])
    VALUES (4, 1, 2, N'Apollo Fish Fry', N'Flaky fillets fried crisp and tossed in spiced yogurt seasoning.', N'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=300', 360.00, 0.00, 0, 1, 0, 0, 4);
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[FoodItems] WHERE [Id] = 5)
BEGIN
    INSERT INTO [dbo].[FoodItems] ([Id], [RestaurantId], [RestaurantCategoryId], [Name], [Description], [ImageUrl], [BasePrice], [DiscountPercent], [IsVeg], [IsAvailable], [IsBestseller], [IsCustomizable], [SortOrder])
    VALUES (5, 1, 3, N'Gulab Jamun with Rabri', N'Warm reduced milk dumplings served with chilled saffron rabri.', N'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=300', 110.00, 0.00, 1, 1, 0, 0, 5);
END
SET IDENTITY_INSERT [dbo].[FoodItems] OFF;
GO

-- Seed Variants & Addons for Meghana Special Chicken Biryani (Id = 1)
SET IDENTITY_INSERT [dbo].[FoodItemVariants] ON;
IF NOT EXISTS (SELECT 1 FROM [dbo].[FoodItemVariants] WHERE [Id] = 1)
    INSERT INTO [dbo].[FoodItemVariants] ([Id], [FoodItemId], [Name], [AdditionalPrice], [IsDefault], [SortOrder])
    VALUES (1, 1, N'Regular Portion', 0.00, 1, 1);
IF NOT EXISTS (SELECT 1 FROM [dbo].[FoodItemVariants] WHERE [Id] = 2)
    INSERT INTO [dbo].[FoodItemVariants] ([Id], [FoodItemId], [Name], [AdditionalPrice], [IsDefault], [SortOrder])
    VALUES (2, 1, N'Jumbo Pack (Serves 3)', 210.00, 0, 2);
SET IDENTITY_INSERT [dbo].[FoodItemVariants] OFF;
GO

SET IDENTITY_INSERT [dbo].[FoodItemAddons] ON;
IF NOT EXISTS (SELECT 1 FROM [dbo].[FoodItemAddons] WHERE [Id] = 1)
    INSERT INTO [dbo].[FoodItemAddons] ([Id], [FoodItemId], [GroupName], [Name], [Price], [IsDefault], [SortOrder])
    VALUES (1, 1, N'ADD-ONS', N'Boondi Raita Bowl', 35.00, 0, 1);
IF NOT EXISTS (SELECT 1 FROM [dbo].[FoodItemAddons] WHERE [Id] = 2)
    INSERT INTO [dbo].[FoodItemAddons] ([Id], [FoodItemId], [GroupName], [Name], [Price], [IsDefault], [SortOrder])
    VALUES (2, 1, N'ADD-ONS', N'Extra Mirchi Ka Salan', 45.00, 0, 2);
SET IDENTITY_INSERT [dbo].[FoodItemAddons] OFF;
GO

PRINT '==============================================================================';
PRINT 'SuperApp Database Schema & Seed Data successfully initialized!';
PRINT '==============================================================================';
GO
