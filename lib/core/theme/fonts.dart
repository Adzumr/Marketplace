import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFont {
  static final AppFont instance = AppFont._internal();

  factory AppFont() {
    return instance;
  }

  AppFont._internal();

  /// Headline Font Styles
  final TextStyle headlineLarge = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );
  final TextStyle headlineMedium = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w400,
  );
  final TextStyle headlineSmall = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );

  /// Title Font Styles
  final TextStyle titleLarge = GoogleFonts.playfair(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  final TextStyle titleMedium = GoogleFonts.playfair(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
  final TextStyle titleSmall = GoogleFonts.playfair(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.10,
  );

  /// Body Font Styles
  final TextStyle bodyLarge = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  final TextStyle bodyMedium = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  final TextStyle bodySmall = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  /// Label Font Styles
  final TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  final TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  final TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.50,
  );
}
