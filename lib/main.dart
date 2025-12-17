import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'pages/home_page.dart';
import 'pages/centro_mando_page.dart';
import 'pages/placeholder_page.dart';
import 'pages/luces_page.dart';
import 'pages/camaras_page.dart';
import 'pages/sensores_page.dart';
import 'pages/termostato_page.dart';
import 'pages/cerraduras_page.dart';

void main() {
  runApp(const ProviderScope(child: SmartHomeApp()));
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        primaryColor: const Color(0xFF58A6FF),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF58A6FF),
          secondary: Color(0xFF7EE787),
          surface: Color(0xFF161B22),
          error: Color(0xFFF85149),
        ),
        fontFamily: 'Segoe UI',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF8B949E),
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}

// Configuración del router
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/luces',
      builder: (context, state) => const LucesPage(),
    ),
    GoRoute(
      path: '/camaras',
      builder: (context, state) => const CamarasPage(),
    ),
    GoRoute(
      path: '/sensores',
      builder: (context, state) => const SensoresPage(),
    ),
    GoRoute(
      path: '/termostato',
      builder: (context, state) => const TermostatoPage(),
    ),
    GoRoute(
      path: '/cerraduras',
      builder: (context, state) => const CerradurasPage(),
    ),
    GoRoute(
      path: '/perfil',
      builder: (context, state) => const PlaceholderPage(title: 'Perfil'),
    ),
    GoRoute(
      path: '/centro-mando',
      builder: (context, state) => const CentroMandoPage(),
    ),
  ],
);
