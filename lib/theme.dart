import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const primary = Color(0xFFA3C6A1);
  const secondary = Color(0xFFF5E9DA);
  const accent = Color(0xFF5C7A57);

  final colorScheme = ColorScheme.fromSeed(
    seedColor: primary,
    primary: primary,
    secondary: accent,
    background: secondary,
    surface: Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: secondary,

    appBarTheme: const AppBarTheme(
      backgroundColor: secondary,
      centerTitle: true,
      elevation: 0,
      foregroundColor: accent,
      titleTextStyle: TextStyle(
        color: accent,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    ),

    chipTheme: ChipThemeData(
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      backgroundColor: Colors.white,
      selectedColor: primary,
      labelStyle: const TextStyle(fontSize: 13),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
  );
}
