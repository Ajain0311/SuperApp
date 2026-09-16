import 'package:flutter/material.dart';
import 'package:super_app/core/theme/app_colors.dart';
import 'package:super_app/core/theme/app_text_styles.dart';
import 'package:super_app/features/marketplace/models/marketplace_models.dart';

class ListingDetailScreen extends StatefulWidget {
  final String listingId;

  const ListingDetailScreen({super.key, required this.listingId});

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  final PageController _pageController = PageController();
  int _activePhotoIndex = 0;
  bool _isFavorite = false;

  late ListingDetail _detail;

  @override
  void initState() {
    super.initState();
    _detail = _getDetailForId(widget.listingId);
    _isFavorite = _detail.isFavorite;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showMakeOfferDialog() {
    final offerController = TextEditingController(text: (_detail.price * 0.9).toStringAsFixed(0));
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Make an Offer', style: AppTextStyles.h3),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Listed price: ₹${_detail.price.toStringAsFixed(0)}',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: offerController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  prefixStyle: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold),
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  hintText: 'Enter your offer price',
                  hintStyle: const TextStyle(color: AppColors.textTertiary, fontSize: 14),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Offer of ₹${offerController.text} sent to ${_detail.sellerName}!'),
                        backgroundColor: AppColors.secondary,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Send Offer to Seller', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showContactOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Contact ${_detail.sellerName}', style: AppTextStyles.h3),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.phone_rounded, color: AppColors.secondary),
                ),
                title: const Text('Call Seller Directly', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(_detail.sellerPhone ?? '+91 98765 43210', style: const TextStyle(color: AppColors.textSecondary)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Calling ${_detail.sellerPhone}...'), backgroundColor: AppColors.surfaceLight),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.blue.withValues(alpha: 0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.chat_bubble_rounded, color: AppColors.blue),
                ),
                title: const Text('Chat in SuperApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text('Fast responses, secure and in-app', style: TextStyle(color: AppColors.textSecondary)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening encrypted chat with ${_detail.sellerName}...'), backgroundColor: AppColors.surfaceLight),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Photo Carousel
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: AppColors.background.withValues(alpha: 0.7), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: AppColors.background.withValues(alpha: 0.7), shape: BoxShape.circle),
                  child: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Listing link copied to clipboard!'), backgroundColor: AppColors.surfaceLight),
                  );
                },
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: AppColors.background.withValues(alpha: 0.7), shape: BoxShape.circle),
                  child: Icon(
                    _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: _isFavorite ? AppColors.red : Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isFavorite ? 'Saved to Favorites ❤️' : 'Removed from Favorites'),
                      duration: const Duration(seconds: 1),
                      backgroundColor: AppColors.surfaceLight,
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: _detail.images.length,
                    onPageChanged: (idx) {
                      setState(() {
                        _activePhotoIndex = idx;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.network(
                        _detail.images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.surfaceLight,
                          child: const Center(
                            child: Icon(Icons.broken_image_rounded, size: 48, color: AppColors.textTertiary),
                          ),
                        ),
                      );
                    },
                  ),
                  // Gradient Shade at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.background.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Photo Indicator Dots
                  if (_detail.images.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_detail.images.length, (index) {
                          final isActive = index == _activePhotoIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            height: 6,
                            width: isActive ? 20 : 6,
                            decoration: BoxDecoration(
                              color: isActive ? AppColors.primary : Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Content Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price and Negotiation Badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '₹${_detail.price.toStringAsFixed(0)}',
                        style: AppTextStyles.h1.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
                        ),
                        child: const Text(
                          'Negotiable',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Views
                      Row(
                        children: [
                          const Icon(Icons.visibility_outlined, size: 14, color: AppColors.textTertiary),
                          const SizedBox(width: 4),
                          Text(
                            '${_detail.viewCount} views',
                            style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Title
                  Text(
                    _detail.title,
                    style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w700, height: 1.25),
                  ),
                  const SizedBox(height: 12),

                  // Location and Category line
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _detail.categoryName,
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _detail.condition,
                          style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 2),
                      Text(
                        _detail.location ?? 'Bengaluru',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 16),

                  // Specifications Grid Chips
                  Text('Highlights', style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSpecChip(Icons.verified_rounded, 'Authentic Guaranteed'),
                      _buildSpecChip(Icons.inventory_2_outlined, 'Original Bill & Box'),
                      _buildSpecChip(Icons.local_shipping_outlined, 'Self Pickup / Handover'),
                      _buildSpecChip(Icons.access_time_rounded, 'Fast Response Seller'),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 16),

                  // Description
                  Text('Description', style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      _detail.description ?? 'No description provided.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 16),

                  // Seller Info Card
                  Text('Seller Profile', style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: AppColors.surfaceLight,
                              backgroundImage: _detail.sellerAvatar != null
                                  ? NetworkImage(_detail.sellerAvatar!)
                                  : null,
                              child: _detail.sellerAvatar == null
                                  ? const Icon(Icons.person, color: AppColors.textSecondary)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        _detail.sellerName,
                                        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.verified_rounded, color: AppColors.secondary, size: 16),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Active member • 4.9 ★ (28 deals closed)',
                                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: AppColors.divider),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _showContactOptions,
                                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Colors.white),
                                label: const Text('Chat', style: TextStyle(color: Colors.white)),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.border),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _showContactOptions,
                                icon: const Icon(Icons.call_rounded, size: 16, color: Colors.white),
                                label: const Text('Call', style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.surfaceLight,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Safety Advice Box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.security_rounded, color: AppColors.secondary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Safety Guidelines for Buyers',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Always meet in public places, inspect the goods thoroughly in person, and never pay advance booking amounts.',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Persistent Bottom Action Bar
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        decoration: const BoxDecoration(
          color: AppColors.cardDark,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: _showContactOptions,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Chat',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _showMakeOfferDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Make an Offer',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.secondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  ListingDetail _getDetailForId(String id) {
    // Standard mock mapping based on ID
    if (id == '102') {
      return ListingDetail(
        id: 102,
        title: 'Royal Enfield Classic 350 (2022 Stealth Black)',
        description: 'Single owner, only 12,000 km driven. First party comprehensive insurance valid till November 2027. Regularly serviced at authorized service center. Includes luggage rack and touring seat.',
        price: 145000,
        condition: 'Gently Used',
        location: 'Indiranagar, Bengaluru',
        status: 'ACTIVE',
        isFeatured: true,
        viewCount: 310,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        categoryId: 2,
        categoryName: 'Vehicles',
        sellerId: 2,
        sellerName: 'Vikram Singh',
        sellerPhone: '+91 98451 23456',
        sellerAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        sellerJoinedAt: DateTime(2023, 5, 12),
        isFavorite: true,
        images: [
          'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=700',
          'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=700',
        ],
      );
    }

    if (id == '103') {
      return ListingDetail(
        id: 103,
        title: 'Sony PlayStation 5 Disc Edition + 2 Controllers',
        description: 'Disc edition PS5 bought 6 months ago. Barely used due to busy schedule. Includes 2 wireless DualSense controllers, HDMI cable, power cable, and original retail box. Zero scratches.',
        price: 38500,
        condition: 'Like New',
        location: 'HSR Layout, Bengaluru',
        status: 'ACTIVE',
        isFeatured: false,
        viewCount: 98,
        createdAt: DateTime.now().subtract(const Duration(hours: 18)),
        categoryId: 3,
        categoryName: 'Electronics',
        sellerId: 3,
        sellerName: 'Rohit Verma',
        sellerPhone: '+91 99887 76655',
        sellerAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
        sellerJoinedAt: DateTime(2024, 1, 10),
        isFavorite: false,
        images: [
          'https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=700',
          'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=700',
        ],
      );
    }

    // Default iPhone 14 Pro Max or generic
    return ListingDetail(
      id: 101,
      title: 'iPhone 14 Pro Max 256GB Deep Purple (Like New)',
      description: 'Battery health 94%. Flawless screen protected by Spigen tempered glass since day one. Comes with Apple original box, USB-C to lightning braided cable, and purchase invoice from Apple BKC. Reason for selling: Upgraded to newer device.',
      price: 68000,
      condition: 'Like New',
      location: 'Koramangala, Bengaluru',
      status: 'ACTIVE',
      isFeatured: true,
      viewCount: 142,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      categoryId: 1,
      categoryName: 'Mobiles',
      sellerId: 1,
      sellerName: 'Aditya Sharma',
      sellerPhone: '+91 98765 43210',
      sellerAvatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
      sellerJoinedAt: DateTime(2023, 9, 20),
      isFavorite: false,
      images: [
        'https://images.unsplash.com/photo-1591337676887-a217a6970a8a?w=700',
        'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?w=700',
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=700',
      ],
    );
  }
}
