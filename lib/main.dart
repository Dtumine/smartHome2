import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/home_page.dart';
import 'pages/centro_mando_page.dart';
import 'pages/placeholder_page.dart';
import 'pages/luces_page.dart';
import 'pages/camaras_page.dart';
import 'pages/sensores_page.dart';
import 'pages/termostato_page.dart';
import 'pages/cerraduras_page.dart';
import 'pages/alertas_page.dart';
import 'pages/ajustes_page.dart';
import 'pages/panel_page.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const ProviderScope(child: SmartHomeApp()));
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Usar Poppins que es más distintiva - puedes cambiar a Inter después
    final poppinsTextStyle = GoogleFonts.poppins();
    final poppinsFontFamily = poppinsTextStyle.fontFamily;
    
    return DefaultTextStyle(
      style: poppinsTextStyle.copyWith(
        fontSize: 14,
        color: AppColors.textPrimary,
      ),
      child: MaterialApp.router(
        title: 'Smart Home',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        brightness: Brightness.dark, // Tema oscuro original
        useMaterial3: true, // Usar Material 3 para mejor propagación de fuentes
        scaffoldBackgroundColor: AppColors.backgroundPrimary,
        primaryColor: AppColors.skyBlue,
        // Aplicar Poppins como fuente por defecto (más distintiva para probar)
        fontFamily: poppinsFontFamily,
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
        // Tipografía Poppins - aplicada globalmente (cambiar a Inter después si prefieres)
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ).copyWith(
          headlineLarge: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
          headlineSmall: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          titleMedium: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          titleSmall: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          bodySmall: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
          labelLarge: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          labelMedium: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
          labelSmall: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
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
      ),
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
      builder: (context, state) => const AjustesPage(),
    ),
    GoRoute(
      path: '/ajustes',
      builder: (context, state) => const AjustesPage(),
    ),
    GoRoute(
      path: '/centro-mando',
      builder: (context, state) => const CentroMandoPage(),
    ),
    GoRoute(
      path: '/panel',
      builder: (context, state) => const PanelPage(),
    ),
    GoRoute(
      path: '/alertas',
      builder: (context, state) => const AlertasPage(),
    ),
  ],
);
