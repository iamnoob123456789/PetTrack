import 'package:flutter/material.dart';

class AppTheme {
  // Color palette from your CSS variables
  static const Color primaryColor = Color(0xFF4A90E2);
  static const Color primaryForeground = Color(0xFFFFFFFF);
  static const Color secondaryColor = Color(0xFFA8D8B9);
  static const Color secondaryForeground = Color(0xFF1A1A1A);
  static const Color accentColor = Color(0xFFE8F4F8);
  static const Color accentForeground = Color(0xFF1A1A1A);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color foregroundColor = Color(0xFF252525);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color cardForegroundColor = Color(0xFF252525);
  static const Color mutedColor = Color(0xFFF5F8FA);
  static const Color mutedForegroundColor = Color(0xFF717182);
  static const Color destructiveColor = Color(0xFFE57373);
  static const Color destructiveForegroundColor = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0x14000000);
  static const Color inputColor = Colors.transparent;
  static const Color inputBackgroundColor = Color(0xFFF9FCFE);
  static const Color switchBackgroundColor = Color(0xFFCBCED4);
  static const Color ringColor = Color(0xFF4A90E2);
  static const Color whiteColor = Color(0xFFFFFFFF);

  // Text sizes from your CSS
  static const double textXs = 12.0;
  static const double textSm = 14.0;
  static const double textBase = 16.0;
  static const double textLg = 18.0;
  static const double textXl = 20.0;
  static const double text2Xl = 24.0;
  static const double text3Xl = 30.0;

  // Spacing system (1 unit = 4px)
  static const double spacing = 4.0;

  // Border radius
  static const double borderRadius = 12.0;
  static const double borderRadius2Xl = 16.0;
  static const double borderRadius3Xl = 24.0;

  // Font weights
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemibold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // Light Theme
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        onPrimary: primaryForeground,
        secondary: secondaryColor,
        onSecondary: secondaryForeground,
        background: backgroundColor,
        onBackground: foregroundColor,
        surface: cardColor,
        onSurface: cardForegroundColor,
        error: destructiveColor,
        onError: destructiveForegroundColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      dividerColor: borderColor,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: text3Xl,
          fontWeight: fontWeightMedium,
          height: 1.2,
          color: foregroundColor,
        ),
        displayMedium: TextStyle(
          fontSize: text2Xl,
          fontWeight: fontWeightMedium,
          height: 1.3,
          color: foregroundColor,
        ),
        displaySmall: TextStyle(
          fontSize: textXl,
          fontWeight: fontWeightMedium,
          height: 1.4,
          color: foregroundColor,
        ),
        headlineMedium: TextStyle(
          fontSize: textLg,
          fontWeight: fontWeightMedium,
          height: 1.4,
          color: foregroundColor,
        ),
        headlineSmall: TextStyle(
          fontSize: textBase,
          fontWeight: fontWeightMedium,
          height: 1.5,
          color: foregroundColor,
        ),
        titleLarge: TextStyle(
          fontSize: textBase,
          fontWeight: fontWeightMedium,
          height: 1.5,
          color: foregroundColor,
        ),
        bodyLarge: TextStyle(
          fontSize: textBase,
          fontWeight: fontWeightNormal,
          height: 1.5,
          color: foregroundColor,
        ),
        bodyMedium: TextStyle(
          fontSize: textSm,
          fontWeight: fontWeightNormal,
          height: 1.4,
          color: foregroundColor,
        ),
        labelLarge: TextStyle(
          fontSize: textBase,
          fontWeight: fontWeightMedium,
          height: 1.5,
          color: foregroundColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacing * 3,
          vertical: spacing * 2,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: primaryForeground,
          padding: EdgeInsets.symmetric(
            horizontal: spacing * 4,
            vertical: spacing * 2,
          ),
          textStyle: const TextStyle(
            fontSize: textBase,
            fontWeight: fontWeightMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius2Xl),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  // Dark Theme (based on your dark mode variables)
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: whiteColor,
      colorScheme: const ColorScheme.dark(
        primary: whiteColor,
        onPrimary: Color(0xFF1A1A1A),
        secondary: Color(0xFF444444),
        onSecondary: whiteColor,
        background: Color(0xFF252525),
        onBackground: whiteColor,
        surface: Color(0xFF252525),
        onSurface: whiteColor,
        error: Color(0xFFE57373),
        onError: whiteColor,
      ),
      scaffoldBackgroundColor: const Color(0xFF252525),
      cardColor: const Color(0xFF252525),
      dividerColor: const Color(0xFF444444),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: text3Xl,
          fontWeight: fontWeightMedium,
          height: 1.2,
          color: whiteColor,
        ),
        displayMedium: TextStyle(
          fontSize: text2Xl,
          fontWeight: fontWeightMedium,
          height: 1.3,
          color: whiteColor,
        ),
        displaySmall: TextStyle(
          fontSize: textXl,
          fontWeight: fontWeightMedium,
          height: 1.4,
          color: whiteColor,
        ),
        headlineMedium: TextStyle(
          fontSize: textLg,
          fontWeight: fontWeightMedium,
          height: 1.4,
          color: whiteColor,
        ),
        headlineSmall: TextStyle(
          fontSize: textBase,
          fontWeight: fontWeightMedium,
          height: 1.5,
          color: whiteColor,
        ),
        titleLarge: TextStyle(
          fontSize: textBase,
          fontWeight: fontWeightMedium,
          height: 1.5,
          color: whiteColor,
        ),
        bodyLarge: TextStyle(
          fontSize: textBase,
          fontWeight: fontWeightNormal,
          height: 1.5,
          color: whiteColor,
        ),
        bodyMedium: TextStyle(
          fontSize: textSm,
          fontWeight: fontWeightNormal,
          height: 1.4,
          color: whiteColor,
        ),
        labelLarge: TextStyle(
          fontSize: textBase,
          fontWeight: fontWeightMedium,
          height: 1.5,
          color: whiteColor,
        ),
      ),
    );
  }

  // Spacing utilities
  static EdgeInsets spacingAll(double multiplier) {
    return EdgeInsets.all(spacing * multiplier);
  }

  static EdgeInsets spacingHorizontal(double multiplier) {
    return EdgeInsets.symmetric(horizontal: spacing * multiplier);
  }

  static EdgeInsets spacingVertical(double multiplier) {
    return EdgeInsets.symmetric(vertical: spacing * multiplier);
  }

  static EdgeInsets spacingSymmetric(double horizontal, double vertical) {
    return EdgeInsets.symmetric(
      horizontal: spacing * horizontal,
      vertical: spacing * vertical,
    );
  }

  // Common layout values
  static const double minScreenHeight = 100.0;
  static const double maxWidthMd = 448.0; // 28rem = 448px
  static const double maxWidth7Xl = 1280.0; // 80rem = 1280px
}