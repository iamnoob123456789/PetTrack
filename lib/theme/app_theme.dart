import 'package:flutter/material.dart';

class AppTheme {
  static Color get pastelBlue => const Color(0xFFB3D8F7);
  static Color get pastelGreen => const Color(0xFFB8E2C8);
  static Color get white => Colors.white;
  static Color get darkText => const Color(0xFF222B45);

  static ThemeData get themeData => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: pastelBlue,
      secondary: pastelGreen,
      background: white,
      surface: white,
      onPrimary: darkText,
      onSecondary: darkText,
      onBackground: darkText,
      onSurface: darkText,
    ),
    scaffoldBackgroundColor: white,
    cardTheme: CardTheme(
      color: white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      shadowColor: pastelBlue.withOpacity(0.2),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF222B45)),
      headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF222B45)),
      bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF222B45)),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF222B45)),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF222B45)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: pastelBlue),
      ),
      filled: true,
      fillColor: pastelBlue.withOpacity(0.08),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: pastelGreen,
        foregroundColor: darkText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: white,
      selectedItemColor: pastelBlue,
      unselectedItemColor: pastelGreen,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
