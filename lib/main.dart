import 'package:flutter/material.dart';
import 'package:appflutter/screen/acceso_pantalla.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InmoConecta',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0E4775),
          primary: const Color(0xFF0E4775),
          secondary: const Color(0xFF25A7A3),
          surface: const Color(0xFFFFFCF8),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFCF8),
        useMaterial3: true,
      ),
      home: const AccesoPantalla(),
    );
  }
}
