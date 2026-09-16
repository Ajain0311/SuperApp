import 'package:flutter/material.dart';
import 'package:super_app/core/theme/app_colors.dart';

class ItemCustomizationSheet extends StatefulWidget {
  final String itemName;
  final double basePrice;
  final Function(int quantity, String portionName, double portionPrice, List<String> addons, double grandTotal) onAddToCart;

  const ItemCustomizationSheet({
    super.key,
    required this.itemName,
    required this.basePrice,
    required this.onAddToCart,
  });

  @override
  State<ItemCustomizationSheet> createState() => _ItemCustomizationSheetState();
}

class _ItemCustomizationSheetState extends State<ItemCustomizationSheet> {
  int _quantity = 1;
  int _selectedPortionIndex = 0;

  final List<Map<String, dynamic>> _portions = [
    {'name': 'Regular Portion', 'price': 0.0, 'label': 'Included'},
    {'name': 'Jumbo Pack (Serves 3)', 'price': 210.0, 'label': '+₹210'},
  ];

  final List<Map<String, dynamic>> _addons = [
    {'name': 'Boondi Raita Bowl', 'price': 35.0, 'selected': false},
    {'name': 'Extra Mirchi Ka Salan', 'price': 45.0, 'selected': false},
  ];

  double get _calculatedTotal {
    double portionPrice = _portions[_selectedPortionIndex]['price'] as double;
    double addonsTotal = 0;
    for (var a in _addons) {
      if (a['selected'] == true) {
        addonsTotal += (a['price'] as double);
      }
    }
    return (widget.basePrice + portionPrice + addonsTotal) * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.itemName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Base: ₹${widget.basePrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          // Choose Portion
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              'CHOOSE PORTION',
              style: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
          ),
          ...List.generate(_portions.length, (index) {
            final p = _portions[index];
            final isSelected = index == _selectedPortionIndex;
            return InkWell(
              onTap: () => setState(() => _selectedPortionIndex = index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.surfaceLight : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.5) : AppColors.border.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        p['name'] as String,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      p['label'] as String,
                      style: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          // Add-ons
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              'ADD-ONS',
              style: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
          ),
          ...List.generate(_addons.length, (index) {
            final a = _addons[index];
            final isChecked = a['selected'] as bool;
            return InkWell(
              onTap: () => setState(() => a['selected'] = !isChecked),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isChecked ? AppColors.surfaceLight : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isChecked ? AppColors.primary.withValues(alpha: 0.5) : AppColors.border.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isChecked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                      color: isChecked ? AppColors.primary : AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        a['name'] as String,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: isChecked ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '+₹${(a['price'] as double).toStringAsFixed(0)}',
                      style: TextStyle(
                        color: isChecked ? AppColors.primary : AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 18),
          // Bottom Bar (Stepper + Add Button)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Row(
              children: [
                // Stepper
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, color: AppColors.textPrimary, size: 18),
                        onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                      ),
                      Text(
                        '$_quantity',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: AppColors.primary, size: 18),
                        onPressed: () => setState(() => _quantity++),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Add Item Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final selectedAddons = _addons
                          .where((a) => a['selected'] == true)
                          .map((a) => a['name'] as String)
                          .toList();
                      widget.onAddToCart(
                        _quantity,
                        _portions[_selectedPortionIndex]['name'] as String,
                        _portions[_selectedPortionIndex]['price'] as double,
                        selectedAddons,
                        _calculatedTotal,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Add Item    ₹${_calculatedTotal.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
