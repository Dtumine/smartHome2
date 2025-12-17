import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class SmartHomeOption {
  final String title;
  final String subtitle;
  final HeroIcons? heroIcon;
  final IconData? materialIcon;
  final Color color;
  final Color gradientEnd;
  final String route;

  const SmartHomeOption({
    required this.title,
    required this.subtitle,
    this.heroIcon,
    this.materialIcon,
    required this.color,
    required this.gradientEnd,
    required this.route,
  });
}

