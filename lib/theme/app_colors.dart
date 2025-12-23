import 'package:flutter/material.dart';

/// Paleta de colores celestiales para la aplicación Smart Home
/// Inspirada en los colores del cielo: celeste, azul cielo y blanco
class AppColors {
  // Colores primarios del cielo
  static const Color skyBlueLight = Color(0xFF87CEEB); // Sky Blue - Celeste claro
  static const Color skyBlue = Color(0xFF4A90E2); // Azul cielo medio
  static const Color skyBlueDark = Color(0xFF1E90FF); // Azul cielo oscuro
  static const Color powderBlue = Color(0xFFB0E0E6); // Azul polvo
  static const Color lightBlue = Color(0xFFE0F2FE); // Azul muy claro (nubes)
  
  // Colores de fondo - Negro original
  static const Color backgroundPrimary = Color(0xFF0D1117); // Negro principal
  static const Color backgroundStart = Color(0xFF0D1117); // Inicio del gradiente (negro)
  static const Color backgroundMiddle = Color(0xFF161B22); // Medio del gradiente (gris oscuro)
  static const Color backgroundEnd = Color(0xFF0D1117); // Fin del gradiente (negro)
  static const Color backgroundDark = Color(0xFF0D1117); // Negro oscuro
  
  // Colores de cards y superficies (para fondo negro)
  static const Color cardBackground = Color(0xFF161B22); // Gris oscuro para cards
  static const Color cardBackgroundAlt = Color(0xFF21262D); // Gris oscuro alternativo
  static const Color cardBorder = Color(0xFF30363D); // Borde gris
  static const Color cardShadow = Color(0x40000000); // Sombra oscura
  
  // Colores de texto (para fondo negro)
  static const Color textPrimary = Color(0xFFFFFFFF); // Blanco (texto principal)
  static const Color textSecondary = Color(0xFF8B949E); // Gris claro (texto secundario)
  static const Color textTertiary = Color(0xFF6E7681); // Gris (texto terciario)
  static const Color textDisabled = Color(0xFF484F58); // Gris oscuro (deshabilitado)
  static const Color textWhite = Color(0xFFFFFFFF); // Blanco para texto
  
  // Colores de acento (manteniendo diferenciación funcional)
  static const Color success = Color(0xFF5CB85C); // Verde cielo (éxito)
  static const Color successLight = Color(0xFF7EE787); // Verde claro
  static const Color warning = Color(0xFFFFB347); // Naranja suave (advertencia)
  static const Color error = Color(0xFFFF8C94); // Rosa suave (error)
  static const Color errorDark = Color(0xFFFF6B6B); // Rosa más intenso
  static const Color info = Color(0xFF4A90E2); // Azul cielo (información)
  
  // Colores para estados y acciones
  static const Color active = Color(0xFF4A90E2); // Azul cielo (activo)
  static const Color inactive = Color(0xFFB0C4DE); // Gris azulado (inactivo)
  static const Color highlight = Color(0xFF87CEEB); // Celeste (resaltado)
  
  // Gradientes celestiales
  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      backgroundStart,
      backgroundMiddle,
      backgroundEnd,
    ],
  );
  
  // Gradiente negro original (para fondo principal)
  static const LinearGradient celestialBlueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0D1117), // Negro
      Color(0xFF161B22), // Gris oscuro
      Color(0xFF0D1117), // Negro
    ],
  );
  
  static const LinearGradient skyGradientVertical = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      backgroundStart,
      backgroundMiddle,
      backgroundEnd,
    ],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      cardBackground,
      cardBackgroundAlt,
    ],
  );
  
  // Colores para dispositivos (manteniendo diferenciación)
  static const Color deviceLight = Color(0xFFFFD700); // Dorado (luces)
  static const Color deviceCamera = Color(0xFF00CED1); // Turquesa (cámaras)
  static const Color deviceSensor = Color(0xFF5CB85C); // Verde cielo (sensores)
  static const Color deviceThermostat = Color(0xFFFF6B6B); // Rosa (termostato)
  static const Color deviceLock = Color(0xFF9370DB); // Púrpura suave (cerraduras)
}

