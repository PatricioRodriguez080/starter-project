import 'package:flutter/material.dart';

/// Palette of the app design (light theme).
class AppColors {
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF1E6FD9);
  static const Color primarySoft = Color(0xFFE3EFFC);
  static const Color textPrimary = Color(0xFF15181E);
  static const Color textSecondary = Color(0xFF5A6472);
  static const Color icon = Color(0xFF6B7686);
  static const Color divider = Color(0xFFE1E6ED);
  static const Color inputBorder = Color(0xFFD3DBE5);
  static const Color imagePlaceholder = Color(0xFFE4EAF2);
  static const Color navigationBar = Color(0xBDEBF2FB);
  static const Color error = Color(0xFFB3261E);
}

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Muli',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      surface: AppColors.background,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
    ),
    appBarTheme: appBarTheme(),
    tabBarTheme: tabBarTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    filledButtonTheme: filledButtonTheme(),
    dividerColor: AppColors.divider,
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    backgroundColor: AppColors.background,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.textPrimary),
    titleTextStyle: TextStyle(
      fontFamily: 'Muli',
      color: AppColors.textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w800,
    ),
  );
}

TabBarThemeData tabBarTheme() {
  return const TabBarThemeData(
    labelColor: AppColors.primary,
    unselectedLabelColor: AppColors.textSecondary,
    indicatorColor: AppColors.primary,
    indicatorSize: TabBarIndicatorSize.tab,
    dividerColor: AppColors.divider,
    labelStyle: TextStyle(fontFamily: 'Muli', fontSize: 14, fontWeight: FontWeight.w800),
    unselectedLabelStyle: TextStyle(fontFamily: 'Muli', fontSize: 14, fontWeight: FontWeight.w600),
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color),
      );
  return InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    hintStyle: const TextStyle(color: AppColors.textSecondary),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: border(AppColors.inputBorder),
    enabledBorder: border(AppColors.inputBorder),
    focusedBorder: border(AppColors.primary),
    errorBorder: border(AppColors.error),
    focusedErrorBorder: border(AppColors.error),
  );
}

FilledButtonThemeData filledButtonTheme() {
  return FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(56),
      shape: const StadiumBorder(),
      textStyle: const TextStyle(fontFamily: 'Muli', fontSize: 16, fontWeight: FontWeight.w800),
    ),
  );
}
