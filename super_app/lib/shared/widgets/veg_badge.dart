import 'package:flutter/material.dart';
import 'package:super_app/core/theme/app_colors.dart';

class VegBadge extends StatelessWidget {
  final bool isVeg;
  final double size;

  const VegBadge({super.key, required this.isVeg, this.size = 16});

  @override
  Widget build(BuildContext context) {
    final color = isVeg ? AppColors.vegBadge : AppColors.nonVegBadge;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Container(
          width: size * 0.45,
          height: size * 0.45,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
