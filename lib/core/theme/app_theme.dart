import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

class AppTheme {
  // Light Theme
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      surface: AppColors.background,
    ),
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.textDark,
        fontSize: AppFonts.sizeExtraLarge,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: AppColors.textDark),
    ),
  );

  // Dark Theme
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF1E1E1E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: AppFonts.sizeExtraLarge,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );
}
