import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'dart:math' as math;
import '../theme/app_colors.dart';

class CortinasPage extends StatefulWidget {
  const CortinasPage({super.key});

  @override
  State<CortinasPage> createState() => _CortinasPageState();
}

class _CortinasPageState extends State<CortinasPage> {
  int _selectedNavIndex = 0;

  // Lista de cortinas
  final List<Cortina> _cortinas = [
    Cortina(
      nombre: 'Sala Principal',
      icono: HeroIcons.home,
      apertura: 75,
      tipo: TipoCortina.vertical,
      modo: ModoCortina.manual,
      conectada: true,
      bateria: 85,
      ultimaAccion: 'Hace 2 horas',
    ),
    Cortina(
      nombre: 'Dormitorio 1',
      icono: HeroIcons.moon,
      apertura: 0,
      tipo: TipoCortina.vertical,
      modo: ModoCortina.automatico,
      conectada: true,
      bateria: 92,
      ultimaAccion: 'Hace 5 min',
    ),
    Cortina(
      nombre: 'Cocina',
      icono: HeroIcons.fire,
      apertura: 50,
      tipo: TipoCortina.vertical,
      modo: ModoCortina.manual,
      conectada: true,
      bateria: 78,
      ultimaAccion: 'Hace 1 hora',
    ),
    Cortina(
      nombre: 'Dormitorio 2',
      icono: HeroIcons.moon,
      apertura: 100,
      tipo: TipoCortina.vertical,
      modo: ModoCortina.automatico,
      conectada: true,
      bateria: 88,
      ultimaAccion: 'Hace 10 min',
    ),
    Cortina(
      nombre: 'Oficina',
      materialIcon: Symbols.computer,
      apertura: 25,
      tipo: TipoCortina.vertical,
      modo: ModoCortina.manual,
      conectada: true,
      bateria: 65,
      ultimaAccion: 'Hace 30 min',
    ),
    Cortina(
      nombre: 'Terraza',
      materialIcon: Symbols.eco,
      apertura: 100,
      tipo: TipoCortina.vertical,
      modo: ModoCortina.automatico,
      conectada: true,
      bateria: 95,
      ultimaAccion: 'Hace 5 min',
    ),
  ];

  // Estadísticas
  int get _cortinasAbiertas {
    return _cortinas.where((c) => c.apertura > 0 && c.conectada).length;
  }

  int get _cortinasCerradas {
    return _cortinas.where((c) => c.apertura == 0 && c.conectada).length;
  }

  int get _cortinasModoAutomatico {
    return _cortinas.where((c) => c.modo == ModoCortina.automatico && c.conectada).length;
  }

  double get _aperturaPromedio {
    if (_cortinas.isEmpty) return 0;
    final total = _cortinas.where((c) => c.conectada).fold(0, (sum, c) => sum + c.apertura);
    final count = _cortinas.where((c) => c.conectada).length;
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

              // Lista de cortinas
              Expanded(
                child: _buildListaCortinas(),
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
                  'Control de Cortinas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${_cortinas.where((c) => c.conectada).length} cortinas conectadas',
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
              icon: Symbols.vertical_align_top,
              label: 'Abiertas',
              value: '$_cortinasAbiertas',
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
              icon: Symbols.vertical_align_bottom,
              label: 'Cerradas',
              value: '$_cortinasCerradas',
              color: const Color(0xFF8B949E),
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
              value: '$_cortinasModoAutomatico',
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
              icon: Symbols.tune,
              label: 'Promedio',
              value: '${_aperturaPromedio.toInt()}%',
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

  Widget _buildListaCortinas() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _cortinas.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildCortinaCard(_cortinas[index], index),
        );
      },
    );
  }

  Widget _buildCortinaCard(Cortina cortina, int index) {
    final colorEstado = _getColorEstado(cortina);
    final iconoEstado = _getIconoEstado(cortina);
    
    // Calcular el color de fondo basado en la apertura (efecto de luz)
    final colorFondo = _getColorFondoPorApertura(cortina.apertura);
    final colorBorde = _getColorBordePorApertura(cortina.apertura, cortina.conectada, colorEstado);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Gradiente radial que simula la luz entrando por la ventana
        gradient: cortina.apertura > 0
            ? RadialGradient(
                center: Alignment.topCenter,
                radius: 1.5,
                colors: [
                  Color.lerp(
                    colorFondo,
                    Colors.white.withValues(alpha: 0.9), // Blanco brillante en el centro
                    (cortina.apertura / 100) * 0.6,
                  )!,
                  colorFondo,
                ],
                stops: const [0.0, 1.0],
              )
            : null,
        color: cortina.apertura == 0 ? colorFondo : null,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorBorde,
          width: cortina.conectada ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: cortina.apertura > 0
                ? Colors.white.withValues(alpha: (cortina.apertura / 100) * 0.3)
                : Colors.transparent,
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de la cortina - Card anidada con fondo negro fijo
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardBackground, // Fondo negro fijo
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.cardBorder,
                width: 1,
              ),
            ),
            child: Row(
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
                  child: cortina.materialIcon != null
                      ? Icon(
                          cortina.materialIcon,
                          color: Colors.white,
                          size: 20,
                        )
                      : HeroIcon(
                          cortina.icono!,
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
                              cortina.nombre,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Texto blanco fijo
                              ),
                            ),
                          ),
                          // Indicador de conexión
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: cortina.conectada
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
                            _getTextoEstado(cortina),
                            style: TextStyle(
                              fontSize: 12,
                              color: colorEstado,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (cortina.modo == ModoCortina.automatico) ...[
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
                if (cortina.conectada)
                  Column(
                    children: [
                      Icon(
                        _getIconoBateria(cortina.bateria),
                        size: 16,
                        color: _getColorBateria(cortina.bateria),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${cortina.bateria}%',
                        style: TextStyle(
                          fontSize: 10,
                          color: _getColorBateria(cortina.bateria),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Control de apertura
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Apertura',
                    style: TextStyle(
                      fontSize: 12,
                      color: _getColorTextoSecundarioPorApertura(cortina.apertura),
                    ),
                  ),
                  Text(
                    '${cortina.apertura}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorEstado,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Slider de apertura
              Slider(
                value: cortina.apertura.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                activeColor: colorEstado,
                inactiveColor: AppColors.cardBorder,
                onChanged: cortina.conectada
                    ? (value) {
                        setState(() {
                          _cortinas[index].apertura = value.toInt();
                          _cortinas[index].ultimaAccion = 'Ahora';
                        });
                      }
                    : null,
              ),
              // Botones rápidos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBotonRapido(
                    icon: Symbols.vertical_align_bottom,
                    label: 'Cerrar',
                    onTap: cortina.conectada
                        ? () {
                            setState(() {
                              _cortinas[index].apertura = 0;
                              _cortinas[index].ultimaAccion = 'Ahora';
                            });
                          }
                        : null,
                  ),
                  _buildBotonRapido(
                    icon: Symbols.stop,
                    label: '50%',
                    onTap: cortina.conectada
                        ? () {
                            setState(() {
                              _cortinas[index].apertura = 50;
                              _cortinas[index].ultimaAccion = 'Ahora';
                            });
                          }
                        : null,
                  ),
                  _buildBotonRapido(
                    icon: Symbols.vertical_align_top,
                    label: 'Abrir',
                    onTap: cortina.conectada
                        ? () {
                            setState(() {
                              _cortinas[index].apertura = 100;
                              _cortinas[index].ultimaAccion = 'Ahora';
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Información adicional
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: Symbols.schedule,
                  label: 'Última acción',
                  value: cortina.ultimaAccion,
                  color: _getColorTextoSecundarioPorApertura(cortina.apertura),
                  apertura: cortina.apertura,
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: AppColors.cardBorder,
              ),
              Expanded(
                child: _buildInfoItem(
                  icon: Symbols.tune,
                  label: 'Modo',
                  value: cortina.modo == ModoCortina.automatico ? 'Automático' : 'Manual',
                  color: cortina.modo == ModoCortina.automatico
                      ? const Color(0xFF58A6FF)
                      : _getColorTextoSecundarioPorApertura(cortina.apertura),
                  apertura: cortina.apertura,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Botón de modo
          GestureDetector(
            onTap: cortina.conectada
                ? () {
                    _cambiarModo(index);
                  }
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: cortina.modo == ModoCortina.automatico
                    ? const Color(0xFF58A6FF).withValues(alpha: 0.15)
                    : AppColors.cardBorder.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: cortina.modo == ModoCortina.automatico
                      ? const Color(0xFF58A6FF).withValues(alpha: 0.5)
                      : AppColors.cardBorder,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    cortina.modo == ModoCortina.automatico
                        ? Symbols.schedule
                        : Symbols.touch_app,
                    size: 16,
                    color: cortina.modo == ModoCortina.automatico
                        ? const Color(0xFF58A6FF)
                        : _getColorTextoSecundarioPorApertura(cortina.apertura),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cortina.modo == ModoCortina.automatico
                        ? 'Modo Automático'
                        : 'Cambiar a Automático',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cortina.modo == ModoCortina.automatico
                          ? const Color(0xFF58A6FF)
                          : _getColorTextoSecundarioPorApertura(cortina.apertura),
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
    int? apertura,
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
            color: apertura != null
                ? _getColorTextoSecundarioPorApertura(apertura)
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Color _getColorEstado(Cortina cortina) {
    if (!cortina.conectada) {
      return AppColors.textSecondary;
    }
    if (cortina.apertura == 0) {
      return const Color(0xFF8B949E); // Cerrada
    } else if (cortina.apertura == 100) {
      return const Color(0xFF7EE787); // Abierta
    } else {
      return const Color(0xFFFFB347); // Parcial
    }
  }

  IconData _getIconoEstado(Cortina cortina) {
    if (!cortina.conectada) {
      return Symbols.power_off;
    }
    if (cortina.apertura == 0) {
      return Symbols.vertical_align_bottom;
    } else if (cortina.apertura == 100) {
      return Symbols.vertical_align_top;
    } else {
      return Symbols.tune;
    }
  }

  String _getTextoEstado(Cortina cortina) {
    if (!cortina.conectada) {
      return 'Desconectada';
    }
    if (cortina.apertura == 0) {
      return 'Cerrada';
    } else if (cortina.apertura == 100) {
      return 'Abierta';
    } else {
      return '${cortina.apertura}% abierta';
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

  // Calcula el color de fondo basado en la apertura (efecto de luz)
  Color _getColorFondoPorApertura(int apertura) {
    // Color base oscuro (0% apertura)
    const colorOscuro = AppColors.cardBackground; // Color(0xFF161B22)
    // Color blanco brillante (100% apertura) - simulando luz natural entrando
    const colorBlanco = Color(0xFFFFFFFF); // Blanco puro
    
    // Interpolar entre oscuro y blanco basado en el porcentaje de apertura
    final factor = apertura / 100.0;
    return Color.lerp(colorOscuro, colorBlanco, factor) ?? colorOscuro;
  }

  // Calcula el color del borde basado en la apertura
  Color _getColorBordePorApertura(int apertura, bool conectada, Color colorEstado) {
    if (!conectada) {
      return AppColors.cardBorder;
    }
    
    // El borde se vuelve más brillante cuando hay más luz
    final factor = apertura / 100.0;
    final colorBordeBase = colorEstado.withValues(alpha: 0.3);
    final colorBordeBrillante = colorEstado.withValues(alpha: 0.6);
    
    return Color.lerp(colorBordeBase, colorBordeBrillante, factor) ?? colorBordeBase;
  }

  // Calcula el color del texto basado en la apertura (negro cuando hay luz)
  Color _getColorTextoPorApertura(int apertura) {
    // Texto blanco cuando está oscuro (0%)
    const colorTextoOscuro = Colors.white;
    // Texto negro cuando hay luz (100%) para legibilidad en fondo blanco
    const colorTextoClaro = Color(0xFF000000); // Negro puro
    
    // Interpolar entre blanco y negro basado en el porcentaje de apertura
    final factor = apertura / 100.0;
    return Color.lerp(colorTextoOscuro, colorTextoClaro, factor) ?? colorTextoOscuro;
  }

  // Calcula el color del texto secundario basado en la apertura
  Color _getColorTextoSecundarioPorApertura(int apertura) {
    // Texto gris claro cuando está oscuro (0%)
    const colorSecundarioOscuro = AppColors.textSecondary; // Color(0xFF8B949E)
    // Texto gris oscuro cuando hay luz (100%) para legibilidad en fondo blanco
    const colorSecundarioClaro = Color(0xFF4A5568); // Gris oscuro
    
    // Interpolar entre gris claro y gris oscuro basado en el porcentaje de apertura
    final factor = apertura / 100.0;
    return Color.lerp(colorSecundarioOscuro, colorSecundarioClaro, factor) ?? colorSecundarioOscuro;
  }

  void _cambiarModo(int index) {
    setState(() {
      _cortinas[index].modo = _cortinas[index].modo == ModoCortina.manual
          ? ModoCortina.automatico
          : ModoCortina.manual;
    });
    final modoTexto = _cortinas[index].modo == ModoCortina.automatico
        ? 'Automático'
        : 'Manual';
    _mostrarSnackbar('Modo cambiado a $modoTexto en ${_cortinas[index].nombre}');
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
                  Symbols.vertical_align_top,
                  color: Color(0xFF7EE787),
                  size: 20,
                ),
              ),
              title: const Text(
                'Abrir Todas',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Abrir todas las cortinas',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              onTap: () {
                Navigator.of(sheetContext).pop();
                setState(() {
                  for (var cortina in _cortinas) {
                    if (cortina.conectada) {
                      cortina.apertura = 100;
                      cortina.ultimaAccion = 'Ahora';
                    }
                  }
                });
                _mostrarSnackbar('Todas las cortinas abiertas');
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
                  Symbols.vertical_align_bottom,
                  color: Color(0xFF8B949E),
                  size: 20,
                ),
              ),
              title: const Text(
                'Cerrar Todas',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Cerrar todas las cortinas',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              onTap: () {
                Navigator.of(sheetContext).pop();
                setState(() {
                  for (var cortina in _cortinas) {
                    if (cortina.conectada) {
                      cortina.apertura = 0;
                      cortina.ultimaAccion = 'Ahora';
                    }
                  }
                });
                _mostrarSnackbar('Todas las cortinas cerradas');
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
                  Symbols.tune,
                  color: Color(0xFFFFB347),
                  size: 20,
                ),
              ),
              title: const Text(
                'Abrir al 50%',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Abrir todas al 50%',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              onTap: () {
                Navigator.of(sheetContext).pop();
                setState(() {
                  for (var cortina in _cortinas) {
                    if (cortina.conectada) {
                      cortina.apertura = 50;
                      cortina.ultimaAccion = 'Ahora';
                    }
                  }
                });
                _mostrarSnackbar('Todas las cortinas al 50%');
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
enum TipoCortina {
  vertical,
  horizontal,
  persiana,
}

enum ModoCortina {
  manual,
  automatico,
}

class Cortina {
  final String nombre;
  final HeroIcons? icono;
  final IconData? materialIcon;
  int apertura; // 0-100
  TipoCortina tipo;
  ModoCortina modo;
  bool conectada;
  int bateria; // 0-100
  String ultimaAccion;

  Cortina({
    required this.nombre,
    this.icono,
    this.materialIcon,
    required this.apertura,
    required this.tipo,
    required this.modo,
    required this.conectada,
    required this.bateria,
    required this.ultimaAccion,
  });
}

