import 'package:flutter/material.dart';
import 'package:super_app/core/theme/app_colors.dart';

class InAppNotification {
  final String title;
  final String message;
  final String module;
  final DateTime timestamp;

  const InAppNotification({
    required this.title,
    required this.message,
    required this.module,
    required this.timestamp,
  });
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  /// Show standard themed in-app alert banner
  void showAppAlert(BuildContext context, {
    required String title,
    required String message,
    Color? accentColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
            ),
            const SizedBox(height: 2),
            Text(
              message,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        backgroundColor: AppColors.cardDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: accentColor ?? AppColors.primary, width: 1.2),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
