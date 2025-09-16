import 'package:flutter/material.dart';

class LocsyColors {
  // Orange theme colors - improved
  static const orange = Color(0xFFFF7A00);             // Primary orange
  static const darkOrange = Color(0xFFE65100);         // Dark orange
  static const lightOrange = Color(0xFFFFF3E6);        // Light orange background
  static const accentOrange = Color(0xFFFF9800);       // Accent orange
  static const cream = Color(0xFFFFF8E1);              // Cream background
  static const navy = Color(0xFF0D3B66);               // Navy blue
  static const slate = Color(0xFF5C6B7A);              // Slate gray
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF212121);
  static const success = Color(0xFF4CAF50);            // Green
  static const warning = Color(0xFFFF9800);            // Orange
  static const error = Color(0xFFF44336);              // Red
  static const info = Color(0xFF2196F3);               // Blue
}

class LocsyTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: LocsyColors.orange,
      primary: LocsyColors.orange,
      secondary: LocsyColors.darkOrange,
      tertiary: LocsyColors.accentOrange,
      surface: LocsyColors.white,
      background: LocsyColors.lightOrange,
      error: LocsyColors.error,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: LocsyColors.lightOrange,
    appBarTheme: const AppBarTheme(
      backgroundColor: LocsyColors.orange,
      foregroundColor: Colors.white,
      elevation: 2,
      shadowColor: LocsyColors.darkOrange,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: LocsyColors.white,
      elevation: 4,
      shadowColor: LocsyColors.darkOrange.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: LocsyColors.orange,
        foregroundColor: Colors.white,
        elevation: 3,
        shadowColor: LocsyColors.darkOrange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: LocsyColors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LocsyColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: LocsyColors.orange),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: LocsyColors.orange.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: LocsyColors.orange, width: 2),
      ),
      labelStyle: const TextStyle(color: LocsyColors.orange),
      hintStyle: TextStyle(color: LocsyColors.slate),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: LocsyColors.orange,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: LocsyColors.white,
      selectedItemColor: LocsyColors.orange,
      unselectedItemColor: LocsyColors.slate,
      elevation: 8,
    ),
  );
}
