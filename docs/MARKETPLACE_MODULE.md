# Marketplace (Bazaar) Module Documentation

The Bazaar module allows users to buy and sell items within the community.

## 1. Listing Flow
- **Browsing**: Users browse items via category chips (Electronics, Furniture, Vehicles, Fashion) or search bar.
- **Listing View**: A 2-column masonry or grid layout showing product image, price badge, title, and location.
- **Detail View**: Tapping a product shows a carousel of images, detailed description, condition, and seller info.
- **Add Listing**: Users can tap a FAB to add a listing, uploading images, setting price, category, and location.

## 2. Listing States
Listings have the following lifecycle states:
- `ACTIVE`: Visible to all users on the platform.
- `SOLD`: Item has been sold, kept for historical reference.
- `EXPIRED`: Listing has surpassed its validity period (e.g., 30 days).
- `REMOVED`: Deleted by the user or an admin (due to policy violation).

## 3. Seller Verification
To maintain trust, users must have a `MARKETPLACE_SELLER` role to list items (or this role is automatically granted upon phone verification).
- Basic sellers: Phone verified.
- Verified sellers: Verified by admins (blue tick).

## 4. Image Upload
- **Client-Side**: Compress images before upload to save bandwidth. Allow up to 5 images per listing.
- **Storage**: Store images in a cloud bucket (e.g., S3, Cloudinary) or locally in `public/uploads` for dev.
- **Database**: Store image URLs as a JSON array or in a related database table.

## 5. Favorites
- Users can "heart" or save listings.
- Saved listings are accessible in the Profile section.

## 6. Future Implementations
- **Real-time Chat**: Allow buyers and sellers to communicate securely in-app without revealing personal phone numbers.
- **In-App Payments**: Escrow payments for secure transactions.
