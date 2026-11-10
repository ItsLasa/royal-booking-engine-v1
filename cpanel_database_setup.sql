-- ==============================================================================
-- Royal Mansion Resort & Villa - Complete MySQL Database Schema & Seed Data
-- Designed for direct import in cPanel phpMyAdmin or MySQL CLI (No Prisma Required)
-- Character Set: utf8mb4 | Collation: utf8mb4_unicode_ci
-- ==============================================================================

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- ------------------------------------------------------------------------------
-- 1. Table structure for `Property`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `Property`;
CREATE TABLE `Property` (
  `id` VARCHAR(191) NOT NULL,
  `name` VARCHAR(191) NOT NULL,
  `slug` VARCHAR(191) NOT NULL,
  `description` TEXT NOT NULL,
  `address` VARCHAR(191) NULL,
  `city` VARCHAR(191) NULL,
  `district` VARCHAR(191) NULL,
  `country` VARCHAR(191) NOT NULL DEFAULT 'Sri Lanka',
  `timezone` VARCHAR(191) NOT NULL DEFAULT 'Asia/Colombo',
  `currency` VARCHAR(191) NOT NULL DEFAULT 'LKR',
  `phone` VARCHAR(191) NULL,
  `email` VARCHAR(191) NULL,
  `checkInTime` VARCHAR(191) NOT NULL DEFAULT '14:00',
  `checkOutTime` VARCHAR(191) NOT NULL DEFAULT '11:00',
  `taxPercentage` DECIMAL(6, 2) NOT NULL DEFAULT 0.00,
  `serviceChargePercentage` DECIMAL(6, 2) NOT NULL DEFAULT 0.00,
  `bankTransferInstructions` TEXT NULL,
  `calendarFeedToken` VARCHAR(191) NOT NULL,
  `active` BOOLEAN NOT NULL DEFAULT true,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Property_slug_key` (`slug`),
  UNIQUE KEY `Property_calendarFeedToken_key` (`calendarFeedToken`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 2. Table structure for `Unit`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `Unit`;
CREATE TABLE `Unit` (
  `id` VARCHAR(191) NOT NULL,
  `propertyId` VARCHAR(191) NOT NULL,
  `name` VARCHAR(191) NOT NULL,
  `slug` VARCHAR(191) NOT NULL,
  `description` TEXT NULL,
  `unitType` VARCHAR(191) NOT NULL DEFAULT 'PRIVATE_VILLA',
  `inventoryCount` INT NOT NULL DEFAULT 1,
  `bedrooms` INT NOT NULL DEFAULT 4,
  `bathrooms` INT NOT NULL DEFAULT 4,
  `baseOccupancy` INT NOT NULL DEFAULT 2,
  `maximumOccupancy` INT NOT NULL DEFAULT 10,
  `maximumAdults` INT NOT NULL DEFAULT 10,
  `maximumChildren` INT NOT NULL DEFAULT 6,
  `active` BOOLEAN NOT NULL DEFAULT true,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Unit_propertyId_slug_key` (`propertyId`, `slug`),
  KEY `Unit_propertyId_idx` (`propertyId`),
  CONSTRAINT `Unit_propertyId_fkey` FOREIGN KEY (`propertyId`) REFERENCES `Property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 3. Table structure for `Package`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `Package`;
CREATE TABLE `Package` (
  `id` VARCHAR(191) NOT NULL,
  `propertyId` VARCHAR(191) NOT NULL,
  `unitId` VARCHAR(191) NOT NULL,
  `name` VARCHAR(191) NOT NULL,
  `slug` VARCHAR(191) NOT NULL,
  `shortDescription` VARCHAR(191) NOT NULL,
  `fullDescription` TEXT NOT NULL,
  `basePrice` DECIMAL(12, 2) NOT NULL,
  `pricingType` ENUM('PER_NIGHT', 'PER_BOOKING') NOT NULL DEFAULT 'PER_NIGHT',
  `includedAdults` INT NOT NULL DEFAULT 2,
  `includedChildren` INT NOT NULL DEFAULT 0,
  `maximumGuests` INT NOT NULL DEFAULT 10,
  `minimumNights` INT NOT NULL DEFAULT 1,
  `maximumNights` INT NOT NULL DEFAULT 30,
  `depositPercentage` DECIMAL(5, 2) NOT NULL DEFAULT 50.00,
  `mealPlan` VARCHAR(191) NULL,
  `cancellationPolicy` TEXT NOT NULL,
  `terms` TEXT NOT NULL,
  `featured` BOOLEAN NOT NULL DEFAULT false,
  `active` BOOLEAN NOT NULL DEFAULT true,
  `displayOrder` INT NOT NULL DEFAULT 0,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Package_propertyId_slug_key` (`propertyId`, `slug`),
  KEY `Package_unitId_idx` (`unitId`),
  CONSTRAINT `Package_propertyId_fkey` FOREIGN KEY (`propertyId`) REFERENCES `Property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Package_unitId_fkey` FOREIGN KEY (`unitId`) REFERENCES `Unit` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 4. Table structure for `PackageImage`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `PackageImage`;
CREATE TABLE `PackageImage` (
  `id` VARCHAR(191) NOT NULL,
  `packageId` VARCHAR(191) NOT NULL,
  `imageUrl` VARCHAR(191) NOT NULL,
  `altText` VARCHAR(191) NOT NULL,
  `displayOrder` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `PackageImage_packageId_idx` (`packageId`),
  CONSTRAINT `PackageImage_packageId_fkey` FOREIGN KEY (`packageId`) REFERENCES `Package` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 5. Table structure for `Amenity`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `Amenity`;
CREATE TABLE `Amenity` (
  `id` VARCHAR(191) NOT NULL,
  `name` VARCHAR(191) NOT NULL,
  `icon` VARCHAR(191) NULL,
  `active` BOOLEAN NOT NULL DEFAULT true,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Amenity_name_key` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 6. Table structure for `PackageAmenity`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `PackageAmenity`;
CREATE TABLE `PackageAmenity` (
  `packageId` VARCHAR(191) NOT NULL,
  `amenityId` VARCHAR(191) NOT NULL,
  PRIMARY KEY (`packageId`, `amenityId`),
  CONSTRAINT `PackageAmenity_packageId_fkey` FOREIGN KEY (`packageId`) REFERENCES `Package` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `PackageAmenity_amenityId_fkey` FOREIGN KEY (`amenityId`) REFERENCES `Amenity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 7. Table structure for `UnitAmenity`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `UnitAmenity`;
CREATE TABLE `UnitAmenity` (
  `unitId` VARCHAR(191) NOT NULL,
  `amenityId` VARCHAR(191) NOT NULL,
  PRIMARY KEY (`unitId`, `amenityId`),
  CONSTRAINT `UnitAmenity_unitId_fkey` FOREIGN KEY (`unitId`) REFERENCES `Unit` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `UnitAmenity_amenityId_fkey` FOREIGN KEY (`amenityId`) REFERENCES `Amenity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 8. Table structure for `SeasonalRate`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `SeasonalRate`;
CREATE TABLE `SeasonalRate` (
  `id` VARCHAR(191) NOT NULL,
  `packageId` VARCHAR(191) NOT NULL,
  `name` VARCHAR(191) NOT NULL,
  `startDate` DATE NOT NULL,
  `endDate` DATE NOT NULL,
  `nightlyPrice` DECIMAL(12, 2) NOT NULL,
  `weekendPrice` DECIMAL(12, 2) NULL,
  `minimumNights` INT NULL,
  `priority` INT NOT NULL DEFAULT 0,
  `active` BOOLEAN NOT NULL DEFAULT true,
  PRIMARY KEY (`id`),
  KEY `SeasonalRate_packageId_startDate_endDate_priority_idx` (`packageId`, `startDate`, `endDate`, `priority`),
  CONSTRAINT `SeasonalRate_packageId_fkey` FOREIGN KEY (`packageId`) REFERENCES `Package` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 9. Table structure for `DateRateOverride`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `DateRateOverride`;
CREATE TABLE `DateRateOverride` (
  `id` VARCHAR(191) NOT NULL,
  `packageId` VARCHAR(191) NOT NULL,
  `date` DATE NOT NULL,
  `price` DECIMAL(12, 2) NULL,
  `minimumNights` INT NULL,
  `closed` BOOLEAN NOT NULL DEFAULT false,
  `closedToArrival` BOOLEAN NOT NULL DEFAULT false,
  `closedToDeparture` BOOLEAN NOT NULL DEFAULT false,
  `note` VARCHAR(191) NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `DateRateOverride_packageId_date_key` (`packageId`, `date`),
  CONSTRAINT `DateRateOverride_packageId_fkey` FOREIGN KEY (`packageId`) REFERENCES `Package` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 10. Table structure for `AddOn`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `AddOn`;
CREATE TABLE `AddOn` (
  `id` VARCHAR(191) NOT NULL,
  `propertyId` VARCHAR(191) NOT NULL,
  `name` VARCHAR(191) NOT NULL,
  `description` VARCHAR(191) NULL,
  `pricingType` ENUM('PER_BOOKING', 'PER_NIGHT', 'PER_GUEST', 'PER_GUEST_PER_NIGHT') NOT NULL,
  `price` DECIMAL(12, 2) NOT NULL,
  `maximumQuantity` INT NOT NULL DEFAULT 1,
  `active` BOOLEAN NOT NULL DEFAULT true,
  PRIMARY KEY (`id`),
  KEY `AddOn_propertyId_idx` (`propertyId`),
  CONSTRAINT `AddOn_propertyId_fkey` FOREIGN KEY (`propertyId`) REFERENCES `Property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 11. Table structure for `Coupon`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `Coupon`;
CREATE TABLE `Coupon` (
  `id` VARCHAR(191) NOT NULL,
  `code` VARCHAR(191) NOT NULL,
  `description` VARCHAR(191) NULL,
  `discountType` ENUM('PERCENTAGE', 'FIXED_AMOUNT') NOT NULL,
  `discountValue` DECIMAL(12, 2) NOT NULL,
  `minimumBookingAmount` DECIMAL(12, 2) NULL,
  `maximumDiscount` DECIMAL(12, 2) NULL,
  `validFrom` DATE NULL,
  `validUntil` DATE NULL,
  `usageLimit` INT NULL,
  `usageCount` INT NOT NULL DEFAULT 0,
  `active` BOOLEAN NOT NULL DEFAULT true,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Coupon_code_key` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 12. Table structure for `Guest`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `Guest`;
CREATE TABLE `Guest` (
  `id` VARCHAR(191) NOT NULL,
  `firstName` VARCHAR(191) NOT NULL,
  `lastName` VARCHAR(191) NOT NULL,
  `email` VARCHAR(191) NOT NULL,
  `phone` VARCHAR(191) NOT NULL,
  `country` VARCHAR(191) NULL,
  `address` VARCHAR(191) NULL,
  `identityDocumentReference` VARCHAR(191) NULL,
  `marketingConsent` BOOLEAN NOT NULL DEFAULT false,
  `preferences` JSON NULL,
  `internalNotes` TEXT NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `Guest_email_idx` (`email`),
  KEY `Guest_phone_idx` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 13. Table structure for `Booking`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `Booking`;
CREATE TABLE `Booking` (
  `id` VARCHAR(191) NOT NULL,
  `reference` VARCHAR(191) NOT NULL,
  `propertyId` VARCHAR(191) NOT NULL,
  `unitId` VARCHAR(191) NOT NULL,
  `packageId` VARCHAR(191) NOT NULL,
  `guestId` VARCHAR(191) NOT NULL,
  `checkInDate` DATE NOT NULL,
  `checkOutDate` DATE NOT NULL,
  `nights` INT NOT NULL,
  `adults` INT NOT NULL,
  `children` INT NOT NULL DEFAULT 0,
  `infants` INT NOT NULL DEFAULT 0,
  `subtotal` DECIMAL(12, 2) NOT NULL,
  `addOnTotal` DECIMAL(12, 2) NOT NULL,
  `discountTotal` DECIMAL(12, 2) NOT NULL,
  `taxTotal` DECIMAL(12, 2) NOT NULL,
  `serviceChargeTotal` DECIMAL(12, 2) NOT NULL,
  `grandTotal` DECIMAL(12, 2) NOT NULL,
  `depositRequired` DECIMAL(12, 2) NOT NULL,
  `amountPaid` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
  `balanceDue` DECIMAL(12, 2) NOT NULL,
  `currency` VARCHAR(191) NOT NULL DEFAULT 'LKR',
  `bookingStatus` ENUM('HOLD', 'PENDING_PAYMENT', 'PAYMENT_PROCESSING', 'CONFIRMED', 'CANCELLED', 'COMPLETED', 'NO_SHOW', 'EXPIRED') NOT NULL DEFAULT 'HOLD',
  `paymentStatus` ENUM('UNPAID', 'PARTIALLY_PAID', 'PAID', 'FAILED', 'REFUND_PENDING', 'PARTIALLY_REFUNDED', 'REFUNDED') NOT NULL DEFAULT 'UNPAID',
  `paymentOption` ENUM('DEPOSIT', 'FULL') NOT NULL DEFAULT 'DEPOSIT',
  `source` ENUM('DIRECT_WEBSITE', 'ADMIN', 'PHONE', 'WALK_IN', 'BOOKING_COM', 'AIRBNB', 'AGODA', 'OTHER') NOT NULL DEFAULT 'DIRECT_WEBSITE',
  `specialRequests` TEXT NULL,
  `internalNotes` TEXT NULL,
  `cancellationReason` TEXT NULL,
  `actualCheckInAt` DATETIME(3) NULL,
  `actualCheckOutAt` DATETIME(3) NULL,
  `manageTokenHash` VARCHAR(191) NULL,
  `expiresAt` DATETIME(3) NULL,
  `confirmedAt` DATETIME(3) NULL,
  `cancelledAt` DATETIME(3) NULL,
  `noShowMarkedAt` DATETIME(3) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Booking_reference_key` (`reference`),
  KEY `Booking_unitId_checkInDate_checkOutDate_bookingStatus_idx` (`unitId`, `checkInDate`, `checkOutDate`, `bookingStatus`),
  KEY `Booking_reference_idx` (`reference`),
  CONSTRAINT `Booking_propertyId_fkey` FOREIGN KEY (`propertyId`) REFERENCES `Property` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Booking_unitId_fkey` FOREIGN KEY (`unitId`) REFERENCES `Unit` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Booking_packageId_fkey` FOREIGN KEY (`packageId`) REFERENCES `Package` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Booking_guestId_fkey` FOREIGN KEY (`guestId`) REFERENCES `Guest` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 14. Table structure for `BookingAddOn`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `BookingAddOn`;
CREATE TABLE `BookingAddOn` (
  `id` VARCHAR(191) NOT NULL,
  `bookingId` VARCHAR(191) NOT NULL,
  `addOnId` VARCHAR(191) NOT NULL,
  `nameSnapshot` VARCHAR(191) NOT NULL,
  `quantity` INT NOT NULL,
  `unitPrice` DECIMAL(12, 2) NOT NULL,
  `total` DECIMAL(12, 2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `BookingAddOn_bookingId_idx` (`bookingId`),
  KEY `BookingAddOn_addOnId_idx` (`addOnId`),
  CONSTRAINT `BookingAddOn_bookingId_fkey` FOREIGN KEY (`bookingId`) REFERENCES `Booking` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `BookingAddOn_addOnId_fkey` FOREIGN KEY (`addOnId`) REFERENCES `AddOn` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 15. Table structure for `BookingPriceLine`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `BookingPriceLine`;
CREATE TABLE `BookingPriceLine` (
  `id` VARCHAR(191) NOT NULL,
  `bookingId` VARCHAR(191) NOT NULL,
  `type` ENUM('ROOM_RATE', 'EXTRA_GUEST', 'ADD_ON', 'DISCOUNT', 'TAX', 'SERVICE_CHARGE', 'ADJUSTMENT') NOT NULL,
  `description` VARCHAR(191) NOT NULL,
  `serviceDate` DATE NULL,
  `quantity` INT NOT NULL,
  `unitAmount` DECIMAL(12, 2) NOT NULL,
  `totalAmount` DECIMAL(12, 2) NOT NULL,
  `metadata` JSON NULL,
  PRIMARY KEY (`id`),
  KEY `BookingPriceLine_bookingId_idx` (`bookingId`),
  CONSTRAINT `BookingPriceLine_bookingId_fkey` FOREIGN KEY (`bookingId`) REFERENCES `Booking` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 16. Table structure for `Payment`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `Payment`;
CREATE TABLE `Payment` (
  `id` VARCHAR(191) NOT NULL,
  `bookingId` VARCHAR(191) NOT NULL,
  `provider` ENUM('PAYHERE', 'BANK_TRANSFER', 'CASH') NOT NULL,
  `providerPaymentId` VARCHAR(191) NULL,
  `providerOrderId` VARCHAR(191) NULL,
  `idempotencyKey` VARCHAR(191) NOT NULL,
  `amount` DECIMAL(12, 2) NOT NULL,
  `currency` VARCHAR(191) NOT NULL,
  `status` ENUM('UNPAID', 'PARTIALLY_PAID', 'PAID', 'FAILED', 'REFUND_PENDING', 'PARTIALLY_REFUNDED', 'REFUNDED') NOT NULL DEFAULT 'UNPAID',
  `paymentMethod` VARCHAR(191) NULL,
  `rawStatusCode` VARCHAR(191) NULL,
  `verified` BOOLEAN NOT NULL DEFAULT false,
  `failureReason` VARCHAR(191) NULL,
  `processedAt` DATETIME(3) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Payment_idempotencyKey_key` (`idempotencyKey`),
  KEY `Payment_providerOrderId_idx` (`providerOrderId`),
  KEY `Payment_bookingId_idx` (`bookingId`),
  CONSTRAINT `Payment_bookingId_fkey` FOREIGN KEY (`bookingId`) REFERENCES `Booking` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 17. Table structure for `PaymentEvent`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `PaymentEvent`;
CREATE TABLE `PaymentEvent` (
  `id` VARCHAR(191) NOT NULL,
  `paymentId` VARCHAR(191) NULL,
  `provider` ENUM('PAYHERE', 'BANK_TRANSFER', 'CASH') NOT NULL,
  `eventType` VARCHAR(191) NOT NULL,
  `externalEventId` VARCHAR(191) NULL,
  `payloadHash` VARCHAR(191) NOT NULL,
  `status` VARCHAR(191) NOT NULL,
  `processedAt` DATETIME(3) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `PaymentEvent_provider_externalEventId_key` (`provider`, `externalEventId`),
  KEY `PaymentEvent_paymentId_idx` (`paymentId`),
  CONSTRAINT `PaymentEvent_paymentId_fkey` FOREIGN KEY (`paymentId`) REFERENCES `Payment` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 18. Table structure for `AvailabilityBlock`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `AvailabilityBlock`;
CREATE TABLE `AvailabilityBlock` (
  `id` VARCHAR(191) NOT NULL,
  `unitId` VARCHAR(191) NOT NULL,
  `startDate` DATE NOT NULL,
  `endDate` DATE NOT NULL,
  `reason` VARCHAR(191) NOT NULL,
  `notes` TEXT NULL,
  `createdById` VARCHAR(191) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `AvailabilityBlock_unitId_startDate_endDate_idx` (`unitId`, `startDate`, `endDate`),
  KEY `AvailabilityBlock_createdById_idx` (`createdById`),
  CONSTRAINT `AvailabilityBlock_unitId_fkey` FOREIGN KEY (`unitId`) REFERENCES `Unit` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 19. Table structure for `AdminUser`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `AdminUser`;
CREATE TABLE `AdminUser` (
  `id` VARCHAR(191) NOT NULL,
  `name` VARCHAR(191) NOT NULL,
  `email` VARCHAR(191) NOT NULL,
  `passwordHash` VARCHAR(191) NOT NULL,
  `role` ENUM('OWNER', 'MANAGER', 'STAFF', 'RECEPTION', 'HOUSEKEEPING', 'MAINTENANCE', 'ACCOUNTANT') NOT NULL DEFAULT 'STAFF',
  `active` BOOLEAN NOT NULL DEFAULT true,
  `lastLoginAt` DATETIME(3) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `AdminUser_email_key` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add createdById foreign key to AvailabilityBlock after AdminUser is created
ALTER TABLE `AvailabilityBlock` ADD CONSTRAINT `AvailabilityBlock_createdById_fkey` FOREIGN KEY (`createdById`) REFERENCES `AdminUser` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- ------------------------------------------------------------------------------
-- 20. Table structure for `AdminSession`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `AdminSession`;
CREATE TABLE `AdminSession` (
  `id` VARCHAR(191) NOT NULL,
  `adminUserId` VARCHAR(191) NOT NULL,
  `tokenHash` VARCHAR(191) NOT NULL,
  `ipAddress` VARCHAR(191) NULL,
  `userAgent` TEXT NULL,
  `expiresAt` DATETIME(3) NOT NULL,
  `revokedAt` DATETIME(3) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `lastSeenAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `AdminSession_tokenHash_key` (`tokenHash`),
  KEY `AdminSession_adminUserId_idx` (`adminUserId`),
  KEY `AdminSession_expiresAt_idx` (`expiresAt`),
  CONSTRAINT `AdminSession_adminUserId_fkey` FOREIGN KEY (`adminUserId`) REFERENCES `AdminUser` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 21. Table structure for `HousekeepingTask`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `HousekeepingTask`;
CREATE TABLE `HousekeepingTask` (
  `id` VARCHAR(191) NOT NULL,
  `propertyId` VARCHAR(191) NOT NULL,
  `unitId` VARCHAR(191) NOT NULL,
  `scheduledDate` DATE NOT NULL,
  `status` ENUM('DIRTY', 'ASSIGNED', 'CLEANING', 'READY', 'INSPECTED') NOT NULL DEFAULT 'DIRTY',
  `assignedToId` VARCHAR(191) NULL,
  `notes` VARCHAR(191) NULL,
  `completedAt` DATETIME(3) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `HousekeepingTask_unitId_scheduledDate_key` (`unitId`, `scheduledDate`),
  KEY `HousekeepingTask_unitId_scheduledDate_idx` (`unitId`, `scheduledDate`),
  KEY `HousekeepingTask_assignedToId_idx` (`assignedToId`),
  CONSTRAINT `HousekeepingTask_unitId_fkey` FOREIGN KEY (`unitId`) REFERENCES `Unit` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `HousekeepingTask_assignedToId_fkey` FOREIGN KEY (`assignedToId`) REFERENCES `AdminUser` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 22. Table structure for `MaintenanceIssue`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `MaintenanceIssue`;
CREATE TABLE `MaintenanceIssue` (
  `id` VARCHAR(191) NOT NULL,
  `propertyId` VARCHAR(191) NOT NULL,
  `unitId` VARCHAR(191) NULL,
  `title` VARCHAR(191) NOT NULL,
  `description` TEXT NULL,
  `status` ENUM('REPORTED', 'ASSIGNED', 'IN_PROGRESS', 'COMPLETED') NOT NULL DEFAULT 'REPORTED',
  `priority` ENUM('LOW', 'MEDIUM', 'HIGH', 'URGENT') NOT NULL DEFAULT 'MEDIUM',
  `assignedToId` VARCHAR(191) NULL,
  `reportedById` VARCHAR(191) NULL,
  `resolvedAt` DATETIME(3) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `MaintenanceIssue_status_idx` (`status`),
  KEY `MaintenanceIssue_unitId_idx` (`unitId`),
  KEY `MaintenanceIssue_assignedToId_idx` (`assignedToId`),
  KEY `MaintenanceIssue_reportedById_idx` (`reportedById`),
  CONSTRAINT `MaintenanceIssue_unitId_fkey` FOREIGN KEY (`unitId`) REFERENCES `Unit` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `MaintenanceIssue_assignedToId_fkey` FOREIGN KEY (`assignedToId`) REFERENCES `AdminUser` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `MaintenanceIssue_reportedById_fkey` FOREIGN KEY (`reportedById`) REFERENCES `AdminUser` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 23. Table structure for `AdminSetting`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `AdminSetting`;
CREATE TABLE `AdminSetting` (
  `id` VARCHAR(191) NOT NULL,
  `key` VARCHAR(191) NOT NULL,
  `value` JSON NULL,
  `updatedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `AdminSetting_key_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 24. Table structure for `AuditLog`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `AuditLog`;
CREATE TABLE `AuditLog` (
  `id` VARCHAR(191) NOT NULL,
  `adminUserId` VARCHAR(191) NULL,
  `action` VARCHAR(191) NOT NULL,
  `entityType` VARCHAR(191) NOT NULL,
  `entityId` VARCHAR(191) NULL,
  `oldValues` JSON NULL,
  `newValues` JSON NULL,
  `ipAddress` VARCHAR(191) NULL,
  `userAgent` VARCHAR(191) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `AuditLog_entityType_entityId_idx` (`entityType`, `entityId`),
  KEY `AuditLog_adminUserId_idx` (`adminUserId`),
  CONSTRAINT `AuditLog_adminUserId_fkey` FOREIGN KEY (`adminUserId`) REFERENCES `AdminUser` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 25. Table structure for `NotificationLog`
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `NotificationLog`;
CREATE TABLE `NotificationLog` (
  `id` VARCHAR(191) NOT NULL,
  `bookingId` VARCHAR(191) NULL,
  `recipient` VARCHAR(191) NOT NULL,
  `template` VARCHAR(191) NOT NULL,
  `status` VARCHAR(191) NOT NULL,
  `providerMessageId` VARCHAR(191) NULL,
  `errorMessage` VARCHAR(191) NULL,
  `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ==============================================================================
-- SAMPLE INITIAL SEED DATA
-- ==============================================================================

-- 1. Insert Initial Property
INSERT INTO `Property` (
  `id`, `name`, `slug`, `description`, `address`, `city`, `district`,
  `country`, `timezone`, `currency`, `phone`, `email`,
  `checkInTime`, `checkOutTime`, `taxPercentage`, `serviceChargePercentage`,
  `bankTransferInstructions`, `calendarFeedToken`, `active`
) VALUES (
  'prop_royalmansion001',
  'Royal Mansion Resort Villa',
  'royal-mansion-resort-villa',
  'A private luxury villa nestled in the lush misty hills of Pussallawa, Sri Lanka. Offering breathtaking panoramic views, heated infinity pool, dedicated butler, and bespoke chef services.',
  'Paradeka, Pussallawa',
  'Pussallawa',
  'Nuwara Eliya',
  'Sri Lanka',
  'Asia/Colombo',
  'LKR',
  '+94 77 123 4567',
  'hello@royalmansion.lk',
  '14:00',
  '11:00',
  0.00,
  10.00,
  'Bank: Commercial Bank of Ceylon PLC\nAccount Name: Royal Mansion Resort Villa\nAccount Number: 100023456789\nBranch: Kandy City Branch\nSwift Code: CCEYLKLX\nPlease email the deposit slip with your booking reference to reservations@royalmansion.lk.',
  'rm_feed_token_f93a827419bc44d18',
  1
) ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- 2. Insert Initial Unit (Entire Villa)
INSERT INTO `Unit` (
  `id`, `propertyId`, `name`, `slug`, `description`, `unitType`,
  `inventoryCount`, `bedrooms`, `bathrooms`, `baseOccupancy`,
  `maximumOccupancy`, `maximumAdults`, `maximumChildren`, `active`
) VALUES (
  'unit_entireresort001',
  'prop_royalmansion001',
  'Entire Villa',
  'entire-villa',
  'Exclusive private access to the entire 4-bedroom luxury estate, mountain infinity pool, private cinema lounge, billiard room, and manicured gardens.',
  'PRIVATE_VILLA',
  1,
  4,
  4,
  6,
  10,
  10,
  6,
  1
) ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- 3. Insert Amenities
INSERT INTO `Amenity` (`id`, `name`, `icon`, `active`) VALUES
('amenity_pool', 'Private pool', 'private-pool', 1),
('amenity_mountain', 'Mountain view', 'mountain-view', 1),
('amenity_wifi', 'High-Speed Wi-Fi', 'wifi', 1),
('amenity_chef', 'Private Chef on request', 'chef', 1),
('amenity_bbq', 'BBQ Pavilion', 'bbq', 1),
('amenity_games', 'Billiard & Games Room', 'games', 1),
('amenity_butler', '24/7 Butler Service', 'service', 1),
('amenity_parking', 'Free Secure Parking', 'parking', 1)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- 4. Map Unit Amenities
INSERT IGNORE INTO `UnitAmenity` (`unitId`, `amenityId`) VALUES
('unit_entireresort001', 'amenity_pool'),
('unit_entireresort001', 'amenity_mountain'),
('unit_entireresort001', 'amenity_wifi'),
('unit_entireresort001', 'amenity_chef'),
('unit_entireresort001', 'amenity_bbq'),
('unit_entireresort001', 'amenity_games'),
('unit_entireresort001', 'amenity_butler'),
('unit_entireresort001', 'amenity_parking');

-- 5. Insert Packages
INSERT INTO `Package` (
  `id`, `propertyId`, `unitId`, `name`, `slug`, `shortDescription`, `fullDescription`,
  `basePrice`, `pricingType`, `includedAdults`, `includedChildren`, `maximumGuests`,
  `minimumNights`, `maximumNights`, `depositPercentage`, `mealPlan`,
  `cancellationPolicy`, `terms`, `featured`, `active`, `displayOrder`
) VALUES
(
  'pkg_fullvilla001',
  'prop_royalmansion001',
  'unit_entireresort001',
  'Full Villa Stay',
  'full-villa-stay',
  'Exclusive full-estate villa accommodation for up to 10 guests.',
  'Experience complete tranquility with exclusive use of Royal Mansion. Enjoy panoramic views of the Pussallawa valley, personal butler assistance, daily housekeeping, and full kitchen facilities.',
  75000.00,
  'PER_NIGHT',
  6,
  0,
  10,
  1,
  21,
  50.00,
  'Room only (Chef available)',
  'Free cancellation up to 14 days before check-in. Within 14 days, deposit is non-refundable but transferable to future dates within 6 months.',
  'A 50% deposit is required via PayHere or Bank Transfer to confirm the reservation. Remaining balance is due at check-in.',
  1,
  1,
  1
),
(
  'pkg_family002',
  'prop_royalmansion001',
  'unit_entireresort001',
  'Family Weekend Package',
  'family-weekend-package',
  'All-inclusive weekend escape for families with complimentary breakfast.',
  'Designed for unforgettable family reunions. Includes daily artisanal breakfast, afternoon tea on the lawn, BBQ equipment setup, and board games.',
  95000.00,
  'PER_NIGHT',
  8,
  2,
  10,
  2,
  21,
  50.00,
  'Breakfast included',
  'Free date changes up to 7 days prior to check-in. Deposits reviewed on compassionate basis.',
  'Weekend minimum stay: 2 nights. Standard check-in 14:00, late check-out till 13:00 on Sunday subject to availability.',
  1,
  1,
  2
),
(
  'pkg_honeymoon003',
  'prop_royalmansion001',
  'unit_entireresort001',
  'Honeymoon Villa Package',
  'honeymoon-villa-package',
  'Romantic hillside sanctuary featuring candlelight dinner and spa setup.',
  'The ultimate intimate romantic getaway. Enjoy whole-villa privacy for two, floral bed decoration, candlelit terrace dinner, bottle of sparkling beverage, and daily gourmet breakfast.',
  45000.00,
  'PER_NIGHT',
  2,
  0,
  2,
  1,
  14,
  50.00,
  'Breakfast included + 1 Romantic Dinner',
  'Free cancellation up to 10 days before arrival.',
  'Ideal for couples and honeymooners. Exclusive privacy guaranteed.',
  0,
  1,
  3
) ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- 6. Insert Package Images
INSERT INTO `PackageImage` (`id`, `packageId`, `imageUrl`, `altText`, `displayOrder`) VALUES
('img_pkg1_1', 'pkg_fullvilla001', '/assets/room.jpg', 'Master Bedroom with Balcony View', 1),
('img_pkg1_2', 'pkg_fullvilla001', '/assets/gallery1.webp', 'Panoramic Mountain View from Pool', 2),
('img_pkg2_1', 'pkg_family002', '/assets/room.jpg', 'Spacious Family Suite', 1),
('img_pkg2_2', 'pkg_family002', '/assets/gallery1.webp', 'Spacious Garden & Living Lounge', 2),
('img_pkg3_1', 'pkg_honeymoon003', '/assets/room.jpg', 'Romantic Master Bedroom Setup', 1),
('img_pkg3_2', 'pkg_honeymoon003', '/assets/gallery1.webp', 'Private Sunset Terrace', 2)
ON DUPLICATE KEY UPDATE `imageUrl` = VALUES(`imageUrl`);

-- 7. Insert Package Amenities
INSERT IGNORE INTO `PackageAmenity` (`packageId`, `amenityId`) VALUES
('pkg_fullvilla001', 'amenity_pool'),
('pkg_fullvilla001', 'amenity_mountain'),
('pkg_fullvilla001', 'amenity_wifi'),
('pkg_fullvilla001', 'amenity_bbq'),
('pkg_fullvilla001', 'amenity_games'),
('pkg_family002', 'amenity_pool'),
('pkg_family002', 'amenity_mountain'),
('pkg_family002', 'amenity_wifi'),
('pkg_family002', 'amenity_chef'),
('pkg_family002', 'amenity_bbq'),
('pkg_family002', 'amenity_games'),
('pkg_honeymoon003', 'amenity_pool'),
('pkg_honeymoon003', 'amenity_mountain'),
('pkg_honeymoon003', 'amenity_wifi'),
('pkg_honeymoon003', 'amenity_chef'),
('pkg_honeymoon003', 'amenity_butler');

-- 8. Insert Seasonal Rates
INSERT INTO `SeasonalRate` (
  `id`, `packageId`, `name`, `startDate`, `endDate`,
  `nightlyPrice`, `weekendPrice`, `minimumNights`, `priority`, `active`
) VALUES
(
  'rate_aug_2026',
  'pkg_fullvilla001',
  'August Kandy Esala Perahera Season',
  '2026-08-01',
  '2026-08-31',
  90000.00,
  105000.00,
  2,
  10,
  1
),
(
  'rate_dec_2026',
  'pkg_fullvilla001',
  'December Peak Holiday Season',
  '2026-12-15',
  '2027-01-10',
  112500.00,
  125000.00,
  3,
  20,
  1
) ON DUPLICATE KEY UPDATE `nightlyPrice` = VALUES(`nightlyPrice`);

-- 9. Insert Add-ons
INSERT INTO `AddOn` (
  `id`, `propertyId`, `name`, `description`, `pricingType`, `price`, `maximumQuantity`, `active`
) VALUES
(
  'addon_breakfast',
  'prop_royalmansion001',
  'Gourmet Sri Lankan or English Breakfast',
  'Freshly cooked breakfast including tea/coffee, tropical fruits, and choice of Sri Lankan string hoppers or full English.',
  'PER_GUEST_PER_NIGHT',
  2500.00,
  10,
  1
),
(
  'addon_bbq',
  'prop_royalmansion001',
  'Hillside BBQ Feast with Chef',
  'Chef-curated live BBQ with marinated chicken, seafood, grilled corn, baked potatoes, and salads.',
  'PER_GUEST',
  4500.00,
  10,
  1
),
(
  'addon_airport_transfer',
  'prop_royalmansion001',
  'Airport Luxury Van Transfer (One-Way)',
  'Private AC luxury KDH van transfer between Bandaranaike International Airport (CMB) and Royal Mansion Resort.',
  'PER_BOOKING',
  35000.00,
  2,
  1
),
(
  'addon_decorations',
  'prop_royalmansion001',
  'Romantic Floral & Candlelight Decor',
  'Special anniversary or birthday setup with fresh roses, scented candles, and celebratory cake.',
  'PER_BOOKING',
  12000.00,
  1,
  1
) ON DUPLICATE KEY UPDATE `price` = VALUES(`price`);

-- 10. Insert Coupon
INSERT INTO `Coupon` (
  `id`, `code`, `description`, `discountType`, `discountValue`,
  `minimumBookingAmount`, `maximumDiscount`, `validFrom`, `validUntil`,
  `usageLimit`, `usageCount`, `active`
) VALUES (
  'coupon_direct10',
  'DIRECT10',
  'Direct website booking 10% discount',
  'PERCENTAGE',
  10.00,
  50000.00,
  25000.00,
  '2026-01-01',
  '2027-12-31',
  250,
  0,
  1
) ON DUPLICATE KEY UPDATE `discountValue` = VALUES(`discountValue`);

-- 11. Insert Default Admin User
-- Email: owner@royalmansion.lk
-- Password: ChangeMe123!
-- (Bcrypt hash: $2b$12$mLCU/xqnG9wSuNcEjg2Tb.gmMdPf38PgJEY2icwL0/0bSdKNVthwq)
INSERT INTO `AdminUser` (
  `id`, `name`, `email`, `passwordHash`, `role`, `active`, `createdAt`, `updatedAt`
) VALUES (
  'admin_owner_001',
  'Royal Mansion Owner',
  'owner@royalmansion.lk',
  '$2b$12$mLCU/xqnG9wSuNcEjg2Tb.gmMdPf38PgJEY2icwL0/0bSdKNVthwq',
  'OWNER',
  1,
  NOW(),
  NOW()
) ON DUPLICATE KEY UPDATE `passwordHash` = VALUES(`passwordHash`);

-- 12. Insert Default Admin Settings
INSERT INTO `AdminSetting` (`id`, `key`, `value`, `updatedAt`) VALUES
('setting_general', 'general_settings', '{"siteName":"Royal Mansion Resort Villa","contactEmail":"hello@royalmansion.lk","bookingHoldMinutes":15,"defaultCurrency":"LKR"}', NOW()),
('setting_pms', 'pms_rules', '{"autoAssignHousekeeping":true,"allowOverbooking":false,"notifyStaffOnBooking":true}', NOW())
ON DUPLICATE KEY UPDATE `value` = VALUES(`value`);

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;

-- ==============================================================================
-- DATABASE SETUP COMPLETE!
-- Admin Login:
-- URL: /admin/login
-- Email: owner@royalmansion.lk
-- Password: ChangeMe123!
-- ==============================================================================
