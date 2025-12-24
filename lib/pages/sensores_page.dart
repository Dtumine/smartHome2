import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import '../theme/app_colors.dart';

class SensoresPage extends StatefulWidget {
  const SensoresPage({super.key});

  @override
  State<SensoresPage> createState() => _SensoresPageState();
}

class _SensoresPageState extends State<SensoresPage> with SingleTickerProviderStateMixin {
  int _categoriaSeleccionada = 0;
  int _selectedNavIndex = 0;
  Timer? _autoScrollTimer;
  late AnimationController _alertBlinkController;
  late Animation<double> _alertBlinkAnimation;

  final List<CategoriaSensor> _categorias = [
    CategoriaSensor(
      nombre: 'Movimiento',
      icono: Icons.directions_run,
      color: const Color(0xFFFFD700),
      gradientEnd: const Color(0xFFFF8C00),
      sensores: [
        Sensor(nombre: 'Sala Principal', valor: 'Sin movimiento', activo: true, alerta: false),
        Sensor(nombre: 'Entrada', valor: 'Movimiento detectado', activo: true, alerta: true),
        Sensor(nombre: 'Jardín Trasero', valor: 'Sin movimiento', activo: true, alerta: false),
        Sensor(nombre: 'Garage', valor: 'Sin movimiento', activo: false, alerta: false),
      ],
    ),
    CategoriaSensor(
      nombre: 'Humedad',
      icono: Icons.water_drop,
      color: const Color(0xFF58A6FF),
      gradientEnd: const Color(0xFF0077B6),
      sensores: [
        Sensor(nombre: 'Sala de Estar', valor: '45%', activo: true, alerta: false),
        Sensor(nombre: 'Dormitorio 1', valor: '52%', activo: true, alerta: false),
        Sensor(nombre: 'Baño Principal', valor: '78%', activo: true, alerta: true),
        Sensor(nombre: 'Cocina', valor: '38%', activo: true, alerta: false),
        Sensor(nombre: 'Sótano', valor: '65%', activo: true, alerta: false),
      ],
    ),
    CategoriaSensor(
      nombre: 'CO',
      icono: Icons.cloud,
      color: const Color(0xFFF85149),
      gradientEnd: const Color(0xFFDA3633),
      sensores: [
        Sensor(nombre: 'Cocina', valor: '0 ppm', activo: true, alerta: false),
        Sensor(nombre: 'Garage', valor: '12 ppm', activo: true, alerta: false),
        Sensor(nombre: 'Caldera', valor: '5 ppm', activo: true, alerta: false),
        Sensor(nombre: 'Sala', valor: '0 ppm', activo: true, alerta: false),
      ],
    ),
    CategoriaSensor(
      nombre: 'Puertas',
      icono: Icons.door_front_door,
      color: const Color(0xFF7EE787),
      gradientEnd: const Color(0xFF238636),
      sensores: [
        Sensor(nombre: 'Entrada Principal', valor: 'Cerrada', activo: true, alerta: false),
        Sensor(nombre: 'Puerta Trasera', valor: 'Cerrada', activo: true, alerta: false),
        Sensor(nombre: 'Garage', valor: 'Abierta', activo: true, alerta: true),
        Sensor(nombre: 'Terraza', valor: 'Cerrada', activo: true, alerta: false),
      ],
    ),
    CategoriaSensor(
      nombre: 'Ventanas',
      icono: Icons.window,
      color: const Color(0xFFA78BFA),
      gradientEnd: const Color(0xFF7C3AED),
      sensores: [
        Sensor(nombre: 'Sala de Estar', valor: 'Cerrada', activo: true, alerta: false),
        Sensor(nombre: 'Dormitorio 1', valor: 'Abierta', activo: true, alerta: true),
        Sensor(nombre: 'Dormitorio 2', valor: 'Cerrada', activo: true, alerta: false),
        Sensor(nombre: 'Cocina', valor: 'Cerrada', activo: true, alerta: false),
        Sensor(nombre: 'Baño', valor: 'Abierta', activo: true, alerta: false),
      ],
    ),
  ];

  int get _sensoresActivos => _categorias.fold(
      0, (sum, cat) => sum + cat.sensores.where((s) => s.activo).length);

  int get _alertasActivas => _categorias.fold(
      0, (sum, cat) => sum + cat.sensores.where((s) => s.alerta).length);
  
  // Calcular total de alertas (sensores + cerraduras)
  int get _totalAlertas {
    final alertasSensores = _alertasActivas;
    // Alertas de cerraduras (simuladas - en producción vendrían de un provider)
    final alertasCerraduras = 4; // Garage abierta, Garage batería baja, Puerta Lateral batería baja, Puerta Lateral desconectada
    return alertasSensores + alertasCerraduras;
  }

  @override
  void initState() {
    super.initState();
    // Iniciar el cambio automático cada 3 segundos
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _categoriaSeleccionada = (_categoriaSeleccionada + 1) % _categorias.length;
        });
      }
    });

    // Animación de titileo para alertas
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
    _autoScrollTimer?.cancel();
    _alertBlinkController.dispose();
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
                            'Sensores',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '$_sensoresActivos activos · $_alertasActivas alertas',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8B949E),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_alertasActivas > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              size: 16,
                              color: Color(0xFFFFD700),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$_alertasActivas',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFD700),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // KPI Card principal
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildKpiCard(),
              ),

              const SizedBox(height: 12),

              // Alertas Card debajo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildAlertasCard(),
              ),

              const SizedBox(height: 12),

              // Panel de resumen general
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildResumenGeneral(),
              ),

              const SizedBox(height: 14),

              const SizedBox(height: 12),

              // Lista de categorías (cards seleccionables) - Scroll horizontal
              SizedBox(
                height: 85,
                child: _buildCategoriasHorizontal(),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCategoriasHorizontal() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _categorias.length,
      itemBuilder: (context, index) {
        return _buildCategoriaCard(_categorias[index], index);
      },
    );
  }

  Widget _buildCategoriaCard(CategoriaSensor categoria, int index) {
    final isSelected = _categoriaSeleccionada == index;
    final tieneAlertas = categoria.sensores.any((s) => s.alerta);
    final sensoresActivos = categoria.sensores.where((s) => s.activo).length;

    String valorPrincipal = _getValorPrincipal(categoria);

    return GestureDetector(
      onTap: () {
        setState(() {
          _categoriaSeleccionada = index;
        });
        // Detener el timer cuando el usuario selecciona manualmente
        _autoScrollTimer?.cancel();
        _autoScrollTimer = null;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        width: 160,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? categoria.color.withValues(alpha: 0.6)
                : tieneAlertas
                    ? const Color(0xFFFFD700).withValues(alpha: 0.4)
                    : const Color(0xFF30363D),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: categoria.color.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Icono
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    categoria.color,
                    categoria.gradientEnd,
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: categoria.color.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                categoria.icono,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          categoria.nombre,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (tieneAlertas) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 12,
                          color: Color(0xFFFFD700),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${categoria.sensores.length} sensores',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF8B949E),
                    ),
                  ),
                ],
              ),
            ),

            // Valor
            Text(
              valorPrincipal,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: tieneAlertas ? const Color(0xFFFFD700) : categoria.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard() {
    final categoria = _categorias[_categoriaSeleccionada];
    final tieneAlertas = categoria.sensores.any((s) => s.alerta);
    final alertas = categoria.sensores.where((s) => s.alerta).length;
    final activos = categoria.sensores.where((s) => s.activo).length;
    final valorPrincipal = _getValorPrincipal(categoria);

    return GestureDetector(
      onTap: () {
        // Detener el cambio automático cuando se hace click en la card
        _autoScrollTimer?.cancel();
        _autoScrollTimer = null;
      },
      child: Container(
        height: 160,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: tieneAlertas 
                ? const Color(0xFFFFD700).withValues(alpha: 0.4)
                : categoria.color.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: (tieneAlertas ? const Color(0xFFFFD700) : categoria.color).withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Nombre de la categoría arriba y centrado
          Text(
            categoria.nombre,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 12),
          
          // Resto de la información abajo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icono
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [categoria.color, categoria.gradientEnd],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: categoria.color.withValues(alpha: 0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  categoria.icono,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              
              // Estadísticas
              Wrap(
                spacing: 10,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: [
                  _buildKpiStat('${categoria.sensores.length}', 'Total', categoria.color),
                  _buildKpiStat('$activos', 'Act.', const Color(0xFF7EE787)),
                  if (alertas > 0)
                    _buildKpiStat('$alertas', 'Alert.', const Color(0xFFFFD700)),
                ],
              ),
              
              const SizedBox(width: 12),
              
              // Valor principal
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    valorPrincipal,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: tieneAlertas ? const Color(0xFFFFD700) : categoria.color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: tieneAlertas
                          ? const Color(0xFFFFD700).withValues(alpha: 0.15)
                          : const Color(0xFF7EE787).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          tieneAlertas ? Icons.warning_amber_rounded : Icons.check_circle,
                          size: 9,
                          color: tieneAlertas ? const Color(0xFFFFD700) : const Color(0xFF7EE787),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          tieneAlertas ? 'Alerta' : 'OK',
                          style: TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.w600,
                            color: tieneAlertas ? const Color(0xFFFFD700) : const Color(0xFF7EE787),
                          ),
                        ),
                      ],
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

  Widget _buildSensorItem(Sensor sensor, Color categoriaColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          // Indicador de estado
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: sensor.alerta
                  ? const Color(0xFFFFD700)
                  : sensor.activo
                      ? const Color(0xFF7EE787)
                      : const Color(0xFF8B949E),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          // Nombre del sensor
          Expanded(
            child: Text(
              sensor.nombre,
              style: TextStyle(
                fontSize: 11,
                fontWeight: sensor.alerta ? FontWeight.w600 : FontWeight.normal,
                color: sensor.alerta ? const Color(0xFFFFD700) : Colors.white,
              ),
            ),
          ),
          // Valor
          Text(
            sensor.valor,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: sensor.alerta
                  ? const Color(0xFFFFD700)
                  : categoriaColor,
            ),
          ),
          if (sensor.alerta) ...[
            const SizedBox(width: 4),
            const Icon(
              Icons.warning_amber_rounded,
              size: 12,
              color: Color(0xFFFFD700),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildKpiStat(String valor, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          valor,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: Color(0xFF8B949E),
          ),
        ),
      ],
    );
  }

  Widget _buildResumenGeneral() {
    final totalSensores = _categorias.fold(0, (sum, cat) => sum + cat.sensores.length);
    final sensoresActivos = _sensoresActivos;
    final alertasActivas = _alertasActivas;
    final porcentajeActivos = totalSensores > 0 ? (sensoresActivos / totalSensores * 100).round() : 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF30363D),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF58A6FF).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.dashboard,
                  size: 14,
                  color: Color(0xFF58A6FF),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Resumen General',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _buildMetricaResumen(
                  icon: Icons.sensors,
                  valor: '$totalSensores',
                  label: 'Total',
                  color: const Color(0xFF58A6FF),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: const Color(0xFF30363D),
              ),
              Expanded(
                child: _buildMetricaResumen(
                  icon: Icons.check_circle,
                  valor: '$sensoresActivos',
                  label: 'Activos',
                  color: const Color(0xFF7EE787),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: const Color(0xFF30363D),
              ),
              Expanded(
                child: _buildMetricaResumen(
                  icon: Icons.warning_amber_rounded,
                  valor: '$alertasActivas',
                  label: 'Alertas',
                  color: const Color(0xFFFFD700),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: const Color(0xFF30363D),
              ),
              Expanded(
                child: _buildMetricaResumen(
                  icon: Icons.percent,
                  valor: '$porcentajeActivos%',
                  label: 'Operativo',
                  color: const Color(0xFFA78BFA),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricaResumen({
    required IconData icon,
    required String valor,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          valor,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF8B949E),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertasCard() {
    final alertas = _categorias
        .expand((cat) => cat.sensores.where((s) => s.alerta))
        .toList();

    return AnimatedBuilder(
      animation: _alertBlinkAnimation,
      builder: (context, child) {
        final opacity = alertas.isNotEmpty ? _alertBlinkAnimation.value : 1.0;
        return Opacity(
          opacity: opacity,
          child: Container(
            height: 150,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: alertas.isNotEmpty
                    ? const Color(0xFFF85149).withValues(alpha: 0.8)
                    : const Color(0xFF30363D),
                width: alertas.isNotEmpty ? 2 : 1,
              ),
              boxShadow: alertas.isNotEmpty
                  ? [
                      BoxShadow(
                        color: const Color(0xFFF85149).withValues(alpha: 0.3 * opacity),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título arriba y centrado
                Text(
                  alertas.length == 1 ? 'Alerta' : 'Alertas',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 15),
                
                // Resto de la información abajo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icono de alerta
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF85149).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF85149).withValues(alpha: 0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFF85149),
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Número de alertas
                    Text(
                      '${alertas.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF85149),
                      ),
                    ),
                    if (alertas.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      // Lista compacta de alertas
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...alertas.take(2).map((sensor) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 3,
                                      height: 3,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF85149),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        sensor.nombre,
                                        style: const TextStyle(
                                          fontSize: 8,
                                          color: Color(0xFFF85149),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            if (alertas.length > 2)
                              Text(
                                '+${alertas.length - 2} más',
                                style: const TextStyle(
                                  fontSize: 7,
                                  color: Color(0xFF8B949E),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
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

  String _getValorPrincipal(CategoriaSensor categoria) {
    switch (categoria.nombre) {
      case 'Movimiento':
        final detectados = categoria.sensores.where((s) => s.valor.contains('detectado')).length;
        return '$detectados';
      case 'Humedad':
        final valores = categoria.sensores
            .where((s) => s.activo)
            .map((s) => int.tryParse(s.valor.replaceAll('%', '')) ?? 0)
            .toList();
        if (valores.isEmpty) return '0%';
        final promedio = valores.reduce((a, b) => a + b) ~/ valores.length;
        return '$promedio%';
      case 'CO':
        final valores = categoria.sensores
            .where((s) => s.activo)
            .map((s) => int.tryParse(s.valor.replaceAll(' ppm', '')) ?? 0)
            .toList();
        if (valores.isEmpty) return '0';
        final maximo = valores.reduce((a, b) => a > b ? a : b);
        return '$maximo';
      case 'Puertas':
        final abiertas = categoria.sensores.where((s) => s.valor == 'Abierta').length;
        return '$abiertas';
      case 'Ventanas':
        final abiertas = categoria.sensores.where((s) => s.valor == 'Abierta').length;
        return '$abiertas';
      default:
        return '';
    }
  }
}

// Modelos de datos
class CategoriaSensor {
  final String nombre;
  final IconData icono;
  final Color color;
  final Color gradientEnd;
  final List<Sensor> sensores;

  CategoriaSensor({
    required this.nombre,
    required this.icono,
    required this.color,
    required this.gradientEnd,
    required this.sensores,
  });
}

class Sensor {
  final String nombre;
  final String valor;
  final bool activo;
  final bool alerta;

  Sensor({
    required this.nombre,
    required this.valor,
    required this.activo,
    required this.alerta,
  });
}
