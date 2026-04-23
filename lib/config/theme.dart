import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// RaktSetu Pro Max Design System
/// A vibrant, high-fidelity visual language for premium health-tech applications.
class RaktSetuTheme {
  RaktSetuTheme._();

  // Vibrant Color Palette
  static const Color primaryRed = Color(0xFFFF2D55); // Vibrant Apple-style Red
  static const Color primaryDark = Color(0xFF8B0000);
  static const Color primaryLight = Color(0xFFFFE5E9);
  static const Color accentRose = Color(0xFFFF6B6B);
  static const Color accentGold = Color(0xFFFFD700);
  static const Color successGreen = Color(0xFF28CD41); // Vibrant Success Green
  static const Color warningOrange = Color(0xFFFF9500); // Vibrant Warning Orange
  static const Color infoBlue = Color(0xFF007AFF); // Vibrant Info Blue
  static const Color emergencyRed = Color(0xFFFF3B30); // Pure Emergency Red
  
  static const Color ink = Color(0xFF1C1C1E); // Rich Black
  static const Color textSoft = Color(0xFF8E8E93); // iOS style soft text
  static const Color paper = Color(0xFFF2F2F7); // iOS style background
  static const Color paperWarm = Color(0xFFFFFFFF);
  static const Color line = Color(0xFFC6C6C8); // Subtle line color
  static const Color divider = Color(0xFFE5E5EA); // Standard iOS divider
  
  // Dark Mode Tokens
  static const Color surfaceDark = Color(0xFF000000);
  static const Color surfaceCardDark = Color(0xFF1C1C1E);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // Blood Group Color Map (Vibrant)
  static const Map<String, Color> bloodGroupColors = {
    'A+': Color(0xFFFF2D55),
    'A-': Color(0xFFD32F2F),
    'B+': Color(0xFF007AFF),
    'B-': Color(0xFF1565C0),
    'O+': Color(0xFF28CD41),
    'O-': Color(0xFF2E7D32),
    'AB+': Color(0xFF8E24AA),
    'AB-': Color(0xFF6A1B9A),
  };

  // Gradient Mesh Tokens
  static const List<Color> mainGradient = [primaryRed, Color(0xFF7F1416)];
  static const List<Color> glassGradient = [Colors.white70, Colors.white30];

  static TextTheme _buildTextTheme(TextTheme base, Color textColor) {
    return TextTheme(
      displayLarge: GoogleFonts.cormorantGaramond(
        textStyle: base.displayLarge,
        fontWeight: FontWeight.w800,
        color: textColor,
        letterSpacing: -1.5,
      ),
      displayMedium: GoogleFonts.cormorantGaramond(
        textStyle: base.displayMedium,
        fontWeight: FontWeight.w800,
        color: textColor,
        letterSpacing: -1.0,
      ),
      displaySmall: GoogleFonts.cormorantGaramond(
        textStyle: base.displaySmall,
        fontWeight: FontWeight.w800,
        color: textColor,
      ),
      headlineLarge: GoogleFonts.manrope(
        textStyle: base.headlineLarge,
        fontWeight: FontWeight.w800,
        color: textColor,
        letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.manrope(
        textStyle: base.headlineMedium,
        fontWeight: FontWeight.w800,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.manrope(
        textStyle: base.headlineSmall,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      titleLarge: GoogleFonts.manrope(
        textStyle: base.titleLarge,
        fontWeight: FontWeight.w800,
        color: textColor,
      ),
      bodyLarge: GoogleFonts.manrope(
        textStyle: base.bodyLarge,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.manrope(
        textStyle: base.bodyMedium,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.6,
      ),
      bodySmall: GoogleFonts.manrope(
        textStyle: base.bodySmall,
        fontWeight: FontWeight.w500,
        color: textColor == ink ? textSoft : textOnDark.withValues(alpha: 0.7),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryRed,
        onPrimary: Colors.white,
        secondary: primaryDark,
        error: emergencyRed,
        surface: paper,
        onSurface: ink,
      ),
      scaffoldBackgroundColor: paper,
      textTheme: _buildTextTheme(ThemeData.light().textTheme, ink),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: ink,
        titleTextStyle: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w800, color: ink),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: primaryRed.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          textStyle: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 10,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: GoogleFonts.manrope(color: textSoft.withValues(alpha: 0.5), fontWeight: FontWeight.w700),
        labelStyle: GoogleFonts.manrope(color: ink, fontWeight: FontWeight.w700),
        prefixIconColor: primaryRed,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: primaryRed, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: emergencyRed, width: 1.5)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryRed,
        onPrimary: Colors.white,
        secondary: accentGold,
        surface: surfaceDark,
        onSurface: textOnDark,
      ),
      scaffoldBackgroundColor: surfaceDark,
      textTheme: _buildTextTheme(ThemeData.dark().textTheme, textOnDark),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textOnDark,
        titleTextStyle: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w800, color: textOnDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          textStyle: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceCardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceCardDark,
        hintStyle: GoogleFonts.manrope(color: textOnDark.withValues(alpha: 0.4), fontWeight: FontWeight.w700),
        labelStyle: GoogleFonts.manrope(color: textOnDark, fontWeight: FontWeight.w700),
        prefixIconColor: primaryRed,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: primaryRed, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: emergencyRed, width: 1.5)),
      ),
    );
  }
}
