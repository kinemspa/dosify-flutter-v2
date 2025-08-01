import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Teal/Dark Teal color palette for medical app
  static const Color primaryColor = Color(0xFF00695C); // Dark Teal
  static const Color primaryColorDark = Color(0xFF004D40); // Darker Teal
  static const Color secondaryColor = Color(0xFF26A69A); // Teal accent
  static const Color tertiaryColor = Color(0xFF4DB6AC); // Light Teal
  static const Color successColor = Color(0xFF2E7D32); // Green
  static const Color warningColor = Color(0xFFE65100); // Orange
  static const Color errorColor = Color(0xFFD32F2F); // Red
  static const Color backgroundColor = Color(0xFFF0F9F8); // Very light teal
  static const Color surfaceColor = Color(0xFFE0F2F1); // Light teal surface

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        surface: surfaceColor,
        onSurface: const Color(0xFF1D1B20),
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        error: errorColor,
      ),
      textTheme: textTheme.copyWith(
        displayLarge: GoogleFonts.playfairDisplay(fontSize: 57, fontWeight: FontWeight.w400),
        displayMedium: GoogleFonts.playfairDisplay(fontSize: 45, fontWeight: FontWeight.w400),
        displaySmall: GoogleFonts.playfairDisplay(fontSize: 36, fontWeight: FontWeight.w400),
        headlineLarge: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.w400),
        headlineMedium: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.w400),
        headlineSmall: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.w400),
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        surface: const Color(0xFF1C1B1F),
        onSurface: const Color(0xFFE6E0E9),
        secondary: const Color(0xFFCCC2DC),
        tertiary: const Color(0xFFEFB8C8),
        error: const Color(0xFFFFB4AB),
      ),
      textTheme: textTheme.copyWith(
        displayLarge: GoogleFonts.playfairDisplay(fontSize: 57, fontWeight: FontWeight.w400, color: const Color(0xFFE6E0E9)),
        displayMedium: GoogleFonts.playfairDisplay(fontSize: 45, fontWeight: FontWeight.w400, color: const Color(0xFFE6E0E9)),
        displaySmall: GoogleFonts.playfairDisplay(fontSize: 36, fontWeight: FontWeight.w400, color: const Color(0xFFE6E0E9)),
        headlineLarge: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.w400, color: const Color(0xFFE6E0E9)),
        headlineMedium: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.w400, color: const Color(0xFFE6E0E9)),
        headlineSmall: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.w400, color: const Color(0xFFE6E0E9)),
      ),
      scaffoldBackgroundColor: const Color(0xFF100F13),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
