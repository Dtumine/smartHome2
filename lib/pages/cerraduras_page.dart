import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import '../theme/app_colors.dart';

class CerradurasPage extends StatefulWidget {
  const CerradurasPage({super.key});

  @override
  State<CerradurasPage> createState() => _CerradurasPageState();
}

class _CerradurasPageState extends State<CerradurasPage>
    with TickerProviderStateMixin {
  // Cerradura seleccionada para ver detalles
  int _cerraduraSeleccionada = 0;

  // Tab seleccionado (0: Cerraduras, 1: Historial, 2: Usuarios)
  int _tabSeleccionado = 0;

  // Navegación inferior
  int _selectedNavIndex = 0;

  // Timer para cambio automático
  Timer? _autoScrollTimer;

  // Animación
  late AnimationController _lockAnimController;
  late Animation<double> _lockAnimation;
  
  // Animación de titileo para alertas
  late AnimationController _alertBlinkController;
  late Animation<double> _alertBlinkAnimation;

  // Datos de las cerraduras
  final List<Cerradura> _cerraduras = [
    Cerradura(
      id: 'lock_001',
      nombre: 'Puerta Principal',
      ubicacion: 'Entrada',
      icono: Icons.door_front_door,
      color: const Color(0xFF58A6FF),
      gradientEnd: const Color(0xFF0077B6),
      cerrada: true,
      bateria: 85,
      conectada: true,
      autoBloqueo: true,
      tiempoAutoBloqueo: 30,
      ultimaActividad: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    Cerradura(
      id: 'lock_002',
      nombre: 'Puerta Trasera',
      ubicacion: 'Jardín',
      icono: Icons.door_back_door,
      color: const Color(0xFF7EE787),
      gradientEnd: const Color(0xFF238636),
      cerrada: true,
      bateria: 92,
      conectada: true,
      autoBloqueo: true,
      tiempoAutoBloqueo: 60,
      ultimaActividad: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Cerradura(
      id: 'lock_003',
      nombre: 'Garage',
      ubicacion: 'Exterior',
      icono: Icons.garage,
      color: const Color(0xFFFFD700),
      gradientEnd: const Color(0xFFFF8C00),
      cerrada: false,
      bateria: 45,
      conectada: true,
      autoBloqueo: false,
      tiempoAutoBloqueo: 0,
      ultimaActividad: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Cerradura(
      id: 'lock_004',
      nombre: 'Oficina',
      ubicacion: 'Interior',
      icono: Icons.work,
      color: const Color(0xFFA78BFA),
      gradientEnd: const Color(0xFF7C3AED),
      cerrada: true,
      bateria: 78,
      conectada: true,
      autoBloqueo: true,
      tiempoAutoBloqueo: 120,
      ultimaActividad: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Cerradura(
      id: 'lock_005',
      nombre: 'Puerta Lateral',
      ubicacion: 'Cocina',
      icono: Icons.door_sliding,
      color: const Color(0xFFFF6B6B),
      gradientEnd: const Color(0xFFEE5A24),
      cerrada: true,
      bateria: 12,
      conectada: false,
      autoBloqueo: true,
      tiempoAutoBloqueo: 30,
      ultimaActividad: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  // Historial de eventos
  final List<EventoCerradura> _eventos = [
    EventoCerradura(
      cerraduraId: 'lock_003',
      cerraduraNombre: 'Garage',
      tipo: TipoEvento.desbloqueada,
      metodo: MetodoAcceso.app,
      usuario: 'Tú',
      fecha: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    EventoCerradura(
      cerraduraId: 'lock_001',
      cerraduraNombre: 'Puerta Principal',
      tipo: TipoEvento.bloqueada,
      metodo: MetodoAcceso.autoBloqueo,
      usuario: 'Sistema',
      fecha: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    EventoCerradura(
      cerraduraId: 'lock_001',
      cerraduraNombre: 'Puerta Principal',
      tipo: TipoEvento.desbloqueada,
      metodo: MetodoAcceso.huella,
      usuario: 'María García',
      fecha: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    EventoCerradura(
      cerraduraId: 'lock_002',
      cerraduraNombre: 'Puerta Trasera',
      tipo: TipoEvento.bloqueada,
      metodo: MetodoAcceso.codigo,
      usuario: 'Juan Pérez',
      fecha: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    EventoCerradura(
      cerraduraId: 'lock_001',
      cerraduraNombre: 'Puerta Principal',
      tipo: TipoEvento.intentoFallido,
      metodo: MetodoAcceso.codigo,
      usuario: 'Desconocido',
      fecha: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    EventoCerradura(
      cerraduraId: 'lock_004',
      cerraduraNombre: 'Oficina',
      tipo: TipoEvento.bloqueada,
      metodo: MetodoAcceso.llave,
      usuario: 'Carlos López',
      fecha: DateTime.now().subtract(const Duration(days: 1)),
    ),
    EventoCerradura(
      cerraduraId: 'lock_001',
      cerraduraNombre: 'Puerta Principal',
      tipo: TipoEvento.desbloqueada,
      metodo: MetodoAcceso.app,
      usuario: 'Tú',
      fecha: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    ),
    EventoCerradura(
      cerraduraId: 'lock_003',
      cerraduraNombre: 'Garage',
      tipo: TipoEvento.bateriaBaja,
      metodo: MetodoAcceso.sistema,
      usuario: 'Sistema',
      fecha: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // Usuarios autorizados
  final List<UsuarioAutorizado> _usuarios = [
    UsuarioAutorizado(
      nombre: 'Tú',
      email: 'tu@email.com',
      avatar: 'T',
      rol: 'Propietario',
      color: const Color(0xFF58A6FF),
      accesos: ['lock_001', 'lock_002', 'lock_003', 'lock_004', 'lock_005'],
      metodos: [MetodoAcceso.app, MetodoAcceso.huella, MetodoAcceso.codigo],
    ),
    UsuarioAutorizado(
      nombre: 'María García',
      email: 'maria@email.com',
      avatar: 'M',
      rol: 'Familiar',
      color: const Color(0xFFA78BFA),
      accesos: ['lock_001', 'lock_002'],
      metodos: [MetodoAcceso.huella, MetodoAcceso.codigo],
    ),
    UsuarioAutorizado(
      nombre: 'Juan Pérez',
      email: 'juan@email.com',
      avatar: 'J',
      rol: 'Familiar',
      color: const Color(0xFF7EE787),
      accesos: ['lock_001', 'lock_002', 'lock_003'],
      metodos: [MetodoAcceso.codigo],
    ),
    UsuarioAutorizado(
      nombre: 'Carlos López',
      email: 'carlos@email.com',
      avatar: 'C',
      rol: 'Empleado',
      color: const Color(0xFFFFD700),
      accesos: ['lock_004'],
      metodos: [MetodoAcceso.llave, MetodoAcceso.codigo],
      codigoTemporal: true,
      expiraCodigo: DateTime.now().add(const Duration(days: 5)),
    ),
  ];

  Cerradura get _cerraduraActual => _cerraduras[_cerraduraSeleccionada];

  int get _cerradurasAbiertas => _cerraduras.where((c) => !c.cerrada).length;
  int get _cerradurasCerradas => _cerraduras.where((c) => c.cerrada).length;
  int get _alertasBateria => _cerraduras.where((c) => c.bateria < 20).length;
  int get _desconectadas => _cerraduras.where((c) => !c.conectada).length;
  
  // Calcular total de alertas (sensores + cerraduras)
  int get _totalAlertas {
    // Alertas de sensores (simuladas - en producción vendrían de un provider)
    final alertasSensores = 4; // Entrada, Baño Principal, Garage, Dormitorio 1
    // Alertas de cerraduras
    final alertasCerraduras = _cerradurasAbiertas + _alertasBateria + _desconectadas;
    return alertasSensores + alertasCerraduras;
  }

  @override
  void initState() {
    super.initState();
    _lockAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _lockAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _lockAnimController, curve: Curves.easeInOut),
    );

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

    // Iniciar el cambio automático cada 3 segundos
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _cerraduraSeleccionada = (_cerraduraSeleccionada + 1) % _cerraduras.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _lockAnimController.dispose();
    _alertBlinkController.dispose();
    super.dispose();
  }

  void _toggleCerradura(int index) {
    setState(() {
      _cerraduras[index].cerrada = !_cerraduras[index].cerrada;
      _cerraduras[index].ultimaActividad = DateTime.now();

      // Agregar evento al historial
      _eventos.insert(
        0,
        EventoCerradura(
          cerraduraId: _cerraduras[index].id,
          cerraduraNombre: _cerraduras[index].nombre,
          tipo: _cerraduras[index].cerrada
              ? TipoEvento.bloqueada
              : TipoEvento.desbloqueada,
          metodo: MetodoAcceso.app,
          usuario: 'Tú',
          fecha: DateTime.now(),
        ),
      );
    });

    // Animación
    if (_cerraduras[index].cerrada) {
      _lockAnimController.forward(from: 0);
    } else {
      _lockAnimController.reverse(from: 1);
    }
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

              const SizedBox(height: 20),

              // KPI Card principal
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildKpiCard(),
              ),

              const SizedBox(height: 16),

              // Card de alertas
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildAlertasCard(),
              ),

              const SizedBox(height: 14),

              // Resumen General
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildResumenGeneral(),
              ),

              const SizedBox(height: 14),

              // Scroll horizontal de cerraduras
              SizedBox(
                height: 100,
                child: _buildCerradurasHorizontal(),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
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
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
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
                Text(
                  'Cerraduras',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$_cerradurasCerradas cerradas · $_cerradurasAbiertas abiertas',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Botón de bloquear todas
          GestureDetector(
            onTap: _bloquearTodas,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: _cerradurasAbiertas > 0
                    ? LinearGradient(
                        colors: [AppColors.error, AppColors.errorDark],
                      )
                    : null,
                color: _cerradurasAbiertas > 0 ? null : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _cerradurasAbiertas > 0
                      ? AppColors.error.withValues(alpha: 0.5)
                      : AppColors.cardBorder,
                ),
                boxShadow: _cerradurasAbiertas > 0
                    ? [
                        BoxShadow(
                          color: AppColors.error.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock,
                    size: 14,
                    color: _cerradurasAbiertas > 0
                        ? AppColors.textWhite
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Todas',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _cerradurasAbiertas > 0
                          ? AppColors.textWhite
                          : AppColors.textSecondary,
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

  void _bloquearTodas() {
    setState(() {
      for (var cerradura in _cerraduras) {
        if (!cerradura.cerrada && cerradura.conectada) {
          cerradura.cerrada = true;
          cerradura.ultimaActividad = DateTime.now();
          _eventos.insert(
            0,
            EventoCerradura(
              cerraduraId: cerradura.id,
              cerraduraNombre: cerradura.nombre,
              tipo: TipoEvento.bloqueada,
              metodo: MetodoAcceso.app,
              usuario: 'Tú',
              fecha: DateTime.now(),
            ),
          );
        }
      }
    });
  }

  Widget _buildEstadisticas() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.lock,
              value: '$_cerradurasCerradas',
              label: 'Cerradas',
              color: const Color(0xFF7EE787),
            ),
          ),
          Container(width: 1, height: 36, color: AppColors.cardBorder),
          Expanded(
            child: _buildStatItem(
              icon: Icons.lock_open,
              value: '$_cerradurasAbiertas',
              label: 'Abiertas',
              color: _cerradurasAbiertas > 0
                  ? const Color(0xFFFF6B6B)
                  : const Color(0xFF8B949E),
            ),
          ),
          Container(width: 1, height: 36, color: AppColors.cardBorder),
          Expanded(
            child: _buildStatItem(
              icon: Icons.battery_alert,
              value: '$_alertasBateria',
              label: 'Batería',
              color: _alertasBateria > 0
                  ? const Color(0xFFFFD700)
                  : const Color(0xFF8B949E),
            ),
          ),
          Container(width: 1, height: 36, color: AppColors.cardBorder),
          Expanded(
            child: _buildStatItem(
              icon: Icons.wifi_off,
              value: '$_desconectadas',
              label: 'Offline',
              color: _desconectadas > 0
                  ? const Color(0xFFF85149)
                  : const Color(0xFF8B949E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: Color(0xFF8B949E),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Row(
        children: [
          _buildTabItem(0, 'Cerraduras', HeroIcons.lockClosed),
          _buildTabItem(1, 'Historial', HeroIcons.clock),
          _buildTabItem(2, 'Usuarios', HeroIcons.users),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label, HeroIcons icon) {
    final isSelected = _tabSeleccionado == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabSeleccionado = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF58A6FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeroIcon(
                icon,
                style: HeroIconStyle.solid,
                size: 16,
                color: isSelected ? Colors.white : const Color(0xFF8B949E),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF8B949E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContenidoTab() {
    switch (_tabSeleccionado) {
      case 0:
        return _buildListaCerraduras();
      case 1:
        return _buildHistorial();
      case 2:
        return _buildUsuarios();
      default:
        return _buildListaCerraduras();
    }
  }

  Widget _buildCerradurasHorizontal() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _cerraduras.length,
      itemBuilder: (context, index) {
        return _buildCerraduraCard(index);
      },
    );
  }

  Widget _buildListaCerraduras() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: _cerraduras.length,
      itemBuilder: (context, index) {
        return _buildCerraduraCard(index);
      },
    );
  }

  Widget _buildCerraduraCard(int index) {
    final cerradura = _cerraduras[index];
    final isSelected = _cerraduraSeleccionada == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _cerraduraSeleccionada = index;
        });
        // Detener el timer cuando el usuario selecciona manualmente
        _autoScrollTimer?.cancel();
        _autoScrollTimer = null;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        width: 140,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? cerradura.color.withValues(alpha: 0.6)
                : !cerradura.cerrada
                    ? AppColors.error.withValues(alpha: 0.4)
                    : AppColors.cardBorder,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: cerradura.color.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icono con estado
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: cerradura.conectada
                          ? [cerradura.color, cerradura.gradientEnd]
                          : [
                              const Color(0xFF8B949E),
                              const Color(0xFF6E7681)
                            ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: cerradura.conectada
                            ? cerradura.color.withValues(alpha: 0.3)
                            : Colors.transparent,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    cerradura.icono,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                // Indicador de estado
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: cerradura.cerrada
                          ? const Color(0xFF7EE787)
                          : const Color(0xFFFF6B6B),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF161B22),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      cerradura.cerrada ? Icons.lock : Icons.lock_open,
                      size: 7,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Info
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          cerradura.nombre,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (!cerradura.conectada) ...[
                        const SizedBox(width: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 3, vertical: 1),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFF85149).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Off',
                            style: TextStyle(
                              fontSize: 6,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF85149),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 9,
                        color: Color(0xFF8B949E),
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          cerradura.ubicacion,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF8B949E),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetallesCerradura(Cerradura cerradura) {
    return Column(
      children: [
        // Fila de información
        Row(
          children: [
            // Batería
            Expanded(
              child: _buildDetalleItem(
                icon: _getBateriaIcon(cerradura.bateria),
                label: 'Batería',
                value: '${cerradura.bateria}%',
                color: _getBateriaColor(cerradura.bateria),
              ),
            ),
            // Auto-bloqueo
            Expanded(
              child: _buildDetalleItem(
                icon: Icons.timer,
                label: 'Auto-bloqueo',
                value: cerradura.autoBloqueo
                    ? '${cerradura.tiempoAutoBloqueo}s'
                    : 'Off',
                color: cerradura.autoBloqueo
                    ? const Color(0xFF58A6FF)
                    : const Color(0xFF8B949E),
              ),
            ),
            // Conexión
            Expanded(
              child: _buildDetalleItem(
                icon: cerradura.conectada ? Icons.wifi : Icons.wifi_off,
                label: 'Conexión',
                value: cerradura.conectada ? 'Online' : 'Offline',
                color: cerradura.conectada
                    ? const Color(0xFF7EE787)
                    : const Color(0xFFF85149),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Historial reciente de esta cerradura
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF21262D),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const HeroIcon(
                    HeroIcons.clock,
                    style: HeroIconStyle.solid,
                    size: 12,
                    color: Color(0xFF8B949E),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Actividad reciente',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B949E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._eventos
                  .where((e) => e.cerraduraId == cerradura.id)
                  .take(2)
                  .map((evento) => _buildMiniEvento(evento)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetalleItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
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
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF8B949E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniEvento(EventoCerradura evento) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: _getEventoColor(evento.tipo).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              _getEventoIcon(evento.tipo),
              size: 12,
              color: _getEventoColor(evento.tipo),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${evento.usuario} · ${_getMetodoTexto(evento.metodo)}',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFFC9D1D9),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            _formatearTiempo(evento.fecha),
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF8B949E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorial() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: _eventos.length,
      itemBuilder: (context, index) {
        final evento = _eventos[index];
        final showDate = index == 0 ||
            !_isSameDay(_eventos[index - 1].fecha, evento.fecha);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDate) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: Text(
                  _formatearFecha(evento.fecha),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B949E),
                  ),
                ),
              ),
            ],
            _buildEventoCard(evento),
          ],
        );
      },
    );
  }

  Widget _buildEventoCard(EventoCerradura evento) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: evento.tipo == TipoEvento.intentoFallido
              ? const Color(0xFFF85149).withValues(alpha: 0.4)
              : const Color(0xFF30363D),
        ),
      ),
      child: Row(
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getEventoColor(evento.tipo).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getEventoColor(evento.tipo).withValues(alpha: 0.4),
                  ),
                ),
                child: Icon(
                  _getEventoIcon(evento.tipo),
                  size: 18,
                  color: _getEventoColor(evento.tipo),
                ),
              ),
            ],
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
                      evento.cerraduraNombre,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color:
                            _getEventoColor(evento.tipo).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getEventoTexto(evento.tipo),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getEventoColor(evento.tipo),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      _getMetodoIcon(evento.metodo),
                      size: 12,
                      color: const Color(0xFF8B949E),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getMetodoTexto(evento.metodo),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B949E),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const HeroIcon(
                      HeroIcons.user,
                      style: HeroIconStyle.solid,
                      size: 12,
                      color: Color(0xFF8B949E),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      evento.usuario,
                      style: TextStyle(
                        fontSize: 12,
                        color: evento.usuario == 'Desconocido'
                            ? const Color(0xFFF85149)
                            : const Color(0xFF8B949E),
                        fontWeight: evento.usuario == 'Desconocido'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Hora
          Text(
            _formatearHora(evento.fecha),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFFC9D1D9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsuarios() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: _usuarios.length,
      itemBuilder: (context, index) {
        return _buildUsuarioCard(_usuarios[index]);
      },
    );
  }

  Widget _buildUsuarioCard(UsuarioAutorizado usuario) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [usuario.color, usuario.color.withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    usuario.avatar,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
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
                          usuario.nombre,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: usuario.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            usuario.rol,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: usuario.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      usuario.email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B949E),
                      ),
                    ),
                  ],
                ),
              ),

              // Cantidad de accesos
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF21262D),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.vpn_key,
                      size: 14,
                      color: Color(0xFF8B949E),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${usuario.accesos.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Métodos de acceso
          Row(
            children: [
              const Text(
                'Métodos:',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8B949E),
                ),
              ),
              const SizedBox(width: 8),
              ...usuario.metodos.map((metodo) => Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF21262D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getMetodoIcon(metodo),
                          size: 12,
                          color: const Color(0xFFC9D1D9),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getMetodoTexto(metodo),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFFC9D1D9),
                          ),
                        ),
                      ],
                    ),
                  )),
              const Spacer(),
              if (usuario.codigoTemporal) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.timer,
                        size: 12,
                        color: Color(0xFFFFD700),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Expira: ${_formatearFechaCorta(usuario.expiraCodigo!)}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFFD700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 12),

          // Cerraduras con acceso
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: usuario.accesos.map((cerraduraId) {
              final cerradura = _cerraduras.firstWhere(
                (c) => c.id == cerraduraId,
                orElse: () => _cerraduras.first,
              );
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: cerradura.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: cerradura.color.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      cerradura.icono,
                      size: 12,
                      color: cerradura.color,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      cerradura.nombre,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: cerradura.color,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Helpers
  String _formatearTiempo(DateTime fecha) {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fecha);

    if (diferencia.inMinutes < 1) {
      return 'Ahora';
    } else if (diferencia.inMinutes < 60) {
      return 'Hace ${diferencia.inMinutes}m';
    } else if (diferencia.inHours < 24) {
      return 'Hace ${diferencia.inHours}h';
    } else if (diferencia.inDays < 7) {
      return 'Hace ${diferencia.inDays}d';
    } else {
      return '${fecha.day}/${fecha.month}';
    }
  }

  String _formatearHora(DateTime fecha) {
    return '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }

  String _formatearFecha(DateTime fecha) {
    final ahora = DateTime.now();
    if (_isSameDay(fecha, ahora)) {
      return 'Hoy';
    } else if (_isSameDay(fecha, ahora.subtract(const Duration(days: 1)))) {
      return 'Ayer';
    } else {
      const meses = [
        'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
        'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
      ];
      return '${fecha.day} ${meses[fecha.month - 1]}';
    }
  }

  String _formatearFechaCorta(DateTime fecha) {
    return '${fecha.day}/${fecha.month}';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  IconData _getBateriaIcon(int bateria) {
    if (bateria > 80) return Icons.battery_full;
    if (bateria > 50) return Icons.battery_5_bar;
    if (bateria > 20) return Icons.battery_3_bar;
    return Icons.battery_alert;
  }

  Color _getBateriaColor(int bateria) {
    if (bateria > 50) return const Color(0xFF7EE787);
    if (bateria > 20) return const Color(0xFFFFD700);
    return const Color(0xFFF85149);
  }

  Color _getEventoColor(TipoEvento tipo) {
    switch (tipo) {
      case TipoEvento.bloqueada:
        return const Color(0xFF7EE787);
      case TipoEvento.desbloqueada:
        return const Color(0xFF58A6FF);
      case TipoEvento.intentoFallido:
        return const Color(0xFFF85149);
      case TipoEvento.bateriaBaja:
        return const Color(0xFFFFD700);
    }
  }

  IconData _getEventoIcon(TipoEvento tipo) {
    switch (tipo) {
      case TipoEvento.bloqueada:
        return Icons.lock;
      case TipoEvento.desbloqueada:
        return Icons.lock_open;
      case TipoEvento.intentoFallido:
        return Icons.warning;
      case TipoEvento.bateriaBaja:
        return Icons.battery_alert;
    }
  }

  String _getEventoTexto(TipoEvento tipo) {
    switch (tipo) {
      case TipoEvento.bloqueada:
        return 'Bloqueada';
      case TipoEvento.desbloqueada:
        return 'Desbloqueada';
      case TipoEvento.intentoFallido:
        return 'Intento fallido';
      case TipoEvento.bateriaBaja:
        return 'Batería baja';
    }
  }

  IconData _getMetodoIcon(MetodoAcceso metodo) {
    switch (metodo) {
      case MetodoAcceso.app:
        return Icons.phone_android;
      case MetodoAcceso.huella:
        return Icons.fingerprint;
      case MetodoAcceso.codigo:
        return Icons.dialpad;
      case MetodoAcceso.llave:
        return Icons.vpn_key;
      case MetodoAcceso.autoBloqueo:
        return Icons.timer;
      case MetodoAcceso.sistema:
        return Icons.settings;
    }
  }

  String _getMetodoTexto(MetodoAcceso metodo) {
    switch (metodo) {
      case MetodoAcceso.app:
        return 'App';
      case MetodoAcceso.huella:
        return 'Huella';
      case MetodoAcceso.codigo:
        return 'Código';
      case MetodoAcceso.llave:
        return 'Llave';
      case MetodoAcceso.autoBloqueo:
        return 'Auto';
      case MetodoAcceso.sistema:
        return 'Sistema';
    }
  }

  Widget _buildKpiCard() {
    final cerradura = _cerraduras[_cerraduraSeleccionada];
    final tieneAlertas = !cerradura.cerrada || cerradura.bateria < 20 || !cerradura.conectada;

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
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: tieneAlertas
                ? AppColors.warning.withValues(alpha: 0.4)
                : cerradura.color.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: (tieneAlertas ? AppColors.warning : cerradura.color).withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Nombre de la cerradura arriba y centrado
            Text(
              cerradura.nombre,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 15),
            
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
                      colors: cerradura.conectada
                          ? [cerradura.color, cerradura.gradientEnd]
                          : [
                              const Color(0xFF8B949E),
                              const Color(0xFF6E7681)
                            ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: cerradura.conectada
                            ? cerradura.color.withValues(alpha: 0.4)
                            : Colors.transparent,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    cerradura.icono,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Estado y estadísticas
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          cerradura.cerrada ? Icons.lock : Icons.lock_open,
                          size: 14,
                          color: cerradura.cerrada
                              ? const Color(0xFF7EE787)
                              : const Color(0xFFFF6B6B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          cerradura.cerrada ? 'Cerrada' : 'Abierta',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: cerradura.cerrada
                                ? const Color(0xFF7EE787)
                                : const Color(0xFFFF6B6B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.battery_std,
                          size: 12,
                          color: cerradura.bateria < 20
                              ? const Color(0xFFFFD700)
                              : const Color(0xFF8B949E),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${cerradura.bateria}%',
                          style: TextStyle(
                            fontSize: 11,
                            color: cerradura.bateria < 20
                                ? const Color(0xFFFFD700)
                                : const Color(0xFF8B949E),
                          ),
                        ),
                      ],
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

  Widget _buildResumenGeneral() {
    final totalCerraduras = _cerraduras.length;
    final cerradurasCerradas = _cerradurasCerradas;
    final cerradurasAbiertas = _cerradurasAbiertas;
    final alertasBateria = _alertasBateria;
    final porcentajeOperativo = totalCerraduras > 0 
        ? ((totalCerraduras - _desconectadas) / totalCerraduras * 100).round() 
        : 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.cardBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.dashboard,
                  size: 14,
                  color: AppColors.info,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Resumen General',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _buildMetricaResumen(
                  icon: Icons.lock,
                  valor: '$totalCerraduras',
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
                  icon: Icons.lock,
                  valor: '$cerradurasCerradas',
                  label: 'Cerradas',
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
                  icon: Icons.lock_open,
                  valor: '$cerradurasAbiertas',
                  label: 'Abiertas',
                  color: const Color(0xFFFF6B6B),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: const Color(0xFF30363D),
              ),
              Expanded(
                child: _buildMetricaResumen(
                  icon: Icons.battery_alert,
                  valor: '$alertasBateria',
                  label: 'Batería',
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
                  valor: '$porcentajeOperativo%',
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
    final cerradurasAbiertas = _cerraduras.where((c) => !c.cerrada).toList();
    final bateriaBaja = _cerraduras.where((c) => c.bateria < 20).toList();
    final desconectadas = _cerraduras.where((c) => !c.conectada).toList();
    final totalAlertas = cerradurasAbiertas.length + bateriaBaja.length + desconectadas.length;

    return AnimatedBuilder(
      animation: _alertBlinkAnimation,
      builder: (context, child) {
        final opacity = totalAlertas > 0 ? _alertBlinkAnimation.value : 1.0;
        return Opacity(
          opacity: opacity,
          child: Container(
            height: 150,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: totalAlertas > 0
                    ? AppColors.error.withValues(alpha: 0.8)
                    : AppColors.cardBorder,
                width: totalAlertas > 0 ? 2 : 1,
              ),
              boxShadow: totalAlertas > 0
                  ? [
                      BoxShadow(
                        color: AppColors.error.withValues(alpha: 0.3 * opacity),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título arriba y centrado
                Text(
                  totalAlertas == 1 ? 'Alerta' : 'Alertas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
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
                      '$totalAlertas',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF85149),
                      ),
                    ),
                    if (totalAlertas > 0) ...[
                      const SizedBox(width: 12),
                      // Lista compacta de alertas
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (cerradurasAbiertas.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 3,
                                      height: 3,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFF6B6B),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        '${cerradurasAbiertas.length} abierta${cerradurasAbiertas.length > 1 ? 's' : ''}',
                                        style: const TextStyle(
                                          fontSize: 8,
                                          color: Color(0xFFFF6B6B),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (bateriaBaja.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 3,
                                      height: 3,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFFD700),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        '${bateriaBaja.length} batería baja',
                                        style: const TextStyle(
                                          fontSize: 8,
                                          color: Color(0xFFFFD700),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (desconectadas.isNotEmpty)
                              Padding(
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
                                        '${desconectadas.length} offline',
                                        style: const TextStyle(
                                          fontSize: 8,
                                          color: Color(0xFFF85149),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
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

  // Bottom Navigation Bar
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
}

// Enums
enum TipoEvento { bloqueada, desbloqueada, intentoFallido, bateriaBaja }

enum MetodoAcceso { app, huella, codigo, llave, autoBloqueo, sistema }

// Modelos de datos
class Cerradura {
  final String id;
  final String nombre;
  final String ubicacion;
  final IconData icono;
  final Color color;
  final Color gradientEnd;
  bool cerrada;
  int bateria;
  bool conectada;
  bool autoBloqueo;
  int tiempoAutoBloqueo;
  DateTime ultimaActividad;

  Cerradura({
    required this.id,
    required this.nombre,
    required this.ubicacion,
    required this.icono,
    required this.color,
    required this.gradientEnd,
    required this.cerrada,
    required this.bateria,
    required this.conectada,
    required this.autoBloqueo,
    required this.tiempoAutoBloqueo,
    required this.ultimaActividad,
  });
}

class EventoCerradura {
  final String cerraduraId;
  final String cerraduraNombre;
  final TipoEvento tipo;
  final MetodoAcceso metodo;
  final String usuario;
  final DateTime fecha;

  EventoCerradura({
    required this.cerraduraId,
    required this.cerraduraNombre,
    required this.tipo,
    required this.metodo,
    required this.usuario,
    required this.fecha,
  });
}

class UsuarioAutorizado {
  final String nombre;
  final String email;
  final String avatar;
  final String rol;
  final Color color;
  final List<String> accesos;
  final List<MetodoAcceso> metodos;
  final bool codigoTemporal;
  final DateTime? expiraCodigo;

  UsuarioAutorizado({
    required this.nombre,
    required this.email,
    required this.avatar,
    required this.rol,
    required this.color,
    required this.accesos,
    required this.metodos,
    this.codigoTemporal = false,
    this.expiraCodigo,
  });
}

