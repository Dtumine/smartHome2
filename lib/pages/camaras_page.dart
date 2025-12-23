import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import '../theme/app_colors.dart';

class CamarasPage extends StatefulWidget {
  const CamarasPage({super.key});

  @override
  State<CamarasPage> createState() => _CamarasPageState();
}

class _CamarasPageState extends State<CamarasPage> {
  int _camaraSeleccionada = 0;
  int _selectedNavIndex = 0;

  final List<Camara> _camaras = [
    Camara(
      nombre: 'Entrada Principal',
      ubicacion: 'Exterior',
      icono: Icons.door_front_door,
      enLinea: true,
      grabando: true,
      movimientoDetectado: false,
      color: const Color(0xFF00CED1),
    ),
    Camara(
      nombre: 'Jardín Trasero',
      ubicacion: 'Exterior',
      icono: Icons.park,
      enLinea: true,
      grabando: true,
      movimientoDetectado: true,
      color: const Color(0xFF7EE787),
    ),
    Camara(
      nombre: 'Garage',
      ubicacion: 'Interior',
      icono: Icons.garage,
      enLinea: true,
      grabando: false,
      movimientoDetectado: false,
      color: const Color(0xFFFFD700),
    ),
    Camara(
      nombre: 'Sala de Estar',
      ubicacion: 'Interior',
      icono: Icons.weekend,
      enLinea: false,
      grabando: false,
      movimientoDetectado: false,
      color: const Color(0xFFF85149),
    ),
    Camara(
      nombre: 'Piscina',
      ubicacion: 'Exterior',
      icono: Icons.pool,
      enLinea: true,
      grabando: true,
      movimientoDetectado: false,
      color: const Color(0xFF58A6FF),
    ),
    Camara(
      nombre: 'Cochera',
      ubicacion: 'Exterior',
      icono: Icons.directions_car,
      enLinea: true,
      grabando: false,
      movimientoDetectado: false,
      color: const Color(0xFFA78BFA),
    ),
  ];

  Camara get _camaraActual => _camaras[_camaraSeleccionada];

  int get _camarasEnLinea => _camaras.where((c) => c.enLinea).length;

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
                            'Cámaras de Seguridad',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '$_camarasEnLinea de ${_camaras.length} en línea',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8B949E),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Indicador de grabación
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
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF85149),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'REC',
                            style: TextStyle(
                              fontSize: 11,
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

              const SizedBox(height: 16),

              // Vista principal de la cámara seleccionada (altura flexible pero limitada)
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildVistaPrevia(),
                ),
              ),

              const SizedBox(height: 14),

              // Controles de la cámara (un poco más de espacio)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildControles(),
              ),

              const SizedBox(height: 14),

              // Barra de cámaras (scroll horizontal) - más altura
              Expanded(
                flex: 2,
                child: _buildCamarasBar(),
              ),

              const SizedBox(height: 12),
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
    final color = isSelected ? const Color(0xFF58A6FF) : const Color(0xFF8B949E);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
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

  Widget _buildVistaPrevia() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _camaraActual.enLinea
              ? _camaraActual.color.withValues(alpha: 0.5)
              : const Color(0xFF30363D),
          width: 2,
        ),
        boxShadow: _camaraActual.enLinea
            ? [
                BoxShadow(
                  color: _camaraActual.color.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Fondo de la cámara (simulado)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _camaraActual.enLinea
                      ? [
                          const Color(0xFF1a1a2e),
                          const Color(0xFF16213e),
                          const Color(0xFF0f0f23),
                        ]
                      : [
                          const Color(0xFF21262D),
                          const Color(0xFF161B22),
                        ],
                ),
              ),
              child: _camaraActual.enLinea
                  ? _buildCamaraEnLinea()
                  : _buildCamaraOffline(),
            ),

            // Overlay superior con info
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    // Nombre y ubicación
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _camaraActual.nombre,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: _camaraActual.color,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _camaraActual.ubicacion,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _camaraActual.color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Indicadores
                    if (_camaraActual.enLinea) ...[
                      if (_camaraActual.grabando)
                        _buildIndicador(
                          icon: Icons.fiber_manual_record,
                          color: const Color(0xFFF85149),
                          label: 'REC',
                          pulsar: true,
                        ),
                      const SizedBox(width: 8),
                      if (_camaraActual.movimientoDetectado)
                        _buildIndicador(
                          icon: Icons.directions_run,
                          color: const Color(0xFFFFD700),
                          label: 'Movimiento',
                          pulsar: true,
                        ),
                    ],
                  ],
                ),
              ),
            ),

            // Overlay inferior con hora
            if (_camaraActual.enLinea)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Timestamp
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _getCurrentTime(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'monospace',
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Calidad
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7EE787).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFF7EE787).withValues(alpha: 0.5),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.hd,
                              size: 14,
                              color: Color(0xFF7EE787),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '1080p',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7EE787),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCamaraEnLinea() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Patrón de fondo simulando video
        CustomPaint(
          painter: _GridPainter(),
        ),
        // Icono central grande
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _camaraActual.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _camaraActual.color.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  _camaraActual.icono,
                  size: 48,
                  color: _camaraActual.color,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF7EE787).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF7EE787).withValues(alpha: 0.5),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.videocam,
                      size: 16,
                      color: Color(0xFF7EE787),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'EN VIVO',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7EE787),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCamaraOffline() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF85149).withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFF85149).withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.videocam_off,
              size: 48,
              color: Color(0xFFF85149),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Cámara Desconectada',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF85149),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Verifica la conexión de red',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF8B949E),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Intentar reconectar
              setState(() {
                _camaras[_camaraSeleccionada].enLinea = true;
              });
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF21262D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color(0xFF30363D)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicador({
    required IconData icon,
    required Color color,
    required String label,
    bool pulsar = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControles() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF30363D),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBotonControl(
            icono: _camaraActual.grabando ? Icons.stop : Icons.fiber_manual_record,
            label: _camaraActual.grabando ? 'Detener' : 'Grabar',
            color: const Color(0xFFF85149),
            activo: _camaraActual.grabando,
            onTap: () {
              setState(() {
                _camaras[_camaraSeleccionada].grabando = 
                    !_camaras[_camaraSeleccionada].grabando;
              });
            },
          ),
          _buildBotonControl(
            icono: Icons.camera_alt,
            label: 'Captura',
            color: const Color(0xFF58A6FF),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('📸 Captura guardada'),
                  backgroundColor: const Color(0xFF21262D),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
          _buildBotonControl(
            icono: Icons.fullscreen,
            label: 'Expandir',
            color: const Color(0xFF7EE787),
            onTap: () {
              // Pantalla completa
            },
          ),
          _buildBotonControl(
            icono: Icons.volume_up,
            label: 'Audio',
            color: const Color(0xFFFFD700),
            onTap: () {
              // Toggle audio
            },
          ),
          _buildBotonControl(
            icono: Icons.settings,
            label: 'Config',
            color: const Color(0xFF8B949E),
            onTap: () {
              // Configuración
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBotonControl({
    required IconData icono,
    required String label,
    required Color color,
    bool activo = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: _camaraActual.enLinea ? onTap : null,
      child: Opacity(
        opacity: _camaraActual.enLinea ? 1.0 : 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: activo
                    ? color.withValues(alpha: 0.2)
                    : const Color(0xFF21262D),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: activo
                      ? color.withValues(alpha: 0.5)
                      : const Color(0xFF30363D),
                ),
              ),
              child: Icon(
                icono,
                color: activo ? color : const Color(0xFF8B949E),
                size: 22,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: activo ? color : const Color(0xFF8B949E),
                fontWeight: activo ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCamarasBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF30363D),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00CED1).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const HeroIcon(
                    HeroIcons.videoCamera,
                    style: HeroIconStyle.solid,
                    color: Color(0xFF00CED1),
                    size: 14,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Todas las Cámaras',
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
                        '${_camaraSeleccionada + 1}/${_camaras.length}',
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

          // Lista horizontal de cámaras
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              itemCount: _camaras.length,
              itemBuilder: (context, index) {
                return _buildCamaraChip(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCamaraChip(int index) {
    final camara = _camaras[index];
    final isSelected = _camaraSeleccionada == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _camaraSeleccionada = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? camara.color.withValues(alpha: 0.15)
              : const Color(0xFF21262D),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? camara.color.withValues(alpha: 0.6)
                : const Color(0xFF30363D),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: camara.color.withValues(alpha: 0.2),
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
                color: camara.enLinea
                    ? camara.color.withValues(alpha: 0.2)
                    : const Color(0xFFF85149).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                camara.icono,
                color: camara.enLinea ? camara.color : const Color(0xFFF85149),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            // Info
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  camara.nombre,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFFC9D1D9),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: camara.enLinea
                            ? const Color(0xFF7EE787)
                            : const Color(0xFFF85149),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      camara.enLinea ? 'En línea' : 'Offline',
                      style: TextStyle(
                        fontSize: 10,
                        color: camara.enLinea
                            ? const Color(0xFF7EE787)
                            : const Color(0xFFF85149),
                      ),
                    ),
                    if (camara.grabando && camara.enLinea) ...[
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.fiber_manual_record,
                        size: 8,
                        color: Color(0xFFF85149),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }
}

// Modelo de datos
class Camara {
  final String nombre;
  final String ubicacion;
  final IconData icono;
  bool enLinea;
  bool grabando;
  bool movimientoDetectado;
  final Color color;

  Camara({
    required this.nombre,
    required this.ubicacion,
    required this.icono,
    required this.enLinea,
    required this.grabando,
    required this.movimientoDetectado,
    required this.color,
  });
}

// Painter para el patrón de fondo
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF30363D).withValues(alpha: 0.3)
      ..strokeWidth = 0.5;

    // Líneas horizontales
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Líneas verticales
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

