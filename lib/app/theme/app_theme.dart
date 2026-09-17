import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const sand = Color(0xFFF8F1E4);
  static const dune = Color(0xFFC49A6C);
  static const brown = Color(0xFF6D4C41);
  static const gold = Color(0xFFE0B13A);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: dune,
      brightness: Brightness.light,
      primary: brown,
      secondary: dune,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: sand,
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        selectedColor: dune,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: dune.withOpacity(0.25),
      ),
    );
  }

  static const heroGradient = LinearGradient(
    colors: [Color(0xFFC49A6C), Color(0xFF8D6E63)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );
}
