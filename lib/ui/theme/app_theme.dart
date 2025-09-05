import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primary = Color(0xFFE57A57); // soft burnt orange
  static const secondary = Color(0xFFB29A7F); // warm tan
  static const tertiary = Color(0xFF6F8B6F); // muted forest
  static const appBarBg = Color(0xFF32302C); // soft charcoal

  // Your current dark surfaces
  static const surfaceDark = Color(0xFF101213);
  static const cardDark = Color(0xFF16191B);

  // ---- DARK THEME ----
  static ThemeData dark() {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: primary,
          secondary: secondary,
          tertiary: tertiary,
          surface: surfaceDark,
        );

    final base = ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color.fromARGB(255, 124, 139, 146),
      cardColor: const Color.fromARGB(255, 116, 131, 141),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF1A1E21),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        isDense: true,
      ),
    );

    return base.copyWith(
      // ✅ App-wide font
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme),

      // ✅ Bigger/bolder AppBar title by default
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: const Color.fromARGB(255, 206, 198, 182),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.nunito(
          color: const Color.fromARGB(255, 54, 41, 41),
          fontSize: 24, // bigger
          fontWeight: FontWeight.w900, // bolder
        ),
      ),

      // Optional: nicer chips that match your scheme
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: scheme.secondaryContainer,
        labelStyle: TextStyle(color: scheme.onSecondaryContainer),
        side: BorderSide(color: scheme.outlineVariant, width: 0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ---- LIGHT THEME ----
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ).copyWith(primary: primary, secondary: secondary, tertiary: tertiary);

    final base = ThemeData.light(useMaterial3: true).copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF7F7F7),
    );

    return base.copyWith(
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: const Color(0xFFF0E6D6),
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: scheme.secondaryContainer,
        labelStyle: TextStyle(color: scheme.onSecondaryContainer),
        side: BorderSide(color: scheme.outlineVariant, width: 0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
