import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import '../theme/app_colors.dart';

class AlertasPage extends StatefulWidget {
  const AlertasPage({super.key});

  @override
  State<AlertasPage> createState() => _AlertasPageState();
}

class _AlertasPageState extends State<AlertasPage> {
  int _selectedNavIndex = 2; // Alertas está seleccionado

  // Datos de sensores (simulados - en producción vendrían de un provider o servicio)
  final List<AlertaSensor> _alertasSensores = [
    AlertaSensor(
      nombre: 'Entrada',
      categoria: 'Movimiento',
      valor: 'Movimiento detectado',
      icono: Icons.directions_run,
      color: const Color(0xFFFFD700),
    ),
    AlertaSensor(
      nombre: 'Baño Principal',
      categoria: 'Humedad',
      valor: '78%',
      icono: Icons.water_drop,
      color: const Color(0xFF58A6FF),
    ),
    AlertaSensor(
      nombre: 'Garage',
      categoria: 'Puertas',
      valor: 'Abierta',
      icono: Icons.door_front_door,
      color: const Color(0xFF7EE787),
    ),
    AlertaSensor(
      nombre: 'Dormitorio 1',
      categoria: 'Ventanas',
      valor: 'Abierta',
      icono: Icons.window,
      color: const Color(0xFFA78BFA),
    ),
  ];

  // Datos de cerraduras (simulados - en producción vendrían de un provider o servicio)
  final List<AlertaCerradura> _alertasCerraduras = [
    AlertaCerradura(
      nombre: 'Garage',
      ubicacion: 'Exterior',
      tipo: TipoAlertaCerradura.abierta,
      icono: Icons.garage,
      color: const Color(0xFFFFD700),
    ),
    AlertaCerradura(
      nombre: 'Garage',
      ubicacion: 'Exterior',
      tipo: TipoAlertaCerradura.bateriaBaja,
      icono: Icons.garage,
      color: const Color(0xFFFFD700),
      bateria: 45,
    ),
    AlertaCerradura(
      nombre: 'Puerta Lateral',
      ubicacion: 'Cocina',
      tipo: TipoAlertaCerradura.bateriaBaja,
      icono: Icons.door_sliding,
      color: const Color(0xFFFF6B6B),
      bateria: 12,
    ),
    AlertaCerradura(
      nombre: 'Puerta Lateral',
      ubicacion: 'Cocina',
      tipo: TipoAlertaCerradura.desconectada,
      icono: Icons.door_sliding,
      color: const Color(0xFFFF6B6B),
    ),
  ];

  int get _totalAlertas => _alertasSensores.length + _alertasCerraduras.length;

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
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.cardBorder,
                          ),
                        ),
                        child: HeroIcon(
                          HeroIcons.arrowLeft,
                          style: HeroIconStyle.outline,
                          color: AppColors.textPrimary,
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
                            'Alertas',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '$_totalAlertas alertas activas',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_totalAlertas > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF85149).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFF85149).withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              size: 16,
                              color: Color(0xFFF85149),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$_totalAlertas',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF85149),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Lista de alertas
              Expanded(
                child: _totalAlertas == 0
                    ? _buildSinAlertas()
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          // Sección de alertas de sensores
                          if (_alertasSensores.isNotEmpty) ...[
                            _buildSeccionTitulo(
                              'Sensores',
                              _alertasSensores.length,
                              Icons.sensors,
                              const Color(0xFF58A6FF),
                            ),
                            const SizedBox(height: 12),
                            ..._alertasSensores.map((alerta) => _buildAlertaSensorCard(alerta)),
                            const SizedBox(height: 8),
                          ],

                          // Sección de alertas de cerraduras
                          if (_alertasCerraduras.isNotEmpty) ...[
                            _buildSeccionTitulo(
                              'Cerraduras',
                              _alertasCerraduras.length,
                              Icons.lock,
                              const Color(0xFFA78BFA),
                            ),
                            const SizedBox(height: 12),
                            ..._alertasCerraduras.map((alerta) => _buildAlertaCerraduraCard(alerta)),
                            const SizedBox(height: 20),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSinAlertas() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.cardBorder,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 64,
              color: AppColors.successLight,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No hay alertas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Todos los sistemas están funcionando correctamente',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionTitulo(String titulo, int cantidad, IconData icono, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icono,
            size: 18,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          titulo,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$cantidad',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertaSensorCard(AlertaSensor alerta) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF85149).withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF85149).withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icono de categoría
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  alerta.color,
                  alerta.color.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: alerta.color.withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              alerta.icono,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Información
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alerta.nombre,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.category,
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      alerta.categoria,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.info_outline,
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    // Si el valor contiene "detectado", dividirlo en dos líneas
                    alerta.valor.toLowerCase().contains('detectado')
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                alerta.valor.split(' ').first,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: alerta.color,
                                ),
                              ),
                              Text(
                                alerta.valor.split(' ').skip(1).join(' '),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: alerta.color,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            alerta.valor,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: alerta.color,
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
          // Cartel ALERTA e Icono de alerta (apilados verticalmente)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cartel ALERTA arriba
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF85149).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'ALERTA',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF85149),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Icono de alerta abajo
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF85149).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFF85149),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertaCerraduraCard(AlertaCerradura alerta) {
    String tipoTexto;
    IconData tipoIcono;
    Color tipoColor;

    switch (alerta.tipo) {
      case TipoAlertaCerradura.abierta:
        tipoTexto = 'Abierta';
        tipoIcono = Icons.lock_open;
        tipoColor = const Color(0xFFFF6B6B);
        break;
      case TipoAlertaCerradura.bateriaBaja:
        tipoTexto = 'Batería baja';
        tipoIcono = Icons.battery_alert;
        tipoColor = const Color(0xFFFFD700);
        break;
      case TipoAlertaCerradura.desconectada:
        tipoTexto = 'Desconectada';
        tipoIcono = Icons.wifi_off;
        tipoColor = const Color(0xFFF85149);
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: tipoColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: tipoColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icono de cerradura
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  alerta.color,
                  alerta.color.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: alerta.color.withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              alerta.icono,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Información
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alerta.nombre,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      alerta.ubicacion,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (alerta.tipo == TipoAlertaCerradura.bateriaBaja && alerta.bateria != null) ...[
                      const SizedBox(width: 12),
                      Icon(
                        tipoIcono,
                        size: 12,
                        color: tipoColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${alerta.bateria}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: tipoColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Cartel de tipo de alerta e Icono (apilados verticalmente)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cartel de tipo arriba
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tipoColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tipoTexto.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: tipoColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Icono de tipo de alerta abajo
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: tipoColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  tipoIcono,
                  color: tipoColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          top: BorderSide(
            color: AppColors.cardBorder.withValues(alpha: 0.5),
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
          // Ya estamos en alertas
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

// Modelos de datos
class AlertaSensor {
  final String nombre;
  final String categoria;
  final String valor;
  final IconData icono;
  final Color color;

  AlertaSensor({
    required this.nombre,
    required this.categoria,
    required this.valor,
    required this.icono,
    required this.color,
  });
}

enum TipoAlertaCerradura {
  abierta,
  bateriaBaja,
  desconectada,
}

class AlertaCerradura {
  final String nombre;
  final String ubicacion;
  final TipoAlertaCerradura tipo;
  final IconData icono;
  final Color color;
  final int? bateria;

  AlertaCerradura({
    required this.nombre,
    required this.ubicacion,
    required this.tipo,
    required this.icono,
    required this.color,
    this.bateria,
  });
}

