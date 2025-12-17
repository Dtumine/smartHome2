import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:fl_chart/fl_chart.dart';

class CentroMandoPage extends StatefulWidget {
  const CentroMandoPage({super.key});

  @override
  State<CentroMandoPage> createState() => _CentroMandoPageState();
}

class _CentroMandoPageState extends State<CentroMandoPage> {
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  static const double _initialSize = 0.38;
  bool _isDragging = false;

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _resetSheetPosition() {
    if (_sheetController.isAttached && _sheetController.size != _initialSize) {
      _sheetController.animateTo(
        _initialSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D1117),
              Color(0xFF161B22),
              Color(0xFF0D1117),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Contenido principal (fijo, sin scroll)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AppBar personalizado
                    Row(
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
                        const Expanded(
                          child: Text(
                            'Centro de Mando',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF238636).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF238636).withValues(alpha: 0.5),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 8,
                                color: Color(0xFF7EE787),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Activo',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF7EE787),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // 3 KPI Cards apiladas verticalmente con altura fija
                    // Card 1: Temperatura
                    SizedBox(
                      height: 125,
                      child: _buildKpiCardHorizontal(
                        icon: HeroIcons.fire,
                        iconColor: const Color(0xFFFF6B6B),
                        title: 'Temperatura General',
                        value: '22°C',
                        subtitle: 'Promedio del hogar',
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Card 2: Dispositivos Activos
                    SizedBox(
                      height: 125,
                      child: _buildKpiCardHorizontal(
                        icon: HeroIcons.cpuChip,
                        iconColor: const Color(0xFF7EE787),
                        title: 'Dispositivos Activos',
                        value: '24/27',
                        subtitle: 'Conectados ahora',
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Card 3: Consumo Energético con gráfico
                    SizedBox(
                      height: 125,
                      child: _buildEnergyCard(),
                    ),
                  ],
                ),
              ),
            ),
            
            // DraggableScrollableSheet para Alertas
            Listener(
              onPointerDown: (_) {
                _isDragging = true;
              },
              onPointerUp: (_) {
                _isDragging = false;
                // Esperar un momento para que termine la animación de snap
                Future.delayed(const Duration(milliseconds: 100), () {
                  _resetSheetPosition();
                });
              },
              child: DraggableScrollableSheet(
                controller: _sheetController,
                initialChildSize: _initialSize,
                minChildSize: _initialSize,
                maxChildSize: 0.85,
                snap: true,
                snapSizes: const [_initialSize, 0.85],
                builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF161B22),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Handle para arrastrar
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF30363D),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      
                      // Header de alertas
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF85149).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const HeroIcon(
                                HeroIcons.exclamationTriangle,
                                style: HeroIconStyle.solid,
                                color: Color(0xFFF85149),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Alertas Importantes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF85149),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                '3',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const HeroIcon(
                              HeroIcons.chevronUp,
                              style: HeroIconStyle.outline,
                              color: Color(0xFF8B949E),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      
                      // Lista de alertas (scrollable)
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                          children: [
                            _buildAlertItem(
                              icon: HeroIcons.lockOpen,
                              title: 'Puerta de entrada abierta',
                              subtitle: 'Hace 5 minutos',
                              severity: AlertSeverity.high,
                            ),
                            const SizedBox(height: 12),
                            _buildAlertItem(
                              icon: HeroIcons.videoCamera,
                              title: 'Movimiento detectado en jardín',
                              subtitle: 'Hace 15 minutos',
                              severity: AlertSeverity.medium,
                            ),
                            const SizedBox(height: 12),
                            _buildAlertItem(
                              icon: HeroIcons.battery0,
                              title: 'Sensor cocina batería baja',
                              subtitle: 'Hace 1 hora',
                              severity: AlertSeverity.low,
                            ),
                            const SizedBox(height: 12),
                            _buildAlertItem(
                              icon: HeroIcons.wifi,
                              title: 'Cámara garaje desconectada',
                              subtitle: 'Hace 2 horas',
                              severity: AlertSeverity.medium,
                            ),
                            const SizedBox(height: 12),
                            _buildAlertItem(
                              icon: HeroIcons.fire,
                              title: 'Temperatura alta en ático',
                              subtitle: 'Hace 3 horas',
                              severity: AlertSeverity.low,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCardHorizontal({
    required HeroIcons icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF30363D),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: HeroIcon(
              icon,
              style: HeroIconStyle.solid,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8B949E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF8B949E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF30363D),
        ),
      ),
      child: Row(
        children: [
          // Icono y datos
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const HeroIcon(
              HeroIcons.bolt,
              style: HeroIconStyle.solid,
              color: Color(0xFFFFD700),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Consumo Energético',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8B949E),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '45.2 kWh',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Mini gráfico
          SizedBox(
            width: 80,
            height: 45,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 25),
                      FlSpot(1, 35),
                      FlSpot(2, 55),
                      FlSpot(3, 70),
                      FlSpot(4, 60),
                      FlSpot(5, 45),
                      FlSpot(6, 40),
                    ],
                    isCurved: true,
                    curveSmoothness: 0.4,
                    color: const Color(0xFFFFD700),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFFFFD700).withValues(alpha: 0.3),
                          const Color(0xFFFFD700).withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ],
                lineTouchData: const LineTouchData(enabled: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem({
    required HeroIcons icon,
    required String title,
    required String subtitle,
    required AlertSeverity severity,
  }) {
    Color alertColor;
    Color bgColor;
    
    switch (severity) {
      case AlertSeverity.high:
        alertColor = const Color(0xFFF85149);
        bgColor = const Color(0xFFF85149).withValues(alpha: 0.1);
        break;
      case AlertSeverity.medium:
        alertColor = const Color(0xFFFFD700);
        bgColor = const Color(0xFFFFD700).withValues(alpha: 0.1);
        break;
      case AlertSeverity.low:
        alertColor = const Color(0xFF58A6FF);
        bgColor = const Color(0xFF58A6FF).withValues(alpha: 0.1);
        break;
    }
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: alertColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: alertColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: HeroIcon(
              icon,
              style: HeroIconStyle.solid,
              color: alertColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: alertColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8B949E),
                  ),
                ),
              ],
            ),
          ),
          HeroIcon(
            HeroIcons.chevronRight,
            style: HeroIconStyle.outline,
            color: alertColor.withValues(alpha: 0.6),
            size: 16,
          ),
        ],
      ),
    );
  }
}

enum AlertSeverity { high, medium, low }
