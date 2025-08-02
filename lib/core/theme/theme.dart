import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Modern Clinical Futuristic Color Palette
  static const Color primaryColor = Color(0xFF22465e); // Deep Navy Clinical
  static const Color secondaryColor = Color(0xFFd25117); // Vibrant Medical Orange
  static const Color primaryVariant = Color(0xFF1a3549); // Darker Navy
  static const Color secondaryVariant = Color(0xFFa83f0f); // Darker Orange
  
  // Surface and Background Colors
  static const Color surfaceLight = Color(0xFFF8FAFB); // Ultra light clinical white
  static const Color surfaceDark = Color(0xFF0a0f14); // Deep space dark
  static const Color cardLight = Color(0xFFFFFFFF); // Pure white
  static const Color cardDark = Color(0xFF1a2329); // Dark card
  
  // Accent Colors for modern UI
  static const Color accentBlue = Color(0xFF0ea5e9); // Cyber blue
  static const Color accentGreen = Color(0xFF10b981); // Success green
  static const Color accentRed = Color(0xFFef4444); // Error red
  static const Color accentYellow = Color(0xFFf59e0b); // Warning amber
  static const Color accentPurple = Color(0xFF8b5cf6); // Premium purple
  
  // Text Colors
  static const Color textPrimaryLight = Color(0xFF0f172a); // Almost black
  static const Color textSecondaryLight = Color(0xFF475569); // Medium gray
  static const Color textTertiaryLight = Color(0xFF94a3b8); // Light gray
  static const Color textPrimaryDark = Color(0xFFf8fafc); // Almost white
  static const Color textSecondaryDark = Color(0xFFcbd5e1); // Light gray
  static const Color textTertiaryDark = Color(0xFF64748b); // Medium gray
  
  // Glass morphism and modern effects
  static const Color glassLight = Color(0x1A22465e); // Semi-transparent primary
  static const Color glassDark = Color(0x1Af8fafc); // Semi-transparent white
  
  // Gradients for modern look
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryColor, secondaryVariant],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFFf1f5f9), Color(0xFFe2e8f0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.interTextTheme();
    return ThemeData(
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceLight,
        onSurface: textPrimaryLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        error: accentRed,
        tertiary: accentBlue,
      ),
      textTheme: textTheme.copyWith(
        // Display styles - Modern futuristic headings
        displayLarge: GoogleFonts.orbitron(
          fontSize: 57, 
          fontWeight: FontWeight.w700,
          color: textPrimaryLight,
          letterSpacing: -1.5,
        ),
        displayMedium: GoogleFonts.orbitron(
          fontSize: 45, 
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
          letterSpacing: -0.5,
        ),
        displaySmall: GoogleFonts.orbitron(
          fontSize: 36, 
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        // Headlines - Clinical precision
        headlineLarge: GoogleFonts.inter(
          fontSize: 32, 
          fontWeight: FontWeight.w700,
          color: textPrimaryLight,
          letterSpacing: -0.25,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 28, 
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 24, 
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        // Titles - Professional
        titleLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textSecondaryLight,
        ),
        // Body text - Clean and readable
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimaryLight,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondaryLight,
          height: 1.4,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textTertiaryLight,
          height: 1.3,
        ),
      ),
      scaffoldBackgroundColor: surfaceLight,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 24,
        ),
        titleTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: textTertiaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: 20,
        selectedIconTheme: const IconThemeData(size: 28),
        unselectedIconTheme: const IconThemeData(size: 24),
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: cardLight,
        margin: const EdgeInsets.all(8),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        elevation: 12,
        highlightElevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          shadowColor: primaryColor.withOpacity(0.3),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 2,
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textTertiaryLight.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textTertiaryLight.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentRed, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.inter(
          color: textTertiaryLight,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: GoogleFonts.inter(
          color: textSecondaryLight,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: glassLight,
        selectedColor: primaryColor,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 2,
      ),
      dividerTheme: DividerThemeData(
        color: textTertiaryLight.withOpacity(0.2),
        thickness: 1,
        space: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return secondaryColor;
            }
            return textTertiaryLight;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return secondaryColor.withOpacity(0.3);
            }
            return textTertiaryLight.withOpacity(0.3);
          },
        ),
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
