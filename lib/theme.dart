import 'package:flutter/material.dart';

const primaryColor = Color(0xFFF9B43A);
const secondaryColor = Color(0xFF3A57E8);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'IranSans',
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: Colors.white,
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    onSurface: Colors.black,
  ),

  appBarTheme: const AppBarTheme(backgroundColor: primaryColor, foregroundColor: Colors.black, elevation: 1),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: primaryColor, foregroundColor: Colors.black),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'IranSans',
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),
  colorScheme: ColorScheme.dark(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: Color(0xFF1E1E1E),
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    onSurface: Colors.white,
  ),
  appBarTheme: const AppBarTheme(backgroundColor: primaryColor, foregroundColor: Colors.black, elevation: 1),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: primaryColor, foregroundColor: Colors.black),
);
