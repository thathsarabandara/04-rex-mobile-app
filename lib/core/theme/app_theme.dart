import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary & Accent Colors
  static const Color primaryBlue = Color(0xFF7C3AED); // Modern violet/purple
  static const Color secondaryBlue = Color(0xFFC084FC); // Light purple
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  
  // Background & Surface Colors
  static const Color backgroundLight = Color(0xFFF8FAFC); // Very light slate
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0);
  
  static const Color backgroundDark = Color(0xFF090514); // Ultra-deep purple-black
  static const Color cardDark = Color(0xFF120E22); // Deep card purple-black
  static const Color borderDark = Color(0xFF261D40); // Soft purple-gray border
  
  // Text Colors
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: secondaryBlue,
        surface: cardLight,
        background: backgroundLight,
        error: danger,
        outline: borderLight,
      ),
      scaffoldBackgroundColor: backgroundLight,
      cardColor: cardLight,
      dividerColor: borderLight,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: textPrimaryLight, letterSpacing: -1.5),
        displayMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: textPrimaryLight, letterSpacing: -1.0),
        displaySmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: textPrimaryLight, letterSpacing: -0.5),
        headlineLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: textPrimaryLight, letterSpacing: -0.5),
        headlineMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: textPrimaryLight, letterSpacing: -0.2),
        headlineSmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: textPrimaryLight),
        titleLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: textPrimaryLight, letterSpacing: -0.2),
        titleMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: textPrimaryLight),
        titleSmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: textPrimaryLight),
        bodyLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w400, color: textPrimaryLight, fontSize: 16),
        bodyMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w400, color: textPrimaryLight, fontSize: 14),
        bodySmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w400, color: textSecondaryLight, fontSize: 12),
        labelLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: textPrimaryLight),
      ),
      cardTheme: CardThemeData(
        color: cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: borderLight, width: 1.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderLight, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderLight, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: danger, width: 1.0),
        ),
        hintStyle: GoogleFonts.plusJakartaSans(color: textSecondaryLight, fontWeight: FontWeight.w500),
        labelStyle: GoogleFonts.plusJakartaSans(color: textSecondaryLight, fontWeight: FontWeight.w600),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primaryBlue,
        unselectedLabelColor: textSecondaryLight,
        indicatorColor: primaryBlue,
        labelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14),
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      dividerTheme: const DividerThemeData(
        color: borderLight,
        thickness: 1.0,
        space: 1.0,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: secondaryBlue,
        surface: cardDark,
        background: backgroundDark,
        error: danger,
        outline: borderDark,
      ),
      scaffoldBackgroundColor: backgroundDark,
      cardColor: cardDark,
      dividerColor: borderDark,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: textPrimaryDark, letterSpacing: -1.5),
        displayMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: textPrimaryDark, letterSpacing: -1.0),
        displaySmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: textPrimaryDark, letterSpacing: -0.5),
        headlineLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: textPrimaryDark, letterSpacing: -0.5),
        headlineMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: textPrimaryDark, letterSpacing: -0.2),
        headlineSmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: textPrimaryDark),
        titleLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: textPrimaryDark, letterSpacing: -0.2),
        titleMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: textPrimaryDark),
        titleSmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: textPrimaryDark),
        bodyLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w400, color: textPrimaryDark, fontSize: 16),
        bodyMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w400, color: textPrimaryDark, fontSize: 14),
        bodySmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w400, color: textSecondaryDark, fontSize: 12),
        labelLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: textPrimaryDark),
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: borderDark, width: 1.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderDark, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderDark, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: danger, width: 1.0),
        ),
        hintStyle: GoogleFonts.plusJakartaSans(color: textSecondaryDark, fontWeight: FontWeight.w500),
        labelStyle: GoogleFonts.plusJakartaSans(color: textSecondaryDark, fontWeight: FontWeight.w600),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: secondaryBlue,
        unselectedLabelColor: textSecondaryDark,
        indicatorColor: secondaryBlue,
        labelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14),
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      dividerTheme: const DividerThemeData(
        color: borderDark,
        thickness: 1.0,
        space: 1.0,
      ),
    );
  }
}
