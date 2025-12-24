import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'dart:math' as math;
import 'dart:async';
import '../theme/app_colors.dart';

class TermostatoPage extends StatefulWidget {
  const TermostatoPage({super.key});

  @override
  State<TermostatoPage> createState() => _TermostatoPageState();
}

class _TermostatoPageState extends State<TermostatoPage>
    with TickerProviderStateMixin {
  // Zona seleccionada
  int _zonaSeleccionada = 0;
  int _selectedNavIndex = 0;
  
  // Animación de parpadeo para alertas
  late AnimationController _alertBlinkController;
  late Animation<double> _alertBlinkAnimation;
  
  // Calcular total de alertas activas
  int get _totalAlertas {
    // Alertas de sensores (simuladas - en producción vendrían de un provider)
    final alertasSensores = 4; // Entrada, Baño Principal, Garage, Dormitorio 1
    
    // Alertas de cerraduras (simuladas)
    final alertasCerraduras = 4; // Garage abierta, Garage batería baja, Puerta Lateral batería baja, Puerta Lateral desconectada
    
    return alertasSensores + alertasCerraduras;
  }

  // Modos del termostato
  int _modoSeleccionado = 2; // 0: Off, 1: Frío, 2: Calor, 3: Auto

  // Animación del dial
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Control de aceleración para botones de temperatura
  Timer? _tempChangeTimer;
  double _currentAcceleration = 1.0;
  static const double _baseInterval = 150.0; // ms entre cambios iniciales (reducido de 250)
  static const double _minInterval = 15.0; // ms mínimo (máxima velocidad) (reducido de 40)
  static const double _accelerationRate = 0.5; // Factor de aceleración (menor = más rápido) (reducido de 0.7)

  // Límites de temperatura por modo
  static const double _tempMinFrio = 16.0;
  static const double _tempMaxFrio = 26.0;
  static const double _tempMinCalor = 18.0;
  static const double _tempMaxCalor = 28.0;
  static const double _tempMinAuto = 16.0;
  static const double _tempMaxAuto = 30.0;

  // Datos de las zonas
  final List<ZonaTermostato> _zonas = [
    ZonaTermostato(
      nombre: 'Sala',
      icono: HeroIcons.home,
      tempActual: 22.5,
      tempObjetivo: 24.0,
      tempMinAuto: 20.0,
      tempMaxAuto: 24.0,
      humedad: 45,
      encendido: true,
    ),
    ZonaTermostato(
      nombre: 'Dormitorio 1',
      icono: HeroIcons.moon,
      tempActual: 20.0,
      tempObjetivo: 21.0,
      tempMinAuto: 19.0,
      tempMaxAuto: 22.0,
      humedad: 50,
      encendido: true,
    ),
    ZonaTermostato(
      nombre: 'Cocina',
      icono: HeroIcons.fire,
      tempActual: 25.0,
      tempObjetivo: 23.0,
      tempMinAuto: 20.0,
      tempMaxAuto: 24.0,
      humedad: 38,
      encendido: false,
    ),
    ZonaTermostato(
      nombre: 'Baño',
      materialIcon: Icons.shower,
      tempActual: 24.0,
      tempObjetivo: 26.0,
      tempMinAuto: 22.0,
      tempMaxAuto: 26.0,
      humedad: 65,
      encendido: true,
    ),
    ZonaTermostato(
      nombre: 'Dormitorio 2',
      icono: HeroIcons.moon,
      tempActual: 19.5,
      tempObjetivo: 20.0,
      tempMinAuto: 18.0,
      tempMaxAuto: 21.0,
      humedad: 48,
      encendido: false,
    ),
    ZonaTermostato(
      nombre: 'Oficina',
      materialIcon: Icons.computer,
      tempActual: 23.0,
      tempObjetivo: 22.0,
      tempMinAuto: 20.0,
      tempMaxAuto: 23.0,
      humedad: 42,
      encendido: true,
    ),
  ];

  // Datos ambientales
  final double _tempExterior = 18.0;
  final String _calidadAire = 'Buena';

  // Modos disponibles
  final List<ModoTermostato> _modos = [
    ModoTermostato(
      nombre: 'Off',
      icono: Icons.power_settings_new,
      color: const Color(0xFF8B949E),
      gradientEnd: const Color(0xFF6E7681),
    ),
    ModoTermostato(
      nombre: 'Frío',
      icono: Icons.ac_unit,
      color: const Color(0xFF58A6FF),
      gradientEnd: const Color(0xFF0077B6),
    ),
    ModoTermostato(
      nombre: 'Calor',
      icono: Icons.whatshot,
      color: const Color(0xFFFF6B6B),
      gradientEnd: const Color(0xFFEE5A24),
    ),
    ModoTermostato(
      nombre: 'Auto',
      icono: Icons.autorenew,
      color: const Color(0xFF7EE787),
      gradientEnd: const Color(0xFF238636),
    ),
  ];

  ZonaTermostato get _zonaActual => _zonas[_zonaSeleccionada];
  ModoTermostato get _modoActual => _modos[_modoSeleccionado];

  // Obtener límites según el modo actual
  double get _tempMin {
    switch (_modoSeleccionado) {
      case 1: return _tempMinFrio;  // Frío
      case 2: return _tempMinCalor; // Calor
      case 3: return _tempMinAuto;  // Auto
      default: return 16.0;
    }
  }

  double get _tempMax {
    switch (_modoSeleccionado) {
      case 1: return _tempMaxFrio;  // Frío
      case 2: return _tempMaxCalor; // Calor
      case 3: return _tempMaxAuto;  // Auto
      default: return 30.0;
    }
  }

  // Obtener el estado actual del sistema
  String get _estadoSistema {
    if (!_zonaActual.encendido || _modoSeleccionado == 0) {
      return 'Apagado';
    }

    final tempActual = _zonaActual.tempActual;
    final tempObjetivo = _zonaActual.tempObjetivo;
    const histeresis = 0.5; // Margen para evitar encendidos/apagados constantes

    switch (_modoSeleccionado) {
      case 1: // Frío
        if (tempActual > tempObjetivo + histeresis) {
          return 'Enfriando...';
        }
        return 'En reposo';
      
      case 2: // Calor
        if (tempActual < tempObjetivo - histeresis) {
          return 'Calentando...';
        }
        return 'En reposo';
      
      case 3: // Auto
        if (tempActual > _zonaActual.tempMaxAuto + histeresis) {
          return 'Enfriando...';
        }
        if (tempActual < _zonaActual.tempMinAuto - histeresis) {
          return 'Calentando...';
        }
        return 'Confort';
      
      default:
        return 'Apagado';
    }
  }

  // Color del estado
  Color get _colorEstado {
    switch (_estadoSistema) {
      case 'Enfriando...':
        return const Color(0xFF58A6FF);
      case 'Calentando...':
        return const Color(0xFFFF6B6B);
      case 'Confort':
        return const Color(0xFF7EE787);
      case 'En reposo':
        return const Color(0xFF7EE787);
      default:
        return const Color(0xFF8B949E);
    }
  }

  // Icono del estado
  IconData get _iconoEstado {
    switch (_estadoSistema) {
      case 'Enfriando...':
        return Icons.ac_unit;
      case 'Calentando...':
        return Icons.whatshot;
      case 'Confort':
        return Icons.check_circle;
      case 'En reposo':
        return Icons.pause_circle_outline;
      default:
        return Icons.power_settings_new;
    }
  }

  @override
  void initState() {
    super.initState();
    // Animación de parpadeo para alertas
    _alertBlinkController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    if (_totalAlertas > 0) {
      _alertBlinkController.repeat(reverse: true);
    }
    
    _alertBlinkAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _alertBlinkController, curve: Curves.easeInOut),
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _alertBlinkController.dispose();
    _tempChangeTimer?.cancel();
    super.dispose();
  }

  void _cambiarTemperatura(double delta) {
    setState(() {
      if (_modoSeleccionado == 3) {
        // En modo Auto, ajustamos ambos límites manteniendo la diferencia
        final diferencia = _zonaActual.tempMaxAuto - _zonaActual.tempMinAuto;
        _zonaActual.tempMinAuto = (_zonaActual.tempMinAuto + delta).clamp(_tempMinAuto, _tempMaxAuto - diferencia);
        _zonaActual.tempMaxAuto = _zonaActual.tempMinAuto + diferencia;
        _zonaActual.tempObjetivo = (_zonaActual.tempMinAuto + _zonaActual.tempMaxAuto) / 2;
      } else {
        _zonas[_zonaSeleccionada].tempObjetivo =
            (_zonas[_zonaSeleccionada].tempObjetivo + delta).clamp(_tempMin, _tempMax);
      }
      
      if (_modoSeleccionado == 0) {
        _modoSeleccionado = 3; // Auto
      }
      _zonas[_zonaSeleccionada].encendido = true;
    });
  }

  void _iniciarCambioTemperatura(double delta) {
    // Cambio inmediato al presionar
    _cambiarTemperatura(delta);
    
    // Reiniciar aceleración
    _currentAcceleration = 1.0;
    
    // Cancelar timer existente si hay uno
    _tempChangeTimer?.cancel();
    
    // Crear nuevo timer con aceleración progresiva
    void _scheduleNextChange() {
      final interval = (_baseInterval * _currentAcceleration).clamp(_minInterval, _baseInterval);
      
      _tempChangeTimer = Timer(Duration(milliseconds: interval.toInt()), () {
        if (mounted) {
          _cambiarTemperatura(delta);
          // Acelerar para el próximo cambio
          _currentAcceleration *= _accelerationRate;
          _scheduleNextChange();
        }
      });
    }
    
    _scheduleNextChange();
  }

  void _detenerCambioTemperatura() {
    _tempChangeTimer?.cancel();
    _tempChangeTimer = null;
    _currentAcceleration = 1.0;
  }

  void _setTemperatura(double temp) {
    setState(() {
      if (_modoSeleccionado == 3) {
        // En modo Auto, ajustar el rango centrado en la temperatura seleccionada
        final rangoMitad = (_zonaActual.tempMaxAuto - _zonaActual.tempMinAuto) / 2;
        _zonaActual.tempMinAuto = (temp - rangoMitad).clamp(_tempMinAuto, _tempMaxAuto - 2);
        _zonaActual.tempMaxAuto = (temp + rangoMitad).clamp(_tempMinAuto + 2, _tempMaxAuto);
        _zonaActual.tempObjetivo = temp.clamp(_zonaActual.tempMinAuto, _zonaActual.tempMaxAuto);
      } else {
        _zonas[_zonaSeleccionada].tempObjetivo = temp.clamp(_tempMin, _tempMax);
      }
      
      if (_modoSeleccionado == 0) {
        _modoSeleccionado = 3;
      }
      _zonas[_zonaSeleccionada].encendido = true;
    });
  }

  void _cambiarModo(int nuevoModo) {
    setState(() {
      _modoSeleccionado = nuevoModo;
      
      if (nuevoModo == 0) {
        // Off
        _zonas[_zonaSeleccionada].encendido = false;
      } else {
        _zonas[_zonaSeleccionada].encendido = true;
        
        // Ajustar temperatura objetivo según el nuevo modo
        switch (nuevoModo) {
          case 1: // Frío
            if (_zonaActual.tempObjetivo > _tempMaxFrio) {
              _zonaActual.tempObjetivo = _tempMaxFrio;
            }
            if (_zonaActual.tempObjetivo < _tempMinFrio) {
              _zonaActual.tempObjetivo = _tempMinFrio;
            }
            break;
          case 2: // Calor
            if (_zonaActual.tempObjetivo > _tempMaxCalor) {
              _zonaActual.tempObjetivo = _tempMaxCalor;
            }
            if (_zonaActual.tempObjetivo < _tempMinCalor) {
              _zonaActual.tempObjetivo = _tempMinCalor;
            }
            break;
          case 3: // Auto - usar el rango predefinido de la zona
            _zonaActual.tempObjetivo = (_zonaActual.tempMinAuto + _zonaActual.tempMaxAuto) / 2;
            break;
        }
      }
    });
  }

  void _toggleTermostato() {
    setState(() {
      _zonas[_zonaSeleccionada].encendido =
          !_zonas[_zonaSeleccionada].encendido;
      if (!_zonas[_zonaSeleccionada].encendido) {
        _modoSeleccionado = 0;
      } else if (_modoSeleccionado == 0) {
        _modoSeleccionado = 3;
      }
    });
  }

  Color _getTemperaturaColor() {
    if (_modoSeleccionado == 0 || !_zonaActual.encendido) {
      return const Color(0xFF8B949E);
    }
    if (_modoSeleccionado == 1) return const Color(0xFF58A6FF);
    if (_modoSeleccionado == 2) return const Color(0xFFFF6B6B);

    // Auto: basado en la acción actual
    final tempActual = _zonaActual.tempActual;
    if (tempActual > _zonaActual.tempMaxAuto) return const Color(0xFF58A6FF); // Enfriando
    if (tempActual < _zonaActual.tempMinAuto) return const Color(0xFFFF6B6B); // Calentando
    return const Color(0xFF7EE787); // En zona de confort
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

              // Dial de temperatura (protagonista)
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildTemperaturaDial(),
                ),
              ),

              const SizedBox(height: 12),

              // Selector de modos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildModoSelector(),
              ),

              const SizedBox(height: 14),

              // Selector de zonas
              _buildZonasSelector(),

              const SizedBox(height: 14),

              // Info ambiental
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: _buildInfoAmbiental(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
    final isAlertas = index == 2;
    final tieneAlertas = _totalAlertas > 0;
    
    // Color para el icono de alertas: rojo parpadeante si hay alertas, normal si no
    Color iconColor;
    if (isAlertas && tieneAlertas && !isSelected) {
      // Usar AnimatedBuilder para el parpadeo
      return AnimatedBuilder(
        animation: _alertBlinkAnimation,
        builder: (context, child) {
          // Parpadeo entre rojo intenso y rojo más claro para mayor visibilidad
          iconColor = Color.lerp(
            const Color(0xFFF85149), // Rojo intenso
            const Color(0xFFFF6B6B), // Rojo más claro
            _alertBlinkAnimation.value,
          )!;
          return _buildNavItemContent(icon, label, index, isSelected, iconColor);
        },
      );
    } else {
      iconColor = isSelected ? const Color(0xFF58A6FF) : const Color(0xFF8B949E);
      return _buildNavItemContent(icon, label, index, isSelected, iconColor);
    }
  }

  Widget _buildNavItemContent(
    HeroIcons icon,
    String label,
    int index,
    bool isSelected,
    Color color,
  ) {
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
                  'Control Termostato',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _zonaActual.nombre,
                  style: TextStyle(
                    fontSize: 13,
                    color: _getTemperaturaColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Botón de encendido/apagado
          GestureDetector(
            onTap: _toggleTermostato,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _zonaActual.encendido
                    ? _getTemperaturaColor().withValues(alpha: 0.2)
                    : const Color(0xFF21262D),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _zonaActual.encendido
                      ? _getTemperaturaColor().withValues(alpha: 0.5)
                      : const Color(0xFF30363D),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: _zonaActual.encendido
                        ? _getTemperaturaColor()
                        : const Color(0xFF8B949E),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _zonaActual.encendido ? 'ON' : 'OFF',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _zonaActual.encendido
                          ? _getTemperaturaColor()
                          : const Color(0xFF8B949E),
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

  Widget _buildTemperaturaDial() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF30363D),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = math.min(constraints.maxWidth, constraints.maxHeight);
          return Center(
            child: SizedBox(
              width: size,
              height: size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Arco de temperatura
                  GestureDetector(
                    onPanUpdate: (details) {
                      _handleDialTouch(details.localPosition, size);
                    },
                    onTapDown: (details) {
                      _handleDialTouch(details.localPosition, size);
                    },
                    child: CustomPaint(
                      size: Size(size, size),
                      painter: TemperatureDialPainter(
                        currentTemp: _zonaActual.tempActual,
                        targetTemp: _zonaActual.tempObjetivo,
                        minTemp: _tempMin,
                        maxTemp: _tempMax,
                        activeColor: _getTemperaturaColor(),
                        isActive: _zonaActual.encendido,
                        modo: _modoSeleccionado,
                        tempMinAuto: _zonaActual.tempMinAuto,
                        tempMaxAuto: _zonaActual.tempMaxAuto,
                      ),
                    ),
                  ),

                  // Centro del dial con temperatura
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      final isWorking = _estadoSistema == 'Enfriando...' || 
                                        _estadoSistema == 'Calentando...';
                      return Transform.scale(
                        scale: isWorking ? _pulseAnimation.value : 1.0,
                        child: child,
                      );
                    },
                    child: Container(
                      width: size * 0.55,
                      height: size * 0.55,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D1117),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _zonaActual.encendido
                              ? _getTemperaturaColor().withValues(alpha: 0.3)
                              : const Color(0xFF30363D),
                          width: 3,
                        ),
                        boxShadow: _zonaActual.encendido
                            ? [
                                BoxShadow(
                                  color:
                                      _getTemperaturaColor().withValues(alpha: 0.3),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Temperatura actual
                          Text(
                            'Actual',
                            style: TextStyle(
                              fontSize: size * 0.04,
                              color: const Color(0xFF8B949E),
                            ),
                          ),
                          Text(
                            '${_zonaActual.tempActual.toStringAsFixed(1)}°',
                            style: TextStyle(
                              fontSize: size * 0.07,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFC9D1D9),
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Temperatura objetivo o rango
                          if (_modoSeleccionado == 3) ...[
                            // Modo Auto: mostrar rango
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${_zonaActual.tempMinAuto.toStringAsFixed(0)}°',
                                  style: TextStyle(
                                    fontSize: size * 0.09,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF58A6FF),
                                  ),
                                ),
                                Text(
                                  ' - ',
                                  style: TextStyle(
                                    fontSize: size * 0.07,
                                    color: const Color(0xFF8B949E),
                                  ),
                                ),
                                Text(
                                  '${_zonaActual.tempMaxAuto.toStringAsFixed(0)}°',
                                  style: TextStyle(
                                    fontSize: size * 0.09,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFF6B6B),
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            // Modos Frío/Calor: temperatura única
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _zonaActual.tempObjetivo.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: size * 0.14,
                                    fontWeight: FontWeight.bold,
                                    color: _zonaActual.encendido
                                        ? Colors.white
                                        : const Color(0xFF8B949E),
                                  ),
                                ),
                                Text(
                                  '°C',
                                  style: TextStyle(
                                    fontSize: size * 0.05,
                                    fontWeight: FontWeight.w500,
                                    color: _getTemperaturaColor(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 4),
                          // Estado del sistema
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _colorEstado.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _iconoEstado,
                                  size: size * 0.04,
                                  color: _colorEstado,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _estadoSistema,
                                  style: TextStyle(
                                    fontSize: size * 0.035,
                                    fontWeight: FontWeight.w600,
                                    color: _colorEstado,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Botones +/- con aceleración
                  Positioned(
                    left: 10,
                    child: _buildTempButton(
                      icon: Icons.remove,
                      delta: -0.5,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    child: _buildTempButton(
                      icon: Icons.add,
                      delta: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleDialTouch(Offset position, double size) {
    if (_modoSeleccionado == 0) return; // No ajustar si está apagado

    final center = Offset(size / 2, size / 2);
    final offset = position - center;
    final angle = math.atan2(offset.dy, offset.dx);

    // Convertir ángulo a temperatura
    double normalizedAngle = (angle * 180 / math.pi + 360) % 360;

    // Solo permitir ajuste en el arco válido (135° a 405°/45°)
    if (normalizedAngle >= 135 || normalizedAngle <= 45) {
      double tempRange = _tempMax - _tempMin;
      double angleRange = 270.0;

      double angleOffset;
      if (normalizedAngle >= 135) {
        angleOffset = normalizedAngle - 135;
      } else {
        angleOffset = normalizedAngle + 225;
      }

      double temp = _tempMin + (angleOffset / angleRange) * tempRange;
      _setTemperatura(temp);
    }
  }

  Widget _buildTempButton({required IconData icon, required double delta}) {
    return GestureDetector(
      onTapDown: (_) {
        _iniciarCambioTemperatura(delta);
      },
      onTapUp: (_) {
        _detenerCambioTemperatura();
      },
      onTapCancel: () {
        _detenerCambioTemperatura();
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF21262D),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF30363D),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildModoSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF30363D),
        ),
      ),
      child: Column(
        children: [
          // Header con info del rango
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _modoActual.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _modoActual.icono,
                    color: _modoActual.color,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Modo ${_modoActual.nombre}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                // Mostrar rango permitido
                if (_modoSeleccionado != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF21262D),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _modoSeleccionado == 3 
                          ? 'Rango: ${_tempMinAuto.toInt()}° - ${_tempMaxAuto.toInt()}°'
                          : 'Límite: ${_tempMin.toInt()}° - ${_tempMax.toInt()}°',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8B949E),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Botones de modo
          Row(
            children: _modos.asMap().entries.map((entry) {
              final index = entry.key;
              final modo = entry.value;
              final isSelected = _modoSeleccionado == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () => _cambiarModo(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(right: index < _modos.length - 1 ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [modo.color, modo.gradientEnd],
                            )
                          : null,
                      color: isSelected ? null : const Color(0xFF21262D),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? modo.color.withValues(alpha: 0.5)
                            : const Color(0xFF30363D),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: modo.color.withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          modo.icono,
                          color: isSelected ? Colors.white : const Color(0xFF8B949E),
                          size: 22,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          modo.nombre,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.white : const Color(0xFF8B949E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildZonasSelector() {
    return Container(
      height: 120,
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
            padding: const EdgeInsets.fromLTRB(14, 5, 14, 1),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.thermostat,
                    color: Color(0xFFFF6B6B),
                    size: 14,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Zonas',
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
                        '${_zonaSeleccionada + 1}/${_zonas.length}',
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

          // Lista horizontal de zonas
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
              itemCount: _zonas.length,
              itemBuilder: (context, index) {
                return _buildZonaChip(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZonaChip(int index) {
    final zona = _zonas[index];
    final isSelected = _zonaSeleccionada == index;
    final color = zona.encendido ? _modos[_modoSeleccionado].color : const Color(0xFF8B949E);

    return GestureDetector(
      onTap: () {
        setState(() {
          _zonaSeleccionada = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : const Color(0xFF21262D),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.6)
                : const Color(0xFF30363D),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.2)
                    : const Color(0xFF30363D),
                borderRadius: BorderRadius.circular(10),
              ),
              child: zona.materialIcon != null
                  ? Icon(
                      zona.materialIcon,
                      color: isSelected ? color : const Color(0xFF8B949E),
                      size: 18,
                    )
                  : HeroIcon(
                      zona.icono!,
                      style: HeroIconStyle.solid,
                      color: isSelected ? color : const Color(0xFF8B949E),
                      size: 18,
                    ),
            ),
            const SizedBox(width: 10),
            // Info
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  zona.nombre,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFFC9D1D9),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '${zona.tempActual.toStringAsFixed(1)}°',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? color : const Color(0xFF8B949E),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 10,
                      color: const Color(0xFF8B949E),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${zona.tempObjetivo.toStringAsFixed(1)}°',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: zona.encendido ? color : const Color(0xFF8B949E),
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

  Widget _buildInfoAmbiental() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF30363D),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            icon: Icons.water_drop,
            label: 'Humedad',
            value: '${_zonaActual.humedad}%',
            color: const Color(0xFF58A6FF),
          ),
          Container(
            width: 1,
            height: 35,
            color: const Color(0xFF30363D),
          ),
          _buildInfoItem(
            icon: Icons.thermostat_outlined,
            label: 'Exterior',
            value: '${_tempExterior.toStringAsFixed(0)}°C',
            color: const Color(0xFF7EE787),
          ),
          Container(
            width: 1,
            height: 35,
            color: const Color(0xFF30363D),
          ),
          _buildInfoItem(
            icon: Icons.air,
            label: 'Aire',
            value: _calidadAire,
            color: const Color(0xFFA78BFA),
          ),
        ],
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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF8B949E),
          ),
        ),
      ],
    );
  }
}

// Painter para el dial de temperatura
class TemperatureDialPainter extends CustomPainter {
  final double currentTemp;
  final double targetTemp;
  final double minTemp;
  final double maxTemp;
  final Color activeColor;
  final bool isActive;
  final int modo;
  final double tempMinAuto;
  final double tempMaxAuto;

  TemperatureDialPainter({
    required this.currentTemp,
    required this.targetTemp,
    required this.minTemp,
    required this.maxTemp,
    required this.activeColor,
    required this.isActive,
    required this.modo,
    required this.tempMinAuto,
    required this.tempMaxAuto,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 15;

    // Ángulo inicial y final del arco (135° a 405° = 270° de arco)
    const startAngle = 135 * math.pi / 180;
    const sweepAngle = 270 * math.pi / 180;

    // Fondo del arco
    final bgPaint = Paint()
      ..color = const Color(0xFF21262D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    if (!isActive) return;

    final tempRange = maxTemp - minTemp;

    if (modo == 3) {
      // Modo Auto: dibujar zona de confort (rango entre min y max auto)
      final minProgress = (tempMinAuto - minTemp) / tempRange;
      final maxProgress = (tempMaxAuto - minTemp) / tempRange;
      final minAngle = startAngle + (minProgress * sweepAngle);
      final rangeSweep = (maxProgress - minProgress) * sweepAngle;

      // Gradiente para la zona de confort
      final comfortPaint = Paint()
        ..color = const Color(0xFF7EE787).withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        minAngle,
        rangeSweep,
        false,
        comfortPaint,
      );

      // Marcadores de límites
      _drawLimitMarker(canvas, center, radius, minAngle, const Color(0xFF58A6FF));
      _drawLimitMarker(canvas, center, radius, minAngle + rangeSweep, const Color(0xFFFF6B6B));
    } else {
      // Modo Frío o Calor: dibujar progreso hasta la temperatura objetivo
      final targetProgress = (targetTemp - minTemp) / tempRange;
      final targetSweep = targetProgress * sweepAngle;

      // Color según el modo
      Color progressColor;
      if (modo == 1) {
        progressColor = const Color(0xFF58A6FF); // Frío
      } else {
        progressColor = const Color(0xFFFF6B6B); // Calor
      }

      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        targetSweep,
        false,
        progressPaint,
      );
    }

    // Marcador de temperatura actual (siempre visible)
    final currentProgress = ((currentTemp - minTemp) / tempRange).clamp(0.0, 1.0);
    final currentAngle = startAngle + (currentProgress * sweepAngle);
    final markerOffset = Offset(
      center.dx + radius * math.cos(currentAngle),
      center.dy + radius * math.sin(currentAngle),
    );

    // Sombra del marcador
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(markerOffset, 8, shadowPaint);

    // Marcador
    final markerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(markerOffset, 7, markerPaint);

    // Borde del marcador
    final markerBorderPaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(markerOffset, 7, markerBorderPaint);

    // Marcas de temperatura
    for (int temp = minTemp.toInt(); temp <= maxTemp.toInt(); temp += 2) {
      final progress = (temp - minTemp) / tempRange;
      final angle = startAngle + (progress * sweepAngle);
      final isMain = temp % 4 == 0;

      final innerRadius = radius - (isMain ? 30 : 26);
      final outerRadius = radius - 22;

      final start = Offset(
        center.dx + innerRadius * math.cos(angle),
        center.dy + innerRadius * math.sin(angle),
      );
      final end = Offset(
        center.dx + outerRadius * math.cos(angle),
        center.dy + outerRadius * math.sin(angle),
      );

      final tickPaint = Paint()
        ..color = const Color(0xFF8B949E).withValues(alpha: isMain ? 0.8 : 0.4)
        ..strokeWidth = isMain ? 2 : 1
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(start, end, tickPaint);
    }
  }

  void _drawLimitMarker(Canvas canvas, Offset center, double radius, double angle, Color color) {
    final markerOffset = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(markerOffset, 10, paint);

    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(markerOffset, 5, innerPaint);
  }

  @override
  bool shouldRepaint(TemperatureDialPainter oldDelegate) {
    return oldDelegate.currentTemp != currentTemp ||
        oldDelegate.targetTemp != targetTemp ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.isActive != isActive ||
        oldDelegate.modo != modo ||
        oldDelegate.tempMinAuto != tempMinAuto ||
        oldDelegate.tempMaxAuto != tempMaxAuto;
  }
}

// Modelos de datos
class ZonaTermostato {
  final String nombre;
  final HeroIcons? icono;
  final IconData? materialIcon;
  double tempActual;
  double tempObjetivo;
  double tempMinAuto; // Temperatura mínima en modo Auto
  double tempMaxAuto; // Temperatura máxima en modo Auto
  int humedad;
  bool encendido;

  ZonaTermostato({
    required this.nombre,
    this.icono,
    this.materialIcon,
    required this.tempActual,
    required this.tempObjetivo,
    required this.tempMinAuto,
    required this.tempMaxAuto,
    required this.humedad,
    required this.encendido,
  });
}

class ModoTermostato {
  final String nombre;
  final IconData icono;
  final Color color;
  final Color gradientEnd;

  ModoTermostato({
    required this.nombre,
    required this.icono,
    required this.color,
    required this.gradientEnd,
  });
}

