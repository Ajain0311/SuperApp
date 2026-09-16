import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_app/core/theme/app_colors.dart';
import 'package:super_app/features/food/widgets/cart_summary_sheet.dart';
import 'package:super_app/features/food/widgets/item_customization_sheet.dart';
import 'package:super_app/shared/widgets/rating_badge.dart';
import 'package:super_app/shared/widgets/veg_badge.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailScreen({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _menuCategories = ['All', 'Biryani Specials', 'Starters', 'Desserts'];

  final List<Map<String, dynamic>> _foodItems = [
    {
      'id': 1,
      'name': 'Meghana Special Chicken Biryani',
      'category': 'Biryani Specials',
      'price': 340.0,
      'description': 'Fragrant Basmati rice topped with boneless spiced chicken marinated in Andhra green chili paste.',
      'isVeg': false,
      'isBestseller': true,
      'isCustomizable': true,
      'image': 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=300',
    },
    {
      'id': 2,
      'name': 'Paneer 65 Biryani (Dum Style)',
      'category': 'Biryani Specials',
      'price': 290.0,
      'description': 'Spiced golden paneer cubes layered with saffron long grain basmati rice.',
      'isVeg': true,
      'isBestseller': true,
      'isCustomizable': true,
      'image': 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=300',
    },
    {
      'id': 3,
      'name': 'Crispy Boneless Chicken 65',
      'category': 'Starters',
      'price': 310.0,
      'description': 'Tender chicken bites tossed with south curry leaves, mustard seeds, and Andhra red chili glaze.',
      'isVeg': false,
      'isBestseller': true,
      'isCustomizable': false,
      'image': 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?w=300',
    },
    {
      'id': 4,
      'name': 'Apollo Fish Fry',
      'category': 'Starters',
      'price': 360.0,
      'description': 'Flaky fillets fried crisp and tossed in spiced yogurt seasoning.',
      'isVeg': false,
      'isBestseller': false,
      'isCustomizable': false,
      'image': 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=300',
    },
    {
      'id': 5,
      'name': 'Gulab Jamun with Rabri',
      'category': 'Desserts',
      'price': 110.0,
      'description': 'Warm reduced milk dumplings served with chilled saffron rabri.',
      'isVeg': true,
      'isBestseller': false,
      'isCustomizable': false,
      'image': 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=300',
    },
  ];

  final List<Map<String, dynamic>> _cartItems = [];

  void _openCustomizationSheet(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ItemCustomizationSheet(
        itemName: item['name'] as String,
        basePrice: item['price'] as double,
        onAddToCart: (quantity, portion, portionPrice, addons, total) {
          setState(() {
            _cartItems.add({
              'id': item['id'],
              'name': item['name'],
              'price': item['price'],
              'quantity': quantity,
              'portion': portion,
              'addons': addons,
              'totalPrice': total,
            });
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added ${item['name']} to cart!'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }

  void _openCartSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CartSummarySheet(
        restaurantName: 'Meghana Foods (Special Biryani)',
        cartItems: _cartItems,
        onClear: () {
          setState(() => _cartItems.clear());
        },
        onOrderPlaced: () {
          setState(() => _cartItems.clear());
          context.push('/food/order-tracking/FO-1002');
        },
      ),
    );
  }

  double get _cartTotal {
    double sum = 0;
    for (var c in _cartItems) {
      sum += (c['totalPrice'] as double);
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategoryIndex == 0
        ? _foodItems
        : _foodItems.where((f) => f['category'] == _menuCategories[_selectedCategoryIndex]).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meghana Foods (Special Biryani)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Biryani • Hyderabadi • Andhra • Kebabs • ₹500 for two • 22m',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: RatingBadge(rating: 4.6),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search dishes
                Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search_rounded, color: AppColors.textTertiary, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Search dishes...',
                        style: TextStyle(color: AppColors.textHint, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                // Category Pills
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_menuCategories.length, (index) {
                      final isSelected = index == _selectedCategoryIndex;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedCategoryIndex = index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.border,
                              ),
                            ),
                            child: Text(
                              _menuCategories[index],
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 18),
                // Dishes List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return _buildFoodItemCard(item);
                  },
                ),
                const SizedBox(height: 100), // Space for cart floating bar
              ],
            ),
          ),
          // Floating Cart Bar
          if (_cartItems.isNotEmpty)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: GestureDetector(
                onTap: _openCartSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${_cartItems.length} ITEM${_cartItems.length > 1 ? 'S' : ''}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                          Text(
                            '₹${_cartTotal.toStringAsFixed(0)} plus taxes',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            'View Cart',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFoodItemCard(Map<String, dynamic> item) {
    final isCustomizable = item['isCustomizable'] as bool;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    VegBadge(isVeg: item['isVeg'] as bool),
                    if (item['isBestseller'] == true) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.yellow.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'BESTSELLER',
                          style: TextStyle(
                            color: AppColors.yellow,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item['name'] as String,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${(item['price'] as double).toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item['description'] as String,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Right Image + ADD Button
          Column(
            children: [
              Container(
                width: 96,
                height: 84,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.surfaceLight,
                  image: DecorationImage(
                    image: NetworkImage(item['image'] as String),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  if (isCustomizable) {
                    _openCustomizationSheet(item);
                  } else {
                    setState(() {
                      _cartItems.add({
                        'id': item['id'],
                        'name': item['name'],
                        'price': item['price'],
                        'quantity': 1,
                        'portion': '',
                        'addons': <String>[],
                        'totalPrice': item['price'] as double,
                      });
                    });
                  }
                },
                child: Container(
                  width: 96,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary, width: 1.5),
                  ),
                  child: const Center(
                    child: Text(
                      'ADD +',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
              if (isCustomizable) ...[
                const SizedBox(height: 3),
                Text(
                  'CUSTOMISABLE',
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
