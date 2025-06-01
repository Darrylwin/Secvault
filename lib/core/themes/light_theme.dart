import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFFFD3951);

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: Colors.white,
    secondary: primaryColor.withOpacity(0.8),
    error: Colors.redAccent,
    surface: Colors.white,
    surfaceTint: Colors.white,
  ),

  // AppBar theme
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),

  // Card theme
  cardTheme: CardTheme(
    elevation: 2,
    shadowColor: Colors.black12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    clipBehavior: Clip.antiAlias,
  ),

  // Button themes
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),

  // Input decoration theme
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    labelStyle: TextStyle(color: Colors.grey[700]),
    floatingLabelStyle: const TextStyle(color: primaryColor),
    prefixIconColor: primaryColor,
  ),

  // Text theme
  textTheme: TextTheme(
    headlineLarge: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 28,
      color: Colors.black,
    ),
    headlineMedium: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: Colors.black,
    ),
    headlineSmall: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.black,
    ),
    titleLarge: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.black,
    ),
    bodyLarge: const TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: Colors.grey[800],
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      color: Colors.grey[600],
    ),
  ),

  // Progress indicator theme
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: primaryColor,
    linearTrackColor: Colors.grey[200],
    circularTrackColor: Colors.grey[200],
  ),

  // Dialog theme
  dialogTheme: DialogTheme(
    backgroundColor: Colors.white,
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),

  // Icon theme
  iconTheme: const IconThemeData(
    color: primaryColor,
  ),
);
