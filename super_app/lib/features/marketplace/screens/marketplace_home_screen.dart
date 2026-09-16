import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_app/core/theme/app_colors.dart';
import 'package:super_app/core/theme/app_text_styles.dart';
import 'package:super_app/features/marketplace/models/marketplace_models.dart';
import 'package:super_app/shared/widgets/app_search_bar.dart';

class MarketplaceHomeScreen extends StatefulWidget {
  const MarketplaceHomeScreen({super.key});

  @override
  State<MarketplaceHomeScreen> createState() => _MarketplaceHomeScreenState();
}

class _MarketplaceHomeScreenState extends State<MarketplaceHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryId = 0; // 0 = All
  String _selectedFilter = 'All';

  final List<MarketplaceCategory> _categories = const [
    MarketplaceCategory(id: 0, name: 'All'),
    MarketplaceCategory(id: 1, name: 'Mobiles'),
    MarketplaceCategory(id: 2, name: 'Vehicles'),
    MarketplaceCategory(id: 3, name: 'Electronics'),
    MarketplaceCategory(id: 4, name: 'Furniture'),
    MarketplaceCategory(id: 5, name: 'Fashion'),
    MarketplaceCategory(id: 6, name: 'Books'),
    MarketplaceCategory(id: 7, name: 'Sports'),
    MarketplaceCategory(id: 8, name: 'Others'),
  ];

  late List<ListingSummary> _allListings;
  late List<ListingSummary> _filteredListings;

  @override
  void initState() {
    super.initState();
    _allListings = _getInitialListings();
    _filteredListings = List.from(_allListings);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilter() {
    setState(() {
      final query = _searchController.text.trim().toLowerCase();
      _filteredListings = _allListings.where((item) {
        final matchesCategory = _selectedCategoryId == 0 || item.categoryId == _selectedCategoryId;
        final matchesQuery = query.isEmpty ||
            item.title.toLowerCase().contains(query) ||
            (item.location?.toLowerCase().contains(query) ?? false);

        bool matchesFilter = true;
        if (_selectedFilter == 'Featured') {
          matchesFilter = item.isFeatured;
        } else if (_selectedFilter == 'Under ₹10k') {
          matchesFilter = item.price <= 10000;
        } else if (_selectedFilter == 'Like New') {
          matchesFilter = item.condition == 'LIKE_NEW' || item.condition == 'NEW';
        }

        return matchesCategory && matchesQuery && matchesFilter;
      }).toList();
    });
  }

  void _toggleFavorite(int listingId) {
    setState(() {
      _allListings = _allListings.map((item) {
        if (item.id == listingId) {
          final updated = item.copyWith(isFavorite: !item.isFavorite);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                updated.isFavorite ? 'Saved to Favorites ❤️' : 'Removed from Favorites',
              ),
              duration: const Duration(seconds: 1),
              backgroundColor: AppColors.surfaceLight,
            ),
          );
          return updated;
        }
        return item;
      }).toList();
      _applyFilter();
    });
  }

  IconData _getCategoryIcon(String name) {
    switch (name) {
      case 'Mobiles':
        return Icons.phone_iphone_rounded;
      case 'Vehicles':
        return Icons.two_wheeler_rounded;
      case 'Electronics':
        return Icons.laptop_mac_rounded;
      case 'Furniture':
        return Icons.chair_rounded;
      case 'Fashion':
        return Icons.checkroom_rounded;
      case 'Books':
        return Icons.menu_book_rounded;
      case 'Sports':
        return Icons.fitness_center_rounded;
      case 'Others':
        return Icons.category_rounded;
      default:
        return Icons.grid_view_rounded;
    }
  }

  Color _getConditionColor(String condition) {
    switch (condition.toUpperCase()) {
      case 'NEW':
        return AppColors.blue;
      case 'LIKE_NEW':
        return AppColors.secondary;
      case 'USED':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatConditionText(String condition) {
    switch (condition.toUpperCase()) {
      case 'LIKE_NEW':
        return 'LIKE NEW';
      case 'NEW':
        return 'BRAND NEW';
      case 'USED':
        return 'GENTLY USED';
      default:
        return condition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await context.push<ListingSummary>('/bazaar/add');
          if (result != null) {
            setState(() {
              _allListings.insert(0, result);
              _applyFilter();
            });
          }
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
        icon: const Icon(Icons.camera_alt_rounded, size: 20),
        label: const Text(
          'Sell Item',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Header & Top Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                                    ),
                                    child: const Text(
                                      'SUPER BAZAAR',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.verified_user_rounded, color: AppColors.secondary, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Verified Local Sellers',
                                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Community Marketplace',
                                style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Safety tip: Meet sellers in well-lit public spots!'),
                                  backgroundColor: AppColors.surfaceLight,
                                ),
                              );
                            },
                            icon: const Icon(Icons.shield_outlined, color: AppColors.textSecondary),
                            tooltip: 'Safety & Trust',
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Search Bar
                      AppSearchBar(
                        controller: _searchController,
                        hintText: 'Search pre-loved phones, bikes, sofas...',
                        onChanged: (val) => _applyFilter(),
                      ),
                    ],
                  ),
                ),
              ),

              // Category Pills Carousel
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category.id == _selectedCategoryId;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryId = category.id;
                            _applyFilter();
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.cardDark,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.border,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getCategoryIcon(category.name),
                                size: 16,
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                category.name,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Quick Filter Chips Row
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      _buildQuickFilterChip('All'),
                      const SizedBox(width: 8),
                      _buildQuickFilterChip('Featured'),
                      const SizedBox(width: 8),
                      _buildQuickFilterChip('Under ₹10k'),
                      const SizedBox(width: 8),
                      _buildQuickFilterChip('Like New'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: _filteredListings.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 600));
                    setState(() {
                      _allListings = _getInitialListings();
                      _applyFilter();
                    });
                  },
                  color: AppColors.primary,
                  backgroundColor: AppColors.cardDark,
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: _filteredListings.length,
                    itemBuilder: (context, index) {
                      final item = _filteredListings[index];
                      return _buildProductCard(item);
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildQuickFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
          _applyFilter();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceLight : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border.withValues(alpha: 0.6),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(ListingSummary item) {
    final conditionColor = _getConditionColor(item.condition);

    return GestureDetector(
      onTap: () {
        context.push('/bazaar/detail/${item.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.isFeatured ? AppColors.primary.withValues(alpha: 0.5) : AppColors.border,
            width: item.isFeatured ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: AspectRatio(
                    aspectRatio: 1.15,
                    child: Image.network(
                      item.primaryImageUrl ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.surfaceLight,
                        child: const Center(
                          child: Icon(Icons.image_not_supported_rounded, color: AppColors.textTertiary, size: 36),
                        ),
                      ),
                    ),
                  ),
                ),
                // Featured Ribbon
                if (item.isFeatured)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'FEATURED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                // Favorite Heart Button
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () => _toggleFavorite(item.id),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.background.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: item.isFavorite ? AppColors.red : Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                // Condition Tag
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: conditionColor.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      _formatConditionText(item.condition),
                      style: TextStyle(
                        color: conditionColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Card Body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price
                        Text(
                          '₹${item.price.toStringAsFixed(0)}',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Title
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                    // Location & Category
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textTertiary),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            item.location ?? 'Bangalore',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textTertiary,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textTertiary),
            ),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Try changing keywords or clearing the category filter',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _selectedCategoryId = 0;
                  _selectedFilter = 'All';
                  _applyFilter();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceLight,
                foregroundColor: AppColors.primary,
              ),
              child: const Text('Reset All Filters'),
            ),
          ],
        ),
      ),
    );
  }

  List<ListingSummary> _getInitialListings() {
    return [
      ListingSummary(
        id: 101,
        title: 'iPhone 14 Pro Max 256GB Deep Purple (Like New)',
        price: 68000,
        condition: 'LIKE_NEW',
        location: 'Koramangala, Bengaluru',
        primaryImageUrl: 'https://images.unsplash.com/photo-1591337676887-a217a6970a8a?w=500',
        isFeatured: true,
        viewCount: 142,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        categoryId: 1,
        categoryName: 'Mobiles',
        isFavorite: false,
      ),
      ListingSummary(
        id: 102,
        title: 'Royal Enfield Classic 350 (2022 Stealth Black)',
        price: 145000,
        condition: 'USED',
        location: 'Indiranagar, Bengaluru',
        primaryImageUrl: 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=500',
        isFeatured: true,
        viewCount: 310,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        categoryId: 2,
        categoryName: 'Vehicles',
        isFavorite: true,
      ),
      ListingSummary(
        id: 103,
        title: 'Sony PlayStation 5 Disc Edition + 2 Controllers',
        price: 38500,
        condition: 'LIKE_NEW',
        location: 'HSR Layout, Bengaluru',
        primaryImageUrl: 'https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=500',
        isFeatured: false,
        viewCount: 98,
        createdAt: DateTime.now().subtract(const Duration(hours: 18)),
        categoryId: 3,
        categoryName: 'Electronics',
        isFavorite: false,
      ),
      ListingSummary(
        id: 104,
        title: 'Solid Sheesham Teak Wood 6-Seater Dining Table',
        price: 22000,
        condition: 'USED',
        location: 'Whitefield, Bengaluru',
        primaryImageUrl: 'https://images.unsplash.com/photo-1617806118233-18e1de247200?w=500',
        isFeatured: false,
        viewCount: 74,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        categoryId: 4,
        categoryName: 'Furniture',
        isFavorite: false,
      ),
      ListingSummary(
        id: 105,
        title: 'Canon EOS 200D II DSLR with 18-55mm IS STM Lens',
        price: 32000,
        condition: 'LIKE_NEW',
        location: 'Jayanagar, Bengaluru',
        primaryImageUrl: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=500',
        isFeatured: false,
        viewCount: 112,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        categoryId: 3,
        categoryName: 'Electronics',
        isFavorite: false,
      ),
      ListingSummary(
        id: 106,
        title: 'Zara Genuine Leather Biker Jacket (Black - Size M)',
        price: 3999,
        condition: 'NEW',
        location: 'MG Road, Bengaluru',
        primaryImageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500',
        isFeatured: false,
        viewCount: 65,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        categoryId: 5,
        categoryName: 'Fashion',
        isFavorite: false,
      ),
    ];
  }
}
