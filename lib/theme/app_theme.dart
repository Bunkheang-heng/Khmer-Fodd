import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: const Color(0xFF2E7D32), // Deep forest green
      primaryColorDark: const Color(0xFF1B5E20),
      primaryColorLight: const Color(0xFF4CAF50),

      // Accent/Secondary colors
      colorScheme: const ColorScheme.light(
        primary:  Color(0xFF2E7D32),
        secondary:  Color(0xFF00838F), // Turquoise/Teal
        tertiary:  Color(0xFFFFB300), // Warm yellow
      ),

      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2E7D32),
        elevation: 0,
      ),

      // FloatingActionButton theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor:  Color(0xFF2E7D32),
      ),

      // Card theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),

      // Elevated Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),

      // Text theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Color(0xFF2E7D32),
          fontFamily: 'Chenla',
        ),
        headlineMedium: TextStyle(
          color: Color(0xFF2E7D32),
          fontFamily: 'Chenla',
        ),
        bodyLarge: TextStyle(
          color: Colors.black87,
          fontFamily: 'Chenla',
        ),
      ),
    );
  }
}
