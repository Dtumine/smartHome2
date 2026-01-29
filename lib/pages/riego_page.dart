import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme/app_colors.dart';
import '../services/riego_service.dart';

class RiegoPage extends StatefulWidget {
  const RiegoPage({super.key});

  @override
  State<RiegoPage> createState() => _RiegoPageState();
}

class _RiegoPageState extends State<RiegoPage> {
  int _selectedNavIndex = 0;

  // Zonas de riego
  List<ZonaRiego> _zonas = [
    ZonaRiego(
      nombre: 'Jardín Frontal',
      icono: HeroIcons.home,
      humedad: 45,
      estado: EstadoRiego.regando,
      duracionProgramada: 30,
      proximoRiego: '08:00',
      consumoDiario: 12.5,
      activa: true,
      tipoRiego: TipoRiego.medio,
    ),
    ZonaRiego(
      nombre: 'Jardín Trasero',
      icono: HeroIcons.home,
      humedad: 62,
      estado: EstadoRiego.programado,
      duracionProgramada: 25,
      proximoRiego: '08:30',
      consumoDiario: 10.2,
      activa: true,
      tipoRiego: TipoRiego.suave,
    ),
    ZonaRiego(
      nombre: 'Huerto',
      icono: HeroIcons.rectangleStack,
      humedad: 38,
      estado: EstadoRiego.necesitaRiego,
      duracionProgramada: 20,
      proximoRiego: '09:00',
      consumoDiario: 8.5,
      activa: true,
      tipoRiego: TipoRiego.fuerte,
    ),
    ZonaRiego(
      nombre: 'Macetas Terraza',
      materialIcon: Symbols.eco,
      humedad: 55,
      estado: EstadoRiego.programado,
      duracionProgramada: 15,
      proximoRiego: '07:30',
      consumoDiario: 5.8,
      activa: true,
      tipoRiego: TipoRiego.suave,
    ),
    ZonaRiego(
      nombre: 'Césped Lateral',
      materialIcon: Symbols.grass,
      humedad: 50,
      estado: EstadoRiego.inactivo,
      duracionProgramada: 35,
      proximoRiego: '08:15',
      consumoDiario: 15.3,
      activa: false,
      tipoRiego: TipoRiego.fuerte,
    ),
  ];

  ZonaRiego get _zonaSeleccionada => _zonas[0];

  @override
  void initState() {
    super.initState();
    _cargarProgramacionesGuardadas();
  }

  Future<void> _cargarProgramacionesGuardadas() async {
    final riegoService = RiegoService();
    
    for (int i = 0; i < _zonas.length; i++) {
      final programacion = await riegoService.obtenerProgramacion(_zonas[i].nombre);
      if (programacion != null && mounted) {
        setState(() {
          _zonas[i].proximoRiego = programacion.hora;
          _zonas[i].duracionProgramada = programacion.duracion;
          _zonas[i].tipoRiego = programacion.tipoRiego;
          // Si hay programación guardada y la zona está activa, cambiar estado a programado
          if (_zonas[i].activa && _zonas[i].estado == EstadoRiego.inactivo) {
            _zonas[i].estado = EstadoRiego.programado;
          }
        });
      }
    }
  }

  // Estadísticas generales
  double get _consumoTotalDiario {
    return _zonas.fold(0.0, (sum, zona) => sum + zona.consumoDiario);
  }

  int get _zonasActivas {
    return _zonas.where((zona) => zona.activa).length;
  }

  int get _zonasNecesitanRiego {
    return _zonas.where((zona) => zona.estado == EstadoRiego.necesitaRiego).length;
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

              // Lista de zonas
              Expanded(
                child: _buildListaZonas(),
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
                  'Sistema de Riego',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${_zonasActivas} zonas activas',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Botón de configuración
          GestureDetector(
            onTap: () {
              _mostrarDialogoConfiguracion();
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
              icon: Symbols.water_drop,
              label: 'Consumo Diario',
              value: '${_consumoTotalDiario.toStringAsFixed(1)} L',
              color: const Color(0xFF00CED1),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.cardBorder,
          ),
          Expanded(
            child: _buildStatItem(
              icon: Symbols.eco,
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
              icon: Symbols.warning,
              label: 'Necesitan Riego',
              value: '$_zonasNecesitanRiego',
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
        Icon(icon, size: 20, color: color),
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

  Widget _buildListaZonas() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _zonas.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildZonaCard(_zonas[index], index),
        );
      },
    );
  }

  Widget _buildZonaCard(ZonaRiego zona, int index) {
    final colorEstado = _getColorEstado(zona.estado);
    final iconoEstado = _getIconoEstado(zona.estado);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: zona.activa
              ? colorEstado.withValues(alpha: 0.3)
              : AppColors.cardBorder,
          width: zona.activa ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de la zona
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
              // Nombre y estado
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
                        Icon(iconoEstado, size: 14, color: colorEstado),
                        const SizedBox(width: 4),
                        Text(
                          zona.activa && zona.estado == EstadoRiego.programado
                              ? 'Activo'
                              : _getTextoEstado(zona.estado),
                          style: TextStyle(
                            fontSize: 12,
                            color: colorEstado,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Switch de activación
              Switch(
                value: zona.activa,
                onChanged: (value) {
                  setState(() {
                    _zonas[index].activa = value;
                    if (!value) {
                      // Al desactivar, cambiar a inactivo
                      _zonas[index].estado = EstadoRiego.inactivo;
                    } else {
                      // Al activar, cambiar a programado (activo)
                      _zonas[index].estado = EstadoRiego.programado;
                    }
                  });
                },
                activeColor: colorEstado,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Información de humedad
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Symbols.water_drop,
                  label: 'Humedad',
                  value: '${zona.humedad}%',
                  color: const Color(0xFF00CED1),
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
                  label: 'Duración',
                  value: '${zona.duracionProgramada} min',
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: AppColors.cardBorder,
              ),
              Expanded(
                child: _buildInfoItem(
                  icon: Symbols.water_drop,
                  label: 'Tipo',
                  value: _getTextoTipoRiego(zona.tipoRiego),
                  color: _getColorTipoRiego(zona.tipoRiego),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Barra de humedad
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nivel de Humedad',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${zona.humedad}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getColorHumedad(zona.humedad),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: zona.humedad / 100,
                  backgroundColor: AppColors.cardBorder,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getColorHumedad(zona.humedad),
                  ),
                  minHeight: 8,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Selector de tipo de riego
          Row(
            children: [
              Text(
                'Tipo: ',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildBotonTipoRiegoCard(
                        index,
                        TipoRiego.suave,
                        'Suave',
                        const Color(0xFF7EE787),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildBotonTipoRiegoCard(
                        index,
                        TipoRiego.medio,
                        'Medio',
                        const Color(0xFF58A6FF),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildBotonTipoRiegoCard(
                        index,
                        TipoRiego.fuerte,
                        'Fuerte',
                        const Color(0xFFFF6B6B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Botones de acción
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Symbols.play_arrow,
                  label: 'Regar Ahora',
                  color: const Color(0xFF00CED1),
                  onTap: () {
                    _iniciarRiego(index);
                  },
                  enabled: zona.activa,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  icon: Symbols.schedule,
                  label: 'Programar',
                  color: const Color(0xFF58A6FF),
                  onTap: () {
                    _programarRiego(index);
                  },
                  enabled: zona.activa,
                ),
              ),
            ],
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
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: enabled
              ? color.withValues(alpha: 0.15)
              : AppColors.cardBorder.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled
                ? color.withValues(alpha: 0.5)
                : AppColors.cardBorder,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: enabled ? color : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: enabled ? color : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorEstado(EstadoRiego estado) {
    switch (estado) {
      case EstadoRiego.regando:
        return const Color(0xFF00CED1);
      case EstadoRiego.programado:
        return const Color(0xFF58A6FF);
      case EstadoRiego.necesitaRiego:
        return const Color(0xFFFFB347);
      case EstadoRiego.inactivo:
        return AppColors.textSecondary;
    }
  }

  IconData _getIconoEstado(EstadoRiego estado) {
    switch (estado) {
      case EstadoRiego.regando:
        return Symbols.water_drop;
      case EstadoRiego.programado:
        return Symbols.schedule;
      case EstadoRiego.necesitaRiego:
        return Symbols.warning;
      case EstadoRiego.inactivo:
        return Symbols.pause;
    }
  }

  String _getTextoEstado(EstadoRiego estado) {
    switch (estado) {
      case EstadoRiego.regando:
        return 'Regando';
      case EstadoRiego.programado:
        return 'Programado';
      case EstadoRiego.necesitaRiego:
        return 'Necesita Riego';
      case EstadoRiego.inactivo:
        return 'Inactivo';
    }
  }

  Color _getColorHumedad(int humedad) {
    if (humedad < 30) {
      return const Color(0xFFFF6B6B); // Rojo - muy seco
    } else if (humedad < 50) {
      return const Color(0xFFFFB347); // Naranja - seco
    } else if (humedad < 70) {
      return const Color(0xFF7EE787); // Verde - óptimo
    } else {
      return const Color(0xFF00CED1); // Turquesa - húmedo
    }
  }

  String _getTextoTipoRiego(TipoRiego tipo) {
    switch (tipo) {
      case TipoRiego.suave:
        return 'Suave';
      case TipoRiego.medio:
        return 'Medio';
      case TipoRiego.fuerte:
        return 'Fuerte';
    }
  }

  Color _getColorTipoRiego(TipoRiego tipo) {
    switch (tipo) {
      case TipoRiego.suave:
        return const Color(0xFF7EE787); // Verde - suave
      case TipoRiego.medio:
        return const Color(0xFF58A6FF); // Azul - medio
      case TipoRiego.fuerte:
        return const Color(0xFFFF6B6B); // Rojo - fuerte
    }
  }

  Widget _buildBotonTipoRiegoCard(int index, TipoRiego tipo, String label, Color color) {
    final zona = _zonas[index];
    final isSelected = zona.tipoRiego == tipo;
    
    return GestureDetector(
      onTap: zona.activa
          ? () {
              setState(() {
                _zonas[index].tipoRiego = tipo;
              });
            }
          : null,
      child: Opacity(
        opacity: zona.activa ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected ? color : AppColors.cardBorder,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Symbols.water_drop,
                color: isSelected ? color : AppColors.textSecondary,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? color : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _iniciarRiego(int index) {
    setState(() {
      // Activar la zona si está inactiva y cambiar a activo (programado)
      if (!_zonas[index].activa) {
        _zonas[index].activa = true;
        _zonas[index].estado = EstadoRiego.programado;
      }
      // Si estaba inactivo, activar primero
      if (_zonas[index].estado == EstadoRiego.inactivo) {
        _zonas[index].activa = true;
        _zonas[index].estado = EstadoRiego.programado;
      }
      // Cambiar a estado regando
      _zonas[index].estado = EstadoRiego.regando;
    });
    
    final tipoTexto = _getTextoTipoRiego(_zonas[index].tipoRiego);
    _mostrarSnackbar('Riego ${tipoTexto.toLowerCase()} iniciado en ${_zonas[index].nombre}');
    
    // Simular finalización del riego después de la duración programada
    Future.delayed(Duration(minutes: _zonas[index].duracionProgramada), () {
      if (mounted) {
        setState(() {
          // Después del riego, volver a activo (programado)
          _zonas[index].estado = EstadoRiego.programado;
          // Ajustar humedad según el tipo de riego
          int incrementoHumedad = 20; // Por defecto
          switch (_zonas[index].tipoRiego) {
            case TipoRiego.suave:
              incrementoHumedad = 15;
              break;
            case TipoRiego.medio:
              incrementoHumedad = 20;
              break;
            case TipoRiego.fuerte:
              incrementoHumedad = 30;
              break;
          }
          _zonas[index].humedad = (_zonas[index].humedad + incrementoHumedad).clamp(0, 100);
        });
        _mostrarSnackbar('Riego completado en ${_zonas[index].nombre}');
      }
    });
  }

  void _programarRiego(int index) async {
    await context.push(
      '/programar-riego?zona=${Uri.encodeComponent(_zonas[index].nombre)}&index=$index',
    );
    // Recargar programaciones después de volver de la página de programar
    _cargarProgramacionesGuardadas();
  }

  void _mostrarDialogoConfiguracion() {
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
              'Configuración del Sistema',
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
                'Horarios de Riego',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Configurar horarios automáticos',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _mostrarSnackbar('Funcionalidad en desarrollo');
              },
            ),
            ListTile(
              leading: const Icon(Icons.water_drop, color: Color(0xFF00CED1)),
              title: const Text(
                'Límites de Humedad',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Ajustar umbrales de humedad',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _mostrarSnackbar('Funcionalidad en desarrollo');
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics, color: Color(0xFF7EE787)),
              title: const Text(
                'Estadísticas',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Ver historial de riego',
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
enum EstadoRiego {
  regando,
  programado,
  necesitaRiego,
  inactivo,
}

class ZonaRiego {
  final String nombre;
  final HeroIcons? icono;
  final IconData? materialIcon;
  int humedad;
  EstadoRiego estado;
  int duracionProgramada; // en minutos
  String proximoRiego;
  double consumoDiario; // en litros
  bool activa;
  TipoRiego tipoRiego;

  ZonaRiego({
    required this.nombre,
    this.icono,
    this.materialIcon,
    required this.humedad,
    required this.estado,
    required this.duracionProgramada,
    required this.proximoRiego,
    required this.consumoDiario,
    required this.activa,
    this.tipoRiego = TipoRiego.medio,
  });
}

