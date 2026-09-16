import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_app/core/theme/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Price styles
  static TextStyle price = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle priceSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle priceStrike = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    decoration: TextDecoration.lineThrough,
  );

  static TextStyle badge = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle sectionTitle = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static TextStyle h1 = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static TextStyle h2 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle h3 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle moduleTitle = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  );

  static TextStyle moduleSubtitle = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: Colors.white70,
  );
}
