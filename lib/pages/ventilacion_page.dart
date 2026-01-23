import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'dart:math' as math;
import '../theme/app_colors.dart';

class VentilacionPage extends StatefulWidget {
  const VentilacionPage({super.key});

  @override
  State<VentilacionPage> createState() => _VentilacionPageState();
}

class _VentilacionPageState extends State<VentilacionPage> {
  int _selectedNavIndex = 0;

  // Lista de ventiladores
  final List<Ventilador> _ventiladores = [
    Ventilador(
      nombre: 'Sala Principal',
      icono: HeroIcons.home,
      velocidad: 60,
      modo: ModoVentilador.manual,
      temperatura: 24.5,
      calidadAire: CalidadAire.buena,
      conectado: true,
      bateria: 85,
      ultimaAccion: 'Hace 10 min',
    ),
    Ventilador(
      nombre: 'Dormitorio 1',
      icono: HeroIcons.moon,
      velocidad: 40,
      modo: ModoVentilador.automatico,
      temperatura: 22.0,
      calidadAire: CalidadAire.excelente,
      conectado: true,
      bateria: 92,
      ultimaAccion: 'Hace 5 min',
    ),
    Ventilador(
      nombre: 'Cocina',
      icono: HeroIcons.fire,
      velocidad: 80,
      modo: ModoVentilador.manual,
      temperatura: 26.0,
      calidadAire: CalidadAire.moderada,
      conectado: true,
      bateria: 78,
      ultimaAccion: 'Hace 2 horas',
    ),
    Ventilador(
      nombre: 'Oficina',
      materialIcon: Symbols.computer,
      velocidad: 0,
      modo: ModoVentilador.manual,
      temperatura: 23.5,
      calidadAire: CalidadAire.buena,
      conectado: true,
      bateria: 65,
      ultimaAccion: 'Hace 1 hora',
    ),
    Ventilador(
      nombre: 'Baño Principal',
      materialIcon: Symbols.shower,
      velocidad: 50,
      modo: ModoVentilador.automatico,
      temperatura: 25.0,
      calidadAire: CalidadAire.buena,
      conectado: true,
      bateria: 88,
      ultimaAccion: 'Hace 15 min',
    ),
    Ventilador(
      nombre: 'Garage',
      icono: HeroIcons.rectangleStack,
      velocidad: 0,
      modo: ModoVentilador.manual,
      temperatura: 20.0,
      calidadAire: CalidadAire.excelente,
      conectado: false,
      bateria: 45,
      ultimaAccion: 'Hace 3 horas',
    ),
  ];

  // Estadísticas
  int get _ventiladoresActivos {
    return _ventiladores.where((v) => v.velocidad > 0 && v.conectado).length;
  }

  int get _ventiladoresModoAuto {
    return _ventiladores.where((v) => v.modo == ModoVentilador.automatico && v.conectado).length;
  }

  double get _velocidadPromedio {
    if (_ventiladores.isEmpty) return 0;
    final total = _ventiladores
        .where((v) => v.conectado)
        .fold(0, (sum, v) => sum + v.velocidad);
    final count = _ventiladores.where((v) => v.conectado).length;
    return count > 0 ? total / count : 0;
  }

  double get _temperaturaPromedio {
    if (_ventiladores.isEmpty) return 0;
    final total = _ventiladores
        .where((v) => v.conectado)
        .fold(0.0, (sum, v) => sum + v.temperatura);
    final count = _ventiladores.where((v) => v.conectado).length;
    return count > 0 ? total / count : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.celestialBlueGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar personalizado
              _buildAppBar(),

              const SizedBox(height: 12),

              // Estadísticas generales
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildEstadisticasGenerales(),
              ),

              const SizedBox(height: 16),

              // Lista de ventiladores
              Expanded(
                child: _buildListaVentiladores(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.cardBorder,
                ),
              ),
              child: const HeroIcon(
                HeroIcons.arrowLeft,
                style: HeroIconStyle.outline,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sistema de Ventilación',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${_ventiladores.where((v) => v.conectado).length} ventiladores conectados',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Botón de acciones rápidas
          GestureDetector(
            onTap: () {
              _mostrarAccionesRapidas();
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.cardBorder,
                ),
              ),
              child: const HeroIcon(
                HeroIcons.bolt,
                style: HeroIconStyle.outline,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadisticasGenerales() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Symbols.air,
              label: 'Activos',
              value: '$_ventiladoresActivos',
              color: const Color(0xFF7EE787),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.cardBorder,
          ),
          Expanded(
            child: _buildStatItem(
              icon: Symbols.schedule,
              label: 'Auto',
              value: '$_ventiladoresModoAuto',
              color: const Color(0xFF58A6FF),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.cardBorder,
          ),
          Expanded(
            child: _buildStatItem(
              icon: Symbols.speed,
              label: 'Velocidad',
              value: '${_velocidadPromedio.toInt()}%',
              color: const Color(0xFFFFB347),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.cardBorder,
          ),
          Expanded(
            child: _buildStatItem(
              icon: Symbols.thermostat,
              label: 'Temp',
              value: '${_temperaturaPromedio.toStringAsFixed(1)}°',
              color: const Color(0xFFFF6B6B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildListaVentiladores() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _ventiladores.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildVentiladorCard(_ventiladores[index], index),
        );
      },
    );
  }

  Widget _buildVentiladorCard(Ventilador ventilador, int index) {
    final colorEstado = _getColorEstado(ventilador);
    final iconoEstado = _getIconoEstado(ventilador);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ventilador.conectado
              ? colorEstado.withValues(alpha: 0.3)
              : AppColors.cardBorder,
          width: ventilador.conectado ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del ventilador
          Row(
            children: [
              // Icono
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorEstado,
                      colorEstado.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ventilador.materialIcon != null
                    ? Icon(
                        ventilador.materialIcon,
                        color: Colors.white,
                        size: 20,
                      )
                    : HeroIcon(
                        ventilador.icono!,
                        style: HeroIconStyle.solid,
                        color: Colors.white,
                        size: 20,
                      ),
              ),
              const SizedBox(width: 12),
              // Nombre y estado
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ventilador.nombre,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // Indicador de conexión
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: ventilador.conectado
                                ? const Color(0xFF7EE787)
                                : const Color(0xFFFF6B6B),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(iconoEstado, size: 14, color: colorEstado),
                        const SizedBox(width: 4),
                        Text(
                          _getTextoEstado(ventilador),
                          style: TextStyle(
                            fontSize: 12,
                            color: colorEstado,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (ventilador.modo == ModoVentilador.automatico) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF58A6FF).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'AUTO',
                              style: TextStyle(
                                fontSize: 9,
                                color: Color(0xFF58A6FF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Indicador de batería
              if (ventilador.conectado)
                Column(
                  children: [
                    Icon(
                      _getIconoBateria(ventilador.bateria),
                      size: 16,
                      color: _getColorBateria(ventilador.bateria),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${ventilador.bateria}%',
                      style: TextStyle(
                        fontSize: 10,
                        color: _getColorBateria(ventilador.bateria),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Control de velocidad
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Velocidad',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${ventilador.velocidad}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorEstado,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Slider de velocidad
              Slider(
                value: ventilador.velocidad.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                activeColor: colorEstado,
                inactiveColor: AppColors.cardBorder,
                onChanged: ventilador.conectado
                    ? (value) {
                        setState(() {
                          _ventiladores[index].velocidad = value.toInt();
                          _ventiladores[index].ultimaAccion = 'Ahora';
                        });
                      }
                    : null,
              ),
              // Botones rápidos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBotonRapido(
                    icon: Symbols.power_off,
                    label: 'Apagar',
                    onTap: ventilador.conectado
                        ? () {
                            setState(() {
                              _ventiladores[index].velocidad = 0;
                              _ventiladores[index].ultimaAccion = 'Ahora';
                            });
                          }
                        : null,
                  ),
                  _buildBotonRapido(
                    icon: Symbols.speed,
                    label: '50%',
                    onTap: ventilador.conectado
                        ? () {
                            setState(() {
                              _ventiladores[index].velocidad = 50;
                              _ventiladores[index].ultimaAccion = 'Ahora';
                            });
                          }
                        : null,
                  ),
                  _buildBotonRapido(
                    icon: Symbols.air,
                    label: 'Máximo',
                    onTap: ventilador.conectado
                        ? () {
                            setState(() {
                              _ventiladores[index].velocidad = 100;
                              _ventiladores[index].ultimaAccion = 'Ahora';
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Información ambiental
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Symbols.thermostat,
                  label: 'Temperatura',
                  value: '${ventilador.temperatura.toStringAsFixed(1)}°C',
                  color: const Color(0xFFFF6B6B),
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: AppColors.cardBorder,
              ),
              Expanded(
                child: _buildInfoItem(
                  icon: Symbols.air,
                  label: 'Calidad Aire',
                  value: _getTextoCalidadAire(ventilador.calidadAire),
                  color: _getColorCalidadAire(ventilador.calidadAire),
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: AppColors.cardBorder,
              ),
              Expanded(
                child: _buildInfoItem(
                  icon: Symbols.schedule,
                  label: 'Última acción',
                  value: ventilador.ultimaAccion,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Botón de modo
          GestureDetector(
            onTap: ventilador.conectado
                ? () {
                    _cambiarModo(index);
                  }
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: ventilador.modo == ModoVentilador.automatico
                    ? const Color(0xFF58A6FF).withValues(alpha: 0.15)
                    : AppColors.cardBorder.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ventilador.modo == ModoVentilador.automatico
                      ? const Color(0xFF58A6FF).withValues(alpha: 0.5)
                      : AppColors.cardBorder,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    ventilador.modo == ModoVentilador.automatico
                        ? Symbols.schedule
                        : Symbols.touch_app,
                    size: 16,
                    color: ventilador.modo == ModoVentilador.automatico
                        ? const Color(0xFF58A6FF)
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    ventilador.modo == ModoVentilador.automatico
                        ? 'Modo Automático'
                        : 'Cambiar a Automático',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ventilador.modo == ModoVentilador.automatico
                          ? const Color(0xFF58A6FF)
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonRapido({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: onTap != null
              ? AppColors.cardBackgroundAlt
              : AppColors.cardBorder.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: onTap != null
                ? AppColors.cardBorder
                : AppColors.cardBorder.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: onTap != null
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: onTap != null
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Color _getColorEstado(Ventilador ventilador) {
    if (!ventilador.conectado) {
      return AppColors.textSecondary;
    }
    if (ventilador.velocidad == 0) {
      return const Color(0xFF8B949E); // Apagado
    } else if (ventilador.velocidad < 50) {
      return const Color(0xFF58A6FF); // Bajo
    } else if (ventilador.velocidad < 80) {
      return const Color(0xFFFFB347); // Medio
    } else {
      return const Color(0xFF7EE787); // Alto
    }
  }

  IconData _getIconoEstado(Ventilador ventilador) {
    if (!ventilador.conectado) {
      return Symbols.power_off;
    }
    if (ventilador.velocidad == 0) {
      return Symbols.power_off;
    } else {
      return Symbols.air;
    }
  }

  String _getTextoEstado(Ventilador ventilador) {
    if (!ventilador.conectado) {
      return 'Desconectado';
    }
    if (ventilador.velocidad == 0) {
      return 'Apagado';
    } else if (ventilador.velocidad < 50) {
      return 'Bajo';
    } else if (ventilador.velocidad < 80) {
      return 'Medio';
    } else {
      return 'Alto';
    }
  }

  IconData _getIconoBateria(int bateria) {
    if (bateria > 75) {
      return Symbols.battery_full;
    } else if (bateria > 50) {
      return Symbols.battery_3_bar;
    } else if (bateria > 25) {
      return Symbols.battery_2_bar;
    } else {
      return Symbols.battery_1_bar;
    }
  }

  Color _getColorBateria(int bateria) {
    if (bateria > 50) {
      return const Color(0xFF7EE787);
    } else if (bateria > 25) {
      return const Color(0xFFFFB347);
    } else {
      return const Color(0xFFFF6B6B);
    }
  }

  Color _getColorCalidadAire(CalidadAire calidad) {
    switch (calidad) {
      case CalidadAire.excelente:
        return const Color(0xFF7EE787);
      case CalidadAire.buena:
        return const Color(0xFF58A6FF);
      case CalidadAire.moderada:
        return const Color(0xFFFFB347);
      case CalidadAire.mala:
        return const Color(0xFFFF6B6B);
    }
  }

  String _getTextoCalidadAire(CalidadAire calidad) {
    switch (calidad) {
      case CalidadAire.excelente:
        return 'Excelente';
      case CalidadAire.buena:
        return 'Buena';
      case CalidadAire.moderada:
        return 'Moderada';
      case CalidadAire.mala:
        return 'Mala';
    }
  }

  void _cambiarModo(int index) {
    setState(() {
      _ventiladores[index].modo = _ventiladores[index].modo == ModoVentilador.manual
          ? ModoVentilador.automatico
          : ModoVentilador.manual;
    });
    final modoTexto = _ventiladores[index].modo == ModoVentilador.automatico
        ? 'Automático'
        : 'Manual';
    _mostrarSnackbar('Modo cambiado a $modoTexto en ${_ventiladores[index].nombre}');
  }

  void _mostrarAccionesRapidas() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Acciones Rápidas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF7EE787).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Symbols.air,
                  color: Color(0xFF7EE787),
                  size: 20,
                ),
              ),
              title: const Text(
                'Encender Todos',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Activar todos los ventiladores al 50%',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              onTap: () {
                Navigator.of(sheetContext).pop();
                setState(() {
                  for (var ventilador in _ventiladores) {
                    if (ventilador.conectado) {
                      ventilador.velocidad = 50;
                      ventilador.ultimaAccion = 'Ahora';
                    }
                  }
                });
                _mostrarSnackbar('Todos los ventiladores activados al 50%');
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B949E).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Symbols.power_off,
                  color: Color(0xFF8B949E),
                  size: 20,
                ),
              ),
              title: const Text(
                'Apagar Todos',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Desactivar todos los ventiladores',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              onTap: () {
                Navigator.of(sheetContext).pop();
                setState(() {
                  for (var ventilador in _ventiladores) {
                    if (ventilador.conectado) {
                      ventilador.velocidad = 0;
                      ventilador.ultimaAccion = 'Ahora';
                    }
                  }
                });
                _mostrarSnackbar('Todos los ventiladores apagados');
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB347).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Symbols.speed,
                  color: Color(0xFFFFB347),
                  size: 20,
                ),
              ),
              title: const Text(
                'Velocidad Máxima',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Activar todos al máximo',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              onTap: () {
                Navigator.of(sheetContext).pop();
                setState(() {
                  for (var ventilador in _ventiladores) {
                    if (ventilador.conectado) {
                      ventilador.velocidad = 100;
                      ventilador.ultimaAccion = 'Ahora';
                    }
                  }
                });
                _mostrarSnackbar('Todos los ventiladores al máximo');
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF30363D).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: HeroIcons.home,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                icon: HeroIcons.squares2x2,
                label: 'Panel',
                index: 1,
              ),
              _buildNavItem(
                icon: HeroIcons.bell,
                label: 'Alertas',
                index: 2,
              ),
              _buildNavItem(
                icon: HeroIcons.cog6Tooth,
                label: 'Ajustes',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required HeroIcons icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedNavIndex == index;
    final color = isSelected ? const Color(0xFF58A6FF) : const Color(0xFF8B949E);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
        if (index == 0) {
          context.go('/');
        } else if (index == 1) {
          context.push('/panel');
        } else if (index == 2) {
          context.push('/alertas');
        } else if (index == 3) {
          context.push('/ajustes');
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF58A6FF).withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeroIcon(
              icon,
              style: isSelected ? HeroIconStyle.solid : HeroIconStyle.outline,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarSnackbar(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: AppColors.cardBackground,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// Modelos de datos
enum ModoVentilador {
  manual,
  automatico,
}

enum CalidadAire {
  excelente,
  buena,
  moderada,
  mala,
}

class Ventilador {
  final String nombre;
  final HeroIcons? icono;
  final IconData? materialIcon;
  int velocidad; // 0-100
  ModoVentilador modo;
  double temperatura;
  CalidadAire calidadAire;
  bool conectado;
  int bateria; // 0-100
  String ultimaAccion;

  Ventilador({
    required this.nombre,
    this.icono,
    this.materialIcon,
    required this.velocidad,
    required this.modo,
    required this.temperatura,
    required this.calidadAire,
    required this.conectado,
    required this.bateria,
    required this.ultimaAccion,
  });
}

