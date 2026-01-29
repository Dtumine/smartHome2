import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
import 'pages/riego_page.dart';
import 'pages/programar_riego_page.dart';
import 'pages/cortinas_page.dart';
import 'pages/alarmas_page.dart';
import 'pages/ventilacion_page.dart';
import 'pages/login_page.dart';
import 'pages/perfil_page.dart';
import 'pages/dispositivos_activos_page.dart';
import 'providers/auth_provider.dart';
import 'services/auth_service.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const ProviderScope(child: SmartHomeApp()));
}

/// Widget wrapper que verifica la autenticación antes de mostrar el contenido
class AuthWrapper extends StatelessWidget {
  final Widget child;

  const AuthWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.backgroundPrimary,
            body: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.celestialBlueGradient,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF58A6FF),
                  ),
                ),
              ),
            ),
          );
        }

        final isLoggedIn = snapshot.data ?? false;
        
        if (!isLoggedIn) {
          // Redirigir a login después de que el frame se construya
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.go('/login');
            }
          });
          return const SizedBox.shrink();
        }

        return child;
      },
    );
  }
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
  redirect: (context, state) async {
    final isLoggedIn = await AuthService().isLoggedIn();
    final isGoingToLogin = state.matchedLocation == '/login';
    
    // Si no está autenticado y no va a login, redirigir a login
    if (!isLoggedIn && !isGoingToLogin) {
      return '/login';
    }
    // Si está autenticado y va a login, redirigir a home
    if (isLoggedIn && isGoingToLogin) {
      return '/';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthWrapper(child: HomePage()),
    ),
    GoRoute(
      path: '/luces',
      builder: (context, state) => const AuthWrapper(child: LucesPage()),
    ),
    GoRoute(
      path: '/camaras',
      builder: (context, state) => const AuthWrapper(child: CamarasPage()),
    ),
    GoRoute(
      path: '/sensores',
      builder: (context, state) => const AuthWrapper(child: SensoresPage()),
    ),
    GoRoute(
      path: '/termostato',
      builder: (context, state) => const AuthWrapper(child: TermostatoPage()),
    ),
    GoRoute(
      path: '/cerraduras',
      builder: (context, state) => const AuthWrapper(child: CerradurasPage()),
    ),
    GoRoute(
      path: '/perfil',
      builder: (context, state) => const AuthWrapper(child: PerfilPage()),
    ),
    GoRoute(
      path: '/ajustes',
      builder: (context, state) => const AuthWrapper(child: AjustesPage()),
    ),
    GoRoute(
      path: '/centro-mando',
      builder: (context, state) => const AuthWrapper(child: CentroMandoPage()),
    ),
    GoRoute(
      path: '/panel',
      builder: (context, state) => const AuthWrapper(child: PanelPage()),
    ),
    GoRoute(
      path: '/alertas',
      builder: (context, state) => const AuthWrapper(child: AlertasPage()),
    ),
    GoRoute(
      path: '/riego',
      builder: (context, state) => const AuthWrapper(child: RiegoPage()),
    ),
    GoRoute(
      path: '/programar-riego',
      builder: (context, state) {
        final zonaNombre = state.uri.queryParameters['zona'];
        final zonaIndex = state.uri.queryParameters['index'];
        return AuthWrapper(
          child: ProgramarRiegoPage(
            zonaNombre: zonaNombre,
            zonaIndex: zonaIndex != null ? int.tryParse(zonaIndex) : null,
          ),
        );
      },
    ),
    GoRoute(
      path: '/cortinas',
      builder: (context, state) => const AuthWrapper(child: CortinasPage()),
    ),
    GoRoute(
      path: '/alarmas',
      builder: (context, state) => const AuthWrapper(child: AlarmasPage()),
    ),
    GoRoute(
      path: '/ventilacion',
      builder: (context, state) => const AuthWrapper(child: VentilacionPage()),
    ),
    GoRoute(
      path: '/dispositivos-activos',
      builder: (context, state) => const AuthWrapper(child: DispositivosActivosPage()),
    ),
  ],
);
