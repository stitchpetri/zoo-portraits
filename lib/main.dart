import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ui/theme/app_theme.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/detail_page.dart';

// Build the router once (top-level or as a static)
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'detail/:id',
          name: 'detail',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return DetailPage(id: id);
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text(state.error?.toString() ?? 'Route error')),
  ),
);

class ZooPortraitsApp extends StatelessWidget {
  const ZooPortraitsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Austin Zoo Animals',
      routerConfig: _router, // ✅ use routerConfig
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark, // or ThemeMode.system
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(const ZooPortraitsApp());
}
