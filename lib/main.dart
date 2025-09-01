import 'package:flutter/material.dart';
import 'ui/pages/home_page.dart';

void main() {
  runApp(const ZooPortraitsApp());
}

class ZooPortraitsApp extends StatelessWidget {
  const ZooPortraitsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zoo Portraits',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const HomePage(),
    );
  }
}
