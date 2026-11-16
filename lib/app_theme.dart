import 'package:flutter/material.dart';

class AppTheme {
  static const Color brunFonce = Color(0xFF3E2922);
  static const Color terracotta = Color(0xFF824C35);
  static const Color caramel = Color(0xFFC98249);
  static const Color creme = Color(0xFFEFE2CB);
  static const Color beige = Color(0xFFF5EBDD);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: beige,
    primaryColor: terracotta,
    colorScheme: ColorScheme.fromSeed(
      seedColor: terracotta,
      primary: terracotta,
      secondary: caramel,
      surface: creme,
    ),
  );
}