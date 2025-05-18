import 'package:flutter/material.dart';

class AppTheme {
  // Main colors based on the provided UI inspiration
  static const Color primaryDarkBlue = Color(0xFF0A1E3D);  // Deep dark blue
  static const Color accentBlue = Color(0xFF1A73E8);       // Vibrant blue accent
  static const Color lightTeal = Color(0xFF00E5FF);        // Bright teal for highlights
  static const Color darkTeal = Color(0xFF00BFA5);         // Darker teal
  static const Color backgroundColor = Color(0xFF121212);  // Dark background
  static const Color cardColor = Color(0xFF1E293B);        // Card/dark surface color
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8);    // Muted blue-gray text
  
  // Creating the theme for the app
  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryDarkBlue,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryDarkBlue,
        primary: primaryDarkBlue,
        secondary: accentBlue,
        surface: cardColor,
        background: backgroundColor,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        onBackground: textPrimary,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentBlue,
          foregroundColor: textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: cardColor,
        margin: const EdgeInsets.all(8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        selectedItemColor: accentBlue,
        unselectedItemColor: textSecondary,
        elevation: 8,
      ),
    );
  }

  // Background gradient similar to the UI in the image
  static LinearGradient get blueGradient {
    return const LinearGradient(
      colors: [
        primaryDarkBlue,
        Color(0xFF1E3A8A),
        accentBlue,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // Reusable decoration for screens with gradient background
  static BoxDecoration get gradientBackground {
    return BoxDecoration(
      gradient: blueGradient,
    );
  }

  // Card decoration with dark surface and rounded corners
  static BoxDecoration get cardDecoration {
    return BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Glassmorphism effect decoration
  static BoxDecoration get glassDecoration {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    );
  }
}