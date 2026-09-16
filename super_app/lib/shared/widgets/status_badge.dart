import 'package:flutter/material.dart';
import 'package:super_app/core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;

  const StatusBadge({
    super.key,
    required this.text,
    this.color,
    this.textColor,
  });

  Color get _color {
    if (color != null) return color!;
    switch (text.toUpperCase()) {
      case 'PENDING':
      case 'REQUESTED':
        return AppColors.yellow;
      case 'ACCEPTED':
      case 'ASSIGNED':
      case 'PREPARING':
      case 'ARRIVING':
        return AppColors.blue;
      case 'READY':
      case 'STARTED':
      case 'PICKED_UP':
        return AppColors.primary;
      case 'DELIVERED':
      case 'COMPLETED':
        return AppColors.success;
      case 'CANCELLED':
        return AppColors.error;
      case 'ACTIVE':
        return AppColors.success;
      case 'SOLD':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text.replaceAll('_', ' '),
        style: TextStyle(
          color: textColor ?? _color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
