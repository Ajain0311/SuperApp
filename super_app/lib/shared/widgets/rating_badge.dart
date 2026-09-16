import 'package:flutter/material.dart';
import 'package:super_app/core/theme/app_colors.dart';

class RatingBadge extends StatelessWidget {
  final double rating;
  final double fontSize;
  final double iconSize;

  const RatingBadge({
    super.key,
    required this.rating,
    this.fontSize = 12,
    this.iconSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: Colors.white, size: iconSize),
          const SizedBox(width: 2),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
