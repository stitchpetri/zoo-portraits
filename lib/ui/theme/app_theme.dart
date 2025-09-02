import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Design tokens
  static const double radius = 16;
  static const double gutter = 12;

  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.teal,
    brightness: Brightness.light,
    textTheme: GoogleFonts.interTextTheme(),
    cardTheme: const CardThemeData(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppTheme.radius)),
      ),
      elevation: 2,
    ),

    chipTheme: const ChipThemeData(
      shape: StadiumBorder(),
      padding: EdgeInsets.symmetric(horizontal: 8),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      isDense: true,
    ),
  );

  static ThemeData dark = light.copyWith(brightness: Brightness.dark);
}
