import 'package:flutter/material.dart';

class LocsyColors {
  static const orange = Color(0xFFFF7A00);
  static const navy = Color(0xFF0D3B66);
  static const cream = Color(0xFFFFF3E6);
  static const slate = Color(0xFF5C6B7A);
}

class LocsyTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: LocsyColors.orange,
      primary: LocsyColors.orange,
      secondary: LocsyColors.navy,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: LocsyColors.orange,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}
