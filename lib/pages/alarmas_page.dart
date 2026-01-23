import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'dart:math' as math;
import '../theme/app_colors.dart';

class AlarmasPage extends StatefulWidget {
  const AlarmasPage({super.key});

  @override
  State<AlarmasPage> createState() => _AlarmasPageState();
}

class _AlarmasPageState extends State<AlarmasPage> with SingleTickerProviderStateMixin {
  int _selectedNavIndex = 2;
  
  // Estado del sistema de alarmas
  bool _sistemaActivado = false;
  ModoAlarma _modoActual = ModoAlarma.desactivado;
  
  // Animación para el estado activado
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Zonas de alarma
  final List<ZonaAlarma> _zonas = [
    ZonaAlarma(
      nombre: 'Entrada Principal',
      icono: HeroIcons.home,
      sensores: 3,
      activa: true,
      ultimaActivacion: 'Hace 2 horas',
      bateria: 85,
    ),
    ZonaAlarma(
      nombre: 'Dormitorio 1',
      icono: HeroIcons.moon,
      sensores: 2,
      activa: true,
      ultimaActivacion: 'Hace 1 hora',
      bateria: 92,
    ),
    ZonaAlarma(
      nombre: 'Cocina',
      icono: HeroIcons.fire,
      sensores: 2,
      activa: true,
      ultimaActivacion: 'Hace 30 min',
      bateria: 78,
    ),
    ZonaAlarma(
      nombre: 'Garage',
      icono: HeroIcons.rectangleStack,
      sensores: 4,
      activa: false,
      ultimaActivacion: 'Hace 5 horas',
      bateria: 65,
    ),
    ZonaAlarma(
      nombre: 'Jardín',
      materialIcon: Symbols.eco,
      sensores: 3,
      activa: true,
      ultimaActivacion: 'Hace 10 min',
      bateria: 88,
    ),
  ];

  // Sensores activos
  final List<SensorAlarma> _sensores = [
    SensorAlarma(
      nombre: 'Sensor Movimiento - Entrada',
      tipo: TipoSensor.movimiento,
      estado: EstadoSensor.activo,
      bateria: 85,
      ultimaActivacion: 'Hace 2 horas',
    ),
    SensorAlarma(
      nombre: 'Sensor Puerta - Principal',
      tipo: TipoSensor.puerta,
      estado: EstadoSensor.activo,
      bateria: 92,
      ultimaActivacion: 'Hace 1 hora',
    ),
    SensorAlarma(
      nombre: 'Sensor Ventana - Dormitorio 1',
      tipo: TipoSensor.ventana,
      estado: EstadoSensor.activo,
      bateria: 78,
      ultimaActivacion: 'Hace 30 min',
    ),
    SensorAlarma(
      nombre: 'Sensor Movimiento - Cocina',
      tipo: TipoSensor.movimiento,
      estado: EstadoSensor.inactivo,
      bateria: 65,
      ultimaActivacion: 'Hace 5 horas',
    ),
    SensorAlarma(
      nombre: 'Sensor Puerta - Garage',
      tipo: TipoSensor.puerta,
      estado: EstadoSensor.activo,
      bateria: 88,
      ultimaActivacion: 'Hace 10 min',
    ),
  ];

  // Historial de eventos
  final List<EventoAlarma> _historial = [
    EventoAlarma(
      tipo: TipoEvento.activacion,
      mensaje: 'Sistema activado en modo Casa',
      hora: '14:30',
      fecha: 'Hoy',
      icono: Symbols.shield,
      color: const Color(0xFF7EE787),
    ),
    EventoAlarma(
      tipo: TipoEvento.sensor,
      mensaje: 'Movimiento detectado en Entrada',
      hora: '12:15',
      fecha: 'Hoy',
      icono: Symbols.directions_run,
      color: const Color(0xFFFFB347),
    ),
    EventoAlarma(
      tipo: TipoEvento.sensor,
      mensaje: 'Puerta abierta en Garage',
      hora: '11:45',
      fecha: 'Hoy',
      icono: Icons.door_front_door,
      color: const Color(0xFFFF6B6B),
    ),
    EventoAlarma(
      tipo: TipoEvento.desactivacion,
      mensaje: 'Sistema desactivado',
      hora: '08:00',
      fecha: 'Hoy',
      icono: Icons.shield_outlined,
      color: const Color(0xFF8B949E),
    ),
  ];

  // Estadísticas
  int get _zonasActivas => _zonas.where((z) => z.activa).length;
  int get _sensoresActivos => _sensores.where((s) => s.estado == EstadoSensor.activo).length;
  int get _sensoresBateriaBaja => _sensores.where((s) => s.bateria < 30).length;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
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

              // Estado del sistema
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildEstadoSistema(),
              ),

              const SizedBox(height: 16),

              // Contenido
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Estadísticas
                      _buildEstadisticas(),

                      const SizedBox(height: 20),

                      // Modos de alarma
                      _buildModosAlarma(),

                      const SizedBox(height: 20),

                      // Zonas de alarma
                      _buildTituloSeccion('Zonas de Alarma'),
                      const SizedBox(height: 12),
                      _buildListaZonas(),

                      const SizedBox(height: 20),

                      // Sensores
                      _buildTituloSeccion('Sensores'),
                      const SizedBox(height: 12),
                      _buildListaSensores(),

                      const SizedBox(height: 20),

                      // Historial
                      _buildTituloSeccion('Historial de Eventos'),
                      const SizedBox(height: 12),
                      _buildHistorial(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
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
                  'Sistema de Alarmas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _sistemaActivado ? 'Sistema Activado' : 'Sistema Desactivado',
                  style: TextStyle(
                    fontSize: 13,
                    color: _sistemaActivado
                        ? const Color(0xFF7EE787)
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Botón de configuración
          GestureDetector(
            onTap: () {
              _mostrarConfiguracion();
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
                HeroIcons.cog6Tooth,
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

  Widget _buildEstadoSistema() {
    return GestureDetector(
      onTap: () {
        _toggleSistema();
      },
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _sistemaActivado ? _pulseAnimation.value : 1.0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: _sistemaActivado
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF7EE787),
                          Color(0xFF238636),
                        ],
                      )
                    : null,
                color: _sistemaActivado ? null : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _sistemaActivado
                      ? const Color(0xFF7EE787)
                      : AppColors.cardBorder,
                  width: 2,
                ),
                boxShadow: _sistemaActivado
                    ? [
                        BoxShadow(
                          color: const Color(0xFF7EE787).withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _sistemaActivado ? Symbols.shield : Icons.shield_outlined,
                    size: 32,
                    color: _sistemaActivado ? Colors.white : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      Text(
                        _sistemaActivado ? 'SISTEMA ACTIVADO' : 'SISTEMA DESACTIVADO',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _sistemaActivado ? Colors.white : AppColors.textPrimary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _sistemaActivado
                            ? _getTextoModo(_modoActual)
                            : 'Toca para activar',
                        style: TextStyle(
                          fontSize: 12,
                          color: _sistemaActivado
                              ? Colors.white.withValues(alpha: 0.9)
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEstadisticas() {
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
              icon: Symbols.shield,
              label: 'Zonas Activas',
              value: '$_zonasActivas',
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
              icon: Symbols.sensors,
              label: 'Sensores',
              value: '$_sensoresActivos',
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
              icon: Symbols.battery_1_bar,
              label: 'Batería Baja',
              value: '$_sensoresBateriaBaja',
              color: const Color(0xFFFFB347),
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildModosAlarma() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Modo de Alarma',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildModoButton(
                  modo: ModoAlarma.desactivado,
                  icon: Icons.shield_outlined,
                  label: 'Desactivado',
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildModoButton(
                  modo: ModoAlarma.casa,
                  icon: Symbols.home,
                  label: 'Casa',
                  color: const Color(0xFF58A6FF),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildModoButton(
                  modo: ModoAlarma.fuera,
                  icon: Icons.door_front_door,
                  label: 'Fuera',
                  color: const Color(0xFFFF6B6B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModoButton({
    required ModoAlarma modo,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final isSelected = _modoActual == modo;
    return GestureDetector(
      onTap: () {
        setState(() {
          _modoActual = modo;
          if (modo != ModoAlarma.desactivado) {
          _sistemaActivado = true;
        } else {
          _sistemaActivado = false;
        }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : AppColors.cardBackgroundAlt,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.5)
                : AppColors.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: isSelected ? color : AppColors.textSecondary),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? color : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTituloSeccion(String titulo) {
    return Text(
      titulo,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildListaZonas() {
    return Column(
      children: _zonas.map((zona) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildZonaCard(zona),
        );
      }).toList(),
    );
  }

  Widget _buildZonaCard(ZonaAlarma zona) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: zona.activa
              ? const Color(0xFF7EE787).withValues(alpha: 0.3)
              : AppColors.cardBorder,
          width: zona.activa ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  zona.activa ? const Color(0xFF7EE787) : AppColors.textSecondary,
                  (zona.activa ? const Color(0xFF7EE787) : AppColors.textSecondary)
                      .withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: zona.materialIcon != null
                ? Icon(
                    zona.materialIcon,
                    color: Colors.white,
                    size: 20,
                  )
                : HeroIcon(
                    zona.icono!,
                    style: HeroIconStyle.solid,
                    color: Colors.white,
                    size: 20,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  zona.nombre,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Symbols.sensors,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${zona.sensores} sensores',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: zona.activa
                            ? const Color(0xFF7EE787)
                            : AppColors.textSecondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      zona.activa ? 'Activa' : 'Inactiva',
                      style: TextStyle(
                        fontSize: 12,
                        color: zona.activa
                            ? const Color(0xFF7EE787)
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                _getIconoBateria(zona.bateria),
                size: 16,
                color: _getColorBateria(zona.bateria),
              ),
              const SizedBox(height: 2),
              Text(
                '${zona.bateria}%',
                style: TextStyle(
                  fontSize: 10,
                  color: _getColorBateria(zona.bateria),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListaSensores() {
    return Column(
      children: _sensores.map((sensor) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildSensorCard(sensor),
        );
      }).toList(),
    );
  }

  Widget _buildSensorCard(SensorAlarma sensor) {
    final colorEstado = sensor.estado == EstadoSensor.activo
        ? const Color(0xFF7EE787)
        : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: sensor.estado == EstadoSensor.activo
              ? colorEstado.withValues(alpha: 0.3)
              : AppColors.cardBorder,
          width: sensor.estado == EstadoSensor.activo ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _getColorTipoSensor(sensor.tipo).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIconoTipoSensor(sensor.tipo),
              size: 20,
              color: _getColorTipoSensor(sensor.tipo),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sensor.nombre,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: colorEstado,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      sensor.estado == EstadoSensor.activo ? 'Activo' : 'Inactivo',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorEstado,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                _getIconoBateria(sensor.bateria),
                size: 16,
                color: _getColorBateria(sensor.bateria),
              ),
              const SizedBox(height: 2),
              Text(
                '${sensor.bateria}%',
                style: TextStyle(
                  fontSize: 10,
                  color: _getColorBateria(sensor.bateria),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistorial() {
    return Column(
      children: _historial.map((evento) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildEventoCard(evento),
        );
      }).toList(),
    );
  }

  Widget _buildEventoCard(EventoAlarma evento) {
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: evento.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              evento.icono,
              size: 20,
              color: evento.color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evento.mensaje,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${evento.fecha} a las ${evento.hora}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconoTipoSensor(TipoSensor tipo) {
    switch (tipo) {
      case TipoSensor.movimiento:
        return Symbols.directions_run;
      case TipoSensor.puerta:
        return Icons.door_front_door;
      case TipoSensor.ventana:
        return Symbols.window;
    }
  }

  Color _getColorTipoSensor(TipoSensor tipo) {
    switch (tipo) {
      case TipoSensor.movimiento:
        return const Color(0xFFFFB347);
      case TipoSensor.puerta:
        return const Color(0xFF58A6FF);
      case TipoSensor.ventana:
        return const Color(0xFFA78BFA);
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

  String _getTextoModo(ModoAlarma modo) {
    switch (modo) {
      case ModoAlarma.desactivado:
        return 'Desactivado';
      case ModoAlarma.casa:
        return 'Modo Casa';
      case ModoAlarma.fuera:
        return 'Modo Fuera';
    }
  }

  void _toggleSistema() {
    setState(() {
      _sistemaActivado = !_sistemaActivado;
      if (!_sistemaActivado) {
        _modoActual = ModoAlarma.desactivado;
      } else if (_modoActual == ModoAlarma.desactivado) {
        _modoActual = ModoAlarma.casa;
      }
    });
    _mostrarSnackbar(
      _sistemaActivado
          ? 'Sistema de alarmas activado'
          : 'Sistema de alarmas desactivado',
    );
  }

  void _mostrarConfiguracion() {
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
              'Configuración de Alarmas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.schedule, color: Color(0xFF58A6FF)),
              title: const Text(
                'Horarios Automáticos',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Programar activación automática',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _mostrarSnackbar('Funcionalidad en desarrollo');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Color(0xFFFFB347)),
              title: const Text(
                'Notificaciones',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Configurar alertas y notificaciones',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _mostrarSnackbar('Funcionalidad en desarrollo');
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
enum ModoAlarma {
  desactivado,
  casa,
  fuera,
}

enum TipoSensor {
  movimiento,
  puerta,
  ventana,
}

enum EstadoSensor {
  activo,
  inactivo,
}

enum TipoEvento {
  activacion,
  desactivacion,
  sensor,
}

class ZonaAlarma {
  final String nombre;
  final HeroIcons? icono;
  final IconData? materialIcon;
  final int sensores;
  bool activa;
  final String ultimaActivacion;
  final int bateria;

  ZonaAlarma({
    required this.nombre,
    this.icono,
    this.materialIcon,
    required this.sensores,
    required this.activa,
    required this.ultimaActivacion,
    required this.bateria,
  });
}

class SensorAlarma {
  final String nombre;
  final TipoSensor tipo;
  EstadoSensor estado;
  final int bateria;
  final String ultimaActivacion;

  SensorAlarma({
    required this.nombre,
    required this.tipo,
    required this.estado,
    required this.bateria,
    required this.ultimaActivacion,
  });
}

class EventoAlarma {
  final TipoEvento tipo;
  final String mensaje;
  final String hora;
  final String fecha;
  final IconData icono;
  final Color color;

  EventoAlarma({
    required this.tipo,
    required this.mensaje,
    required this.hora,
    required this.fecha,
    required this.icono,
    required this.color,
  });
}

