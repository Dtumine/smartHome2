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
import 'theme/app_colors.dart';

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
        brightness: Brightness.dark, // Tema oscuro original
        scaffoldBackgroundColor: AppColors.backgroundPrimary,
        primaryColor: AppColors.skyBlue,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.skyBlue,
          secondary: AppColors.success,
          surface: AppColors.cardBackground,
          error: AppColors.error,
          onPrimary: AppColors.textWhite,
          onSecondary: AppColors.textWhite,
          onSurface: AppColors.textPrimary,
          onError: AppColors.textWhite,
        ),
        fontFamily: 'Segoe UI',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardBackground,
          elevation: 2,
          shadowColor: AppColors.cardShadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: AppColors.cardBorder,
              width: 1,
            ),
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
