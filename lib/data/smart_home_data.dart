import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../models/smart_home_option.dart';

final List<SmartHomeOption> smartHomeOptions = [
  SmartHomeOption(
    title: 'Luces',
    subtitle: '8 dispositivos',
    heroIcon: HeroIcons.lightBulb,
    color: const Color(0xFFFFD700),
    gradientEnd: const Color(0xFFFF8C00),
    route: '/luces',
  ),
  SmartHomeOption(
    title: 'Cámaras',
    subtitle: '4 activas',
    heroIcon: HeroIcons.videoCamera,
    color: const Color(0xFF00CED1),
    gradientEnd: const Color(0xFF0077B6),
    route: '/camaras',
  ),
  SmartHomeOption(
    title: 'Sensores',
    subtitle: '12 conectados',
    heroIcon: HeroIcons.signal,
    color: const Color(0xFF7EE787),
    gradientEnd: const Color(0xFF238636),
    route: '/sensores',
  ),
  SmartHomeOption(
    title: 'Termostato',
    subtitle: '22°C',
    materialIcon: Symbols.tune_rounded,
    color: const Color(0xFFFF6B6B),
    gradientEnd: const Color(0xFFEE5A24),
    route: '/termostato',
  ),
  SmartHomeOption(
    title: 'Cerraduras',
    subtitle: '3 aseguradas',
    heroIcon: HeroIcons.lockClosed,
    color: const Color(0xFFA78BFA),
    gradientEnd: const Color(0xFF7C3AED),
    route: '/cerraduras',
  ),
];

