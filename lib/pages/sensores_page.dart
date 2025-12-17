import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

class SensoresPage extends StatefulWidget {
  const SensoresPage({super.key});

  @override
  State<SensoresPage> createState() => _SensoresPageState();
}

class _SensoresPageState extends State<SensoresPage> {
  int _categoriaSeleccionada = 0;
  int _selectedNavIndex = 0;

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

              // KPI Card con detalles de la categoría seleccionada (ARRIBA)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildKpiCard(),
              ),

              const SizedBox(height: 14),

              // Lista de categorías (cards seleccionables) - ABAJO con scroll
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    children: _categorias.asMap().entries.map((entry) => 
                      _buildCategoriaCard(entry.value, entry.key)).toList(),
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
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    categoria.color,
                    categoria.gradientEnd,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: categoria.color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                categoria.icono,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        categoria.nombre,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (tieneAlertas) ...[
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: Color(0xFFFFD700),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${categoria.sensores.length} sensores · $sensoresActivos activos',
                    style: const TextStyle(
                      fontSize: 12,
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
                fontSize: 18,
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 45),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: tieneAlertas 
              ? const Color(0xFFFFD700).withValues(alpha: 0.4)
              : categoria.color.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: (tieneAlertas ? const Color(0xFFFFD700) : categoria.color).withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icono
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [categoria.color, categoria.gradientEnd],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: categoria.color.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              categoria.icono,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          
          // Info central
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  categoria.nombre,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    _buildKpiStat('${categoria.sensores.length}', 'Total', categoria.color),
                    _buildKpiStat('$activos', 'Act.', const Color(0xFF7EE787)),
                    if (alertas > 0)
                      _buildKpiStat('$alertas', 'Alert.', const Color(0xFFFFD700)),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Valor principal
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                valorPrincipal,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: tieneAlertas ? const Color(0xFFFFD700) : categoria.color,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: tieneAlertas
                      ? const Color(0xFFFFD700).withValues(alpha: 0.15)
                      : const Color(0xFF7EE787).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tieneAlertas ? Icons.warning_amber_rounded : Icons.check_circle,
                      size: 11,
                      color: tieneAlertas ? const Color(0xFFFFD700) : const Color(0xFF7EE787),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      tieneAlertas ? 'Alerta' : 'OK',
                      style: TextStyle(
                        fontSize: 9,
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
    );
  }

  Widget _buildKpiStat(String valor, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          valor,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: 3),
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
        // Navegar a Home si se presiona
        if (index == 0) {
          context.go('/');
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
