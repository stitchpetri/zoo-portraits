import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'ui/pages/detail_page.dart';
import 'ui/pages/home_page.dart';

/// Listenable that notifies GoRouter when the auth state changes.

GoRouter buildRouter() {
  return GoRouter(
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
}

class ZooPortraitsApp extends StatelessWidget {
  const ZooPortraitsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = buildRouter();
    return MaterialApp.router(
      title: 'Zoo Portraits',
      routerConfig: router,
      themeMode: ThemeMode.dark,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
    );
  }
}

void main() {
  runApp(const ZooPortraitsApp());
}
