import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/detail_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ZooPortraitsApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomePage()),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) => DetailPage(id: state.pathParameters['id']!),
    ),
  ],
);

class ZooPortraitsApp extends StatelessWidget {
  const ZooPortraitsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseDark = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: const Color(0xFF3DB8AB), // teal-ish accent
    );

    return MaterialApp.router(
      routerConfig: _router,
      title: 'Austin Zoo Portraits',
      themeMode: ThemeMode.dark,
      theme: baseDark.copyWith(
        textTheme: GoogleFonts.interTextTheme(baseDark.textTheme),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF1F2225), // subtle field bg
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          isDense: true,
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF16191C),
          surfaceTintColor: Colors.transparent,
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            side: BorderSide(color: Color(0xFF24282C), width: 1),
          ),
        ),
        chipTheme: const ChipThemeData(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          side: BorderSide(color: Color(0xFF2A2E33)),
          shape: StadiumBorder(),
        ),
      ),
    );
  }
}
