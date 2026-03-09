// lib/data/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors - inspired by the Indian tricolor with modern twist
  static const Color primary = Color(0xFF1A6B4A);       // Deep India Green
  static const Color primaryLight = Color(0xFF2E9B6E);   // Lighter green
  static const Color primaryDark = Color(0xFF0D4A33);    // Dark green
  static const Color accent = Color(0xFFFF7D26);         // Saffron orange
  static const Color accentLight = Color(0xFFFFAA6B);    // Light saffron
  static const Color surface = Color(0xFFF7F9F7);        // Off-white
  static const Color surfaceCard = Color(0xFFFFFFFF);    // White cards
  static const Color textPrimary = Color(0xFF1A2E25);    // Dark text
  static const Color textSecondary = Color(0xFF6B8F7A);  // Muted green text
  static const Color textLight = Color(0xFFB0C4BB);      // Light text
  static const Color divider = Color(0xFFE8F0EB);        // Light divider
  static const Color cartRed = Color(0xFFE53935);        // Remove red
  static const Color shadow = Color(0x1A1A6B4A);         // Green shadow

  // Badge colors per category
  static const Map<String, Color> categoryColors = {
    'Greetings': Color(0xFF4CAF50),
    'Food & Drink': Color(0xFFFF9800),
    'People': Color(0xFF2196F3),
    'Places': Color(0xFF9C27B0),
    'Emotions': Color(0xFFE91E63),
    'Common': Color(0xFF607D8B),
  };

  static Color categoryColor(String category) {
    return categoryColors[category] ?? primary;
  }

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: surface,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: divider, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: textLight, fontSize: 15),
        prefixIconColor: textSecondary,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceCard,
        selectedItemColor: primary,
        unselectedItemColor: textLight,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 11,
        ),
      ),
    );
  }
}

class AppStrings {
  static const String appName = 'ISL Pocket Signs';
  static const String appTagline = 'Indian Sign Language Reference';
  static const String browseAlphabets = 'Browse Alphabets';
  static const String browseWords = 'Browse Words';
  static const String mySignCart = 'My Sign Cart';
  static const String searchHint = 'Search signs, words, letters...';
  static const String addToCart = 'Add to Cart';
  static const String removeFromCart = 'Remove from Cart';
  static const String inCart = '✓ Saved to Cart';
  static const String cartEmpty = 'Your sign cart is empty';
  static const String cartEmptySub =
      'Browse alphabets or words and save signs for quick reference.';
  static const String noResults = 'No signs found';
  static const String noResultsSub =
      'Try searching a different letter or word.';
  static const String islSource =
      'Signs based on ISLRTC (Indian Sign Language Research & Training Centre) standards.';
}
