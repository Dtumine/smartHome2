import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/smart_home_option.dart';
import '../services/panel_service.dart';
import '../widgets/smart_home_card_compact.dart';
import '../theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  
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
  }

  @override
  void dispose() {
    _alertBlinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.celestialBlueGradient,
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header con logo, título y botones
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Logo y título
                          Flexible(
                            child: Row(
                              children: [
                                // Logo circular
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        // Si la imagen no existe, mostrar un placeholder
                                        return Container(
                                          color: const Color(0xFF21262D),
                                          child: const Icon(
                                            Icons.home,
                                            color: Color(0xFF58A6FF),
                                            size: 24,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Text(
                                    'Smart Home',
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Botones de notificaciones y perfil
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF21262D),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFF30363D),
                                    width: 1,
                                  ),
                                ),
                                child: const HeroIcon(
                                  HeroIcons.bellAlert,
                                  style: HeroIconStyle.outline,
                                  color: Color(0xFF58A6FF),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => context.push('/ajustes'),
                                child: _buildAvatarPerfil(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Status card - Centro de Mando
                      GestureDetector(
                        onTap: () => context.push('/centro-mando'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF238636),
                                Color(0xFF1F6FEB),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF238636).withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const HeroIcon(
                                  HeroIcons.home,
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
                                    const Text(
                                      'Centro de Mando',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '27 dispositivos conectados',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const HeroIcon(
                                HeroIcons.chevronRight,
                                style: HeroIconStyle.outline,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),
              // Título de sección
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Panel de Control',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      ValueListenableBuilder<List<SmartHomeOption>>(
                        valueListenable: PanelService().iconosNotifier,
                        builder: (context, iconosActivos, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF21262D),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF30363D),
                              ),
                            ),
                            child: Row(
                              children: [
                                const HeroIcon(
                                  HeroIcons.squares2x2,
                                  style: HeroIconStyle.mini,
                                  color: Color(0xFF8B949E),
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${iconosActivos.length} módulo${iconosActivos.length != 1 ? 's' : ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF8B949E),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),
              // Módulos - Grid dinámico basado en PanelService
              SliverToBoxAdapter(
                child: ValueListenableBuilder<List<SmartHomeOption>>(
                  valueListenable: PanelService().iconosNotifier,
                  builder: (context, iconosActivos, child) {
                    // Dividir en filas: 3 en la primera, resto en la segunda
                    final primeraFila = iconosActivos.take(3).toList();
                    final segundaFila = iconosActivos.skip(3).toList();
                    final tieneMasDeSeis = iconosActivos.length > 6;
                    
                    return Column(
                      children: [
                        // Fila superior
                        if (primeraFila.isNotEmpty)
                          LayoutBuilder(
                            builder: (context, constraints) {
                              // Calcular si las tarjetas caben sin overflow
                              final anchoTarjeta = 90.0;
                              final paddingEntreTarjetas = 12.0; // 6 a cada lado
                              final paddingLateral = 48.0; // 24 a cada lado
                              final anchoTotalNecesario = (primeraFila.length * anchoTarjeta) +
                                  ((primeraFila.length - 1) * paddingEntreTarjetas) +
                                  paddingLateral;
                              
                              final necesitaScroll = anchoTotalNecesario > constraints.maxWidth;
                              
                              if (necesitaScroll) {
                                // Usar scroll horizontal si no caben
                                return SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                    itemCount: primeraFila.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                        child: SmartHomeCardCompact(option: primeraFila[index]),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                // Usar Row normal si caben
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: primeraFila
                                        .map((option) => Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 6),
                                              child: SmartHomeCardCompact(option: option),
                                            ))
                                        .toList(),
                                  ),
                                );
                              }
                            },
                          ),
                        if (primeraFila.isNotEmpty && segundaFila.isNotEmpty)
                          const SizedBox(height: 12),
                        // Fila inferior - con scroll si hay más de 6 módulos
                        if (segundaFila.isNotEmpty)
                          SizedBox(
                            height: 120, // Altura fija para mantener consistencia
                            child: tieneMasDeSeis
                                ? ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                    itemCount: segundaFila.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                        child: SmartHomeCardCompact(option: segundaFila[index]),
                                      );
                                    },
                                  )
                                : LayoutBuilder(
                                    builder: (context, constraints) {
                                      // Calcular si las tarjetas caben sin overflow
                                      final anchoTarjeta = 90.0;
                                      final paddingEntreTarjetas = 12.0; // 6 a cada lado
                                      final paddingLateral = 48.0; // 24 a cada lado
                                      final anchoTotalNecesario = (segundaFila.length * anchoTarjeta) +
                                          ((segundaFila.length - 1) * paddingEntreTarjetas) +
                                          paddingLateral;
                                      
                                      final necesitaScroll = anchoTotalNecesario > constraints.maxWidth;
                                      
                                      if (necesitaScroll) {
                                        // Usar scroll horizontal si no caben
                                        return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                          itemCount: segundaFila.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 6),
                                              child: SmartHomeCardCompact(option: segundaFila[index]),
                                            );
                                          },
                                        );
                                      } else {
                                        // Usar Row normal si caben
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: segundaFila
                                                .map((option) => Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                                      child: SmartHomeCardCompact(option: option),
                                                    ))
                                                .toList(),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),
              // Gráfico de consumo semanal
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF30363D),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  HeroIcon(
                                    HeroIcons.bolt,
                                    style: HeroIconStyle.solid,
                                    color: Color(0xFFFFD700),
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Consumo Semanal',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7EE787).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_downward_rounded,
                                      size: 10,
                                      color: Color(0xFF7EE787),
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      '12%',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF7EE787),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: 20,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: const Color(0xFF30363D).withValues(alpha: 0.5),
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 18,
                                      interval: 1,
                                      getTitlesWidget: (value, meta) {
                                        const days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
                                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                                          return Text(
                                            days[value.toInt()],
                                            style: const TextStyle(
                                              color: Color(0xFF8B949E),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          );
                                        }
                                        return const Text('');
                                      },
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                minX: 0,
                                maxX: 6,
                                minY: 0,
                                maxY: 100,
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: const [
                                      FlSpot(0, 45),
                                      FlSpot(1, 68),
                                      FlSpot(2, 52),
                                      FlSpot(3, 78),
                                      FlSpot(4, 63),
                                      FlSpot(5, 42),
                                      FlSpot(6, 55),
                                    ],
                                    isCurved: true,
                                    curveSmoothness: 0.35,
                                    color: const Color(0xFF58A6FF),
                                    barWidth: 2.5,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter: (spot, percent, barData, index) {
                                        return FlDotCirclePainter(
                                          radius: 3,
                                          color: const Color(0xFF161B22),
                                          strokeWidth: 2,
                                          strokeColor: const Color(0xFF58A6FF),
                                        );
                                      },
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          const Color(0xFF58A6FF).withValues(alpha: 0.3),
                                          const Color(0xFF58A6FF).withValues(alpha: 0.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                                lineTouchData: LineTouchData(
                                  touchTooltipData: LineTouchTooltipData(
                                    getTooltipColor: (touchedSpot) => const Color(0xFF21262D),
                                    tooltipRoundedRadius: 8,
                                    getTooltipItems: (touchedSpots) {
                                      return touchedSpots.map((spot) {
                                        return LineTooltipItem(
                                          '${spot.y.toInt()} kWh',
                                          const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        );
                                      }).toList();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 8),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
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
      ),
    );
  }

  Widget _buildAvatarPerfil() {
    // Obtener datos del usuario desde los providers
    final userEmailAsync = ref.watch(userEmailProvider);
    final userNameAsync = ref.watch(userNameProvider);
    final userFullNameAsync = ref.watch(userFullNameProvider);
    final userPhotoPathAsync = ref.watch(userPhotoPathProvider);
    
    final nombreCompleto = userFullNameAsync.value;
    final nombreUsuario = nombreCompleto ?? userNameAsync.value ?? 'Usuario';
    final avatarInicial = nombreUsuario.isNotEmpty 
        ? nombreUsuario.substring(0, 1).toUpperCase() 
        : 'U';
    final fotoPath = userPhotoPathAsync.value;
    
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF58A6FF),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF58A6FF).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: const Color(0xFF21262D),
        child: fotoPath != null && fotoPath.isNotEmpty
            ? fotoPath == 'web_image'
                ? FutureBuilder<String?>(
                    future: AuthService().getUserPhotoBase64(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
                        return ClipOval(
                          child: Image.memory(
                            base64Decode(snapshot.data!),
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
                          ),
                        );
                      }
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF58A6FF),
                              const Color(0xFF58A6FF).withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            avatarInicial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : !kIsWeb && File(fotoPath).existsSync()
                    ? ClipOval(
                        child: Image.file(
                          File(fotoPath),
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF58A6FF),
                              const Color(0xFF58A6FF).withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            avatarInicial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
            : Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF58A6FF),
                      const Color(0xFF58A6FF).withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    avatarInicial,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
    final isSelected = _selectedIndex == index;
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
          _selectedIndex = index;
        });
        // Navegar según el índice
        if (index == 0) {
          // Ya estamos en home
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

