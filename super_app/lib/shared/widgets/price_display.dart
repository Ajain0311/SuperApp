import 'package:flutter/material.dart';
import 'package:super_app/core/constants/app_constants.dart';
import 'package:super_app/core/theme/app_colors.dart';
import 'package:super_app/core/theme/app_text_styles.dart';

class PriceDisplay extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final double fontSize;

  const PriceDisplay({
    super.key,
    required this.price,
    this.originalPrice,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = originalPrice != null && originalPrice! > price;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '${AppConstants.currency}${price.toStringAsFixed(0)}',
          style: AppTextStyles.price.copyWith(fontSize: fontSize),
        ),
        if (hasDiscount) ...[
          const SizedBox(width: 6),
          Text(
            '${AppConstants.currency}${originalPrice!.toStringAsFixed(0)}',
            style: AppTextStyles.priceStrike.copyWith(
              fontSize: fontSize * 0.75,
            ),
          ),
        ],
      ],
    );
  }
}
