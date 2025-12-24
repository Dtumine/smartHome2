import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Estilos de texto con Inter aplicada automáticamente
class AppTextStyles {
  // Headlines
  static TextStyle headlineLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle headlineMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle headlineSmall({Color? color}) => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  // Titles
  static TextStyle titleLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle titleMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle titleSmall({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      );

  // Body
  static TextStyle bodyLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle bodyMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        color: color ?? AppColors.textSecondary,
      );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        color: color ?? AppColors.textSecondary,
      );

  // Labels
  static TextStyle labelLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      );

  static TextStyle labelMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textSecondary,
      );

  static TextStyle labelSmall({Color? color}) => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textSecondary,
      );

  // Helper para aplicar Inter a cualquier TextStyle existente
  static TextStyle withInter(TextStyle style) {
    return GoogleFonts.inter(
      fontSize: style.fontSize,
      fontWeight: style.fontWeight,
      color: style.color,
      letterSpacing: style.letterSpacing,
      height: style.height,
      decoration: style.decoration,
      decorationColor: style.decorationColor,
    );
  }
}

