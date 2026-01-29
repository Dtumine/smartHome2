import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'dart:math' as math;
import '../theme/app_colors.dart';
import '../services/dispositivos_service.dart';

class LucesPage extends StatefulWidget {
  const LucesPage({super.key});

  @override
  State<LucesPage> createState() => _LucesPageState();
}

class _LucesPageState extends State<LucesPage> {
  final _dispositivosService = DispositivoService();
  
  // Habitación seleccionada
  int _habitacionSeleccionada = 0;

  // Navegación inferior
  int _selectedNavIndex = 0;

  // Datos de las habitaciones/opciones
  final List<HabitacionLuz> _habitaciones = [
    HabitacionLuz(
      nombre: 'Sala',
      heroIcon: HeroIcons.tv,
      color: const Color(0xFFFFD700),
      gradientEnd: const Color(0xFFFF8C00),
      brillo: 80,
      encendida: true,
    ),
    HabitacionLuz(
      nombre: 'Cocina',
      heroIcon: HeroIcons.fire,
      color: const Color(0xFFFF6B6B),
      gradientEnd: const Color(0xFFEE5A24),
      brillo: 100,
      encendida: true,
    ),
    HabitacionLuz(
      nombre: 'Dormitorio 1',
      heroIcon: HeroIcons.moon,
      color: const Color(0xFFA78BFA),
      gradientEnd: const Color(0xFF7C3AED),
      brillo: 30,
      encendida: true,
    ),
    HabitacionLuz(
      nombre: 'Baño 1',
      materialIcon: Icons.shower,
      color: const Color(0xFF58A6FF),
      gradientEnd: const Color(0xFF0077B6),
      brillo: 85,
      encendida: false,
    ),
    HabitacionLuz(
      nombre: 'Garage',
      materialIcon: Icons.directions_car,
      color: const Color(0xFF7EE787),
      gradientEnd: const Color(0xFF238636),
      brillo: 100,
      encendida: false,
    ),
    HabitacionLuz(
      nombre: 'Jardín 1',
      materialIcon: Icons.park,
      color: const Color(0xFF00CED1),
      gradientEnd: const Color(0xFF008B8B),
      brillo: 50,
      encendida: false,
    ),
    HabitacionLuz(
      nombre: 'Living',
      materialIcon: Icons.weekend,
      color: const Color(0xFFFFB347),
      gradientEnd: const Color(0xFFFF8C00),
      brillo: 50,
      encendida: false,
    ),
    HabitacionLuz(
      nombre: 'Dormitorio 2',
      heroIcon: HeroIcons.moon,
      color: const Color(0xFFFF69B4),
      gradientEnd: const Color(0xFFDB2777),
      brillo: 50,
      encendida: false,
    ),
    HabitacionLuz(
      nombre: 'Dormitorio 3',
      heroIcon: HeroIcons.moon,
      color: const Color(0xFF87CEEB),
      gradientEnd: const Color(0xFF4682B4),
      brillo: 50,
      encendida: false,
    ),
    HabitacionLuz(
      nombre: 'Jardín 2',
      materialIcon: Icons.park,
      color: const Color(0xFF98FB98),
      gradientEnd: const Color(0xFF32CD32),
      brillo: 50,
      encendida: false,
    ),
    HabitacionLuz(
      nombre: 'Piscina',
      materialIcon: Icons.pool,
      color: const Color(0xFF00BFFF),
      gradientEnd: const Color(0xFF1E90FF),
      brillo: 50,
      encendida: false,
    ),
    HabitacionLuz(
      nombre: 'Pérgola',
      heroIcon: HeroIcons.buildingLibrary,
      color: const Color(0xFFDDA0DD),
      gradientEnd: const Color(0xFF9932CC),
      brillo: 50,
      encendida: false,
    ),
  ];

  HabitacionLuz get _habitacionActual => _habitaciones[_habitacionSeleccionada];

  void _cambiarColor(Color nuevoColor) {
    setState(() {
      _habitaciones[_habitacionSeleccionada].color = nuevoColor;
      if (!_habitaciones[_habitacionSeleccionada].encendida) {
        _habitaciones[_habitacionSeleccionada].encendida = true;
        // Sincronizar con el servicio
        final nombreLuz = _getNombreLuzEnServicio(_habitaciones[_habitacionSeleccionada].nombre);
        if (nombreLuz != null) {
          _dispositivosService.cambiarEstado(nombreLuz, true);
        }
      }
    });
  }

  void _cambiarBrillo(double valor) {
    setState(() {
      _habitaciones[_habitacionSeleccionada].brillo = valor.round();
      if (!_habitaciones[_habitacionSeleccionada].encendida && valor > 0) {
        _habitaciones[_habitacionSeleccionada].encendida = true;
        // Sincronizar con el servicio
        final nombreLuz = _getNombreLuzEnServicio(_habitaciones[_habitacionSeleccionada].nombre);
        if (nombreLuz != null) {
          _dispositivosService.cambiarEstado(nombreLuz, true);
        }
      }
    });
  }

  void _toggleLuz() {
    setState(() {
      _habitaciones[_habitacionSeleccionada].encendida = 
          !_habitaciones[_habitacionSeleccionada].encendida;
      // Sincronizar con el servicio
      final nombreLuz = _getNombreLuzEnServicio(_habitaciones[_habitacionSeleccionada].nombre);
      if (nombreLuz != null) {
        _dispositivosService.cambiarEstado(nombreLuz, _habitaciones[_habitacionSeleccionada].encendida);
      }
    });
  }

  String? _getNombreLuzEnServicio(String nombreHabitacion) {
    // Mapear nombres de habitaciones a nombres en el servicio
    final mapa = {
      'Sala': 'Luz Sala',
      'Cocina': 'Luz Cocina',
      'Dormitorio 1': 'Luz Dormitorio 1 (Luces)',
      'Baño 1': 'Luz Baño 1',
      'Garage': 'Luz Garage (Luces)',
      'Jardín 1': 'Luz Jardín 1',
      'Living': 'Luz Living',
      'Dormitorio 2': 'Luz Dormitorio 2 (Luces)',
      'Dormitorio 3': 'Luz Dormitorio 3',
      'Jardín 2': 'Luz Jardín 2',
      'Piscina': 'Luz Piscina',
      'Pérgola': 'Luz Pérgola',
    };
    return mapa[nombreHabitacion];
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF21262D),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF30363D),
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
                            'Control de Luces',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            _habitacionActual.nombre,
                            style: TextStyle(
                              fontSize: 13,
                              color: _habitacionActual.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Botón de encendido/apagado
                    GestureDetector(
                      onTap: _toggleLuz,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: _habitacionActual.encendida
                              ? _habitacionActual.color.withValues(alpha: 0.2)
                              : const Color(0xFF21262D),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _habitacionActual.encendida
                                ? _habitacionActual.color.withValues(alpha: 0.5)
                                : const Color(0xFF30363D),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: _habitacionActual.encendida
                                  ? _habitacionActual.color
                                  : const Color(0xFF8B949E),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _habitacionActual.encendida ? 'ON' : 'OFF',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _habitacionActual.encendida
                                    ? _habitacionActual.color
                                    : const Color(0xFF8B949E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Selector de color RGB
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildColorSelector(),
              ),
              
              const SizedBox(height: 16),
              
              // Barra de habitaciones (scroll horizontal) - en el medio
              _buildHabitacionesBar(),
              
              const SizedBox(height: 16),
              
              // Slider de intensidad - abajo
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: _buildIntensitySlider(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildColorSelector() {
    return Container(
      height: 230,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF30363D),
        ),
      ),
      child: Row(
        children: [
          // Rueda de colores a la izquierda
          Expanded(
            flex: 5,
            child: _buildColorWheel(),
          ),
          
          const SizedBox(width: 16),
          
          // Colores preestablecidos y header a la derecha
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header compacto
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFA78BFA).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const HeroIcon(
                        HeroIcons.swatch,
                        style: HeroIconStyle.solid,
                        color: Color(0xFFA78BFA),
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Color',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Muestra del color actual
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: _habitacionActual.encendida 
                            ? _habitacionActual.color 
                            : const Color(0xFF8B949E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: _habitacionActual.encendida
                            ? [
                                BoxShadow(
                                  color: _habitacionActual.color.withValues(alpha: 0.6),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Grid de colores preestablecidos
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildPresetColorCompact(const Color(0xFFFFFFFF)),
                      _buildPresetColorCompact(const Color(0xFFFFD700)),
                      _buildPresetColorCompact(const Color(0xFFFF6B6B)),
                      _buildPresetColorCompact(const Color(0xFF58A6FF)),
                      _buildPresetColorCompact(const Color(0xFF7EE787)),
                      _buildPresetColorCompact(const Color(0xFFA78BFA)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetColorCompact(Color color) {
    final isSelected = _habitacionActual.color.value == color.value;
    return GestureDetector(
      onTap: () => _cambiarColor(color),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.white : const Color(0xFF30363D),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.6),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.black54, size: 16)
            : null,
      ),
    );
  }

  Widget _buildColorWheel() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight);
        return Center(
          child: GestureDetector(
            onPanUpdate: (details) {
              _handleColorWheelTouch(details.localPosition, size);
            },
            onTapDown: (details) {
              _handleColorWheelTouch(details.localPosition, size);
            },
            child: SizedBox(
              width: size,
              height: size,
              child: CustomPaint(
                painter: ColorWheelPainter(
                  selectedColor: _habitacionActual.color,
                  brightness: _habitacionActual.brillo / 100,
                ),
                child: Center(
                  child: Container(
                    width: size * 0.38,
                    height: size * 0.38,
                    decoration: BoxDecoration(
                      color: _habitacionActual.encendida
                          ? _habitacionActual.color
                          : const Color(0xFF21262D),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF30363D),
                        width: 3,
                      ),
                      boxShadow: _habitacionActual.encendida
                          ? [
                              BoxShadow(
                                color: _habitacionActual.color.withValues(alpha: 0.5),
                                blurRadius: 24,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: HeroIcon(
                        HeroIcons.lightBulb,
                        style: _habitacionActual.encendida
                            ? HeroIconStyle.solid
                            : HeroIconStyle.outline,
                        color: _habitacionActual.encendida
                            ? Colors.white
                            : const Color(0xFF8B949E),
                        size: size * 0.12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleColorWheelTouch(Offset position, double size) {
    final center = Offset(size / 2, size / 2);
    final offset = position - center;
    final distance = offset.distance;
    final radius = size / 2;
    
    if (distance > radius * 0.42 && distance < radius) {
      final angle = math.atan2(offset.dy, offset.dx);
      final hue = ((angle * 180 / math.pi) + 360) % 360;
      final saturation = ((distance - radius * 0.42) / (radius * 0.58)).clamp(0.5, 1.0);
      
      final color = HSVColor.fromAHSV(1.0, hue, saturation, 1.0).toColor();
      _cambiarColor(color);
    }
  }

  Widget _buildIntensitySlider() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF30363D),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const HeroIcon(
                  HeroIcons.sun,
                  style: HeroIconStyle.solid,
                  color: Color(0xFFFFD700),
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Intensidad',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: _habitacionActual.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _habitacionActual.color.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '${_habitacionActual.brillo}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _habitacionActual.encendida
                        ? _habitacionActual.color
                        : const Color(0xFF8B949E),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Slider
          Row(
            children: [
              const HeroIcon(
                HeroIcons.moon,
                style: HeroIconStyle.outline,
                color: Color(0xFF8B949E),
                size: 18,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: _habitacionActual.encendida
                        ? _habitacionActual.color
                        : const Color(0xFF8B949E),
                    inactiveTrackColor: const Color(0xFF30363D),
                    thumbColor: _habitacionActual.encendida
                        ? _habitacionActual.color
                        : const Color(0xFF8B949E),
                    overlayColor: _habitacionActual.color.withValues(alpha: 0.2),
                    trackHeight: 8,
                    thumbShape: _CustomSliderThumb(
                      thumbRadius: 14,
                      color: _habitacionActual.encendida
                          ? _habitacionActual.color
                          : const Color(0xFF8B949E),
                    ),
                  ),
                  child: Slider(
                    value: _habitacionActual.brillo.toDouble(),
                    min: 0,
                    max: 100,
                    onChanged: _cambiarBrillo,
                  ),
                ),
              ),
              HeroIcon(
                HeroIcons.sun,
                style: HeroIconStyle.solid,
                color: _habitacionActual.encendida
                    ? _habitacionActual.color
                    : const Color(0xFF8B949E),
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHabitacionesBar() {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF30363D),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF58A6FF).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const HeroIcon(
                    HeroIcons.home,
                    style: HeroIconStyle.solid,
                    color: Color(0xFF58A6FF),
                    size: 14,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Ambientes',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF21262D),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${_habitacionSeleccionada + 1}/${_habitaciones.length}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF8B949E),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const HeroIcon(
                        HeroIcons.chevronRight,
                        style: HeroIconStyle.outline,
                        color: Color(0xFF8B949E),
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Lista horizontal de habitaciones
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              itemCount: _habitaciones.length,
              itemBuilder: (context, index) {
                return _buildHabitacionChip(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitacionChip(int index) {
    final habitacion = _habitaciones[index];
    final isSelected = _habitacionSeleccionada == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _habitacionSeleccionada = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? habitacion.color.withValues(alpha: 0.15)
              : const Color(0xFF21262D),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? habitacion.color.withValues(alpha: 0.6)
                : const Color(0xFF30363D),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: habitacion.color.withValues(alpha: 0.3),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono más grande
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    habitacion.color,
                    habitacion.gradientEnd,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: habitacion.color.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: habitacion.materialIcon != null
                  ? Icon(
                      habitacion.materialIcon,
                      color: Colors.white,
                      size: 22,
                    )
                  : HeroIcon(
                      habitacion.heroIcon!,
                      style: HeroIconStyle.solid,
                      color: Colors.white,
                      size: 22,
                    ),
            ),
            const SizedBox(width: 12),
            // Nombre y estado
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habitacion.nombre,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFFC9D1D9),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: habitacion.encendida
                            ? const Color(0xFF7EE787)
                            : const Color(0xFF8B949E),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      habitacion.encendida ? '${habitacion.brillo}%' : 'Apagado',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: habitacion.encendida
                            ? const Color(0xFF7EE787)
                            : const Color(0xFF8B949E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Bottom Navigation Bar
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
        // Navegar según el índice
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
}

// Modelo de datos
class HabitacionLuz {
  final String nombre;
  final HeroIcons? heroIcon;
  final IconData? materialIcon;
  Color color;
  final Color gradientEnd;
  int brillo;
  bool encendida;

  HabitacionLuz({
    required this.nombre,
    this.heroIcon,
    this.materialIcon,
    required this.color,
    required this.gradientEnd,
    required this.brillo,
    required this.encendida,
  });
}

// Painter para la rueda de colores
class ColorWheelPainter extends CustomPainter {
  final Color selectedColor;
  final double brightness;

  ColorWheelPainter({required this.selectedColor, required this.brightness});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    
    // Dibujar el anillo de color
    for (double angle = 0; angle < 360; angle += 1) {
      final paint = Paint()
        ..color = HSVColor.fromAHSV(1.0, angle, 1.0, brightness).toColor()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.25;
      
      final startAngle = (angle - 0.5) * math.pi / 180;
      final sweepAngle = 1.5 * math.pi / 180;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius * 0.76),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
    
    // Borde exterior
    final borderPaint = Paint()
      ..color = const Color(0xFF30363D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(center, radius * 0.90, borderPaint);
    canvas.drawCircle(center, radius * 0.62, borderPaint);
  }

  @override
  bool shouldRepaint(ColorWheelPainter oldDelegate) {
    return oldDelegate.selectedColor != selectedColor || 
           oldDelegate.brightness != brightness;
  }
}

// Thumb personalizado para el slider
class _CustomSliderThumb extends SliderComponentShape {
  final double thumbRadius;
  final Color color;

  _CustomSliderThumb({required this.thumbRadius, required this.color});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    // Sombra
    final shadowPaint = Paint()
      ..color = color.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(center, thumbRadius, shadowPaint);

    // Círculo exterior
    final outerPaint = Paint()..color = color;
    canvas.drawCircle(center, thumbRadius, outerPaint);

    // Círculo interior
    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, thumbRadius * 0.4, innerPaint);
  }
}
