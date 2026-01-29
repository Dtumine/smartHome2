import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme/app_colors.dart';
import '../services/dispositivos_service.dart';

class DispositivosActivosPage extends StatefulWidget {
  const DispositivosActivosPage({super.key});

  @override
  State<DispositivosActivosPage> createState() => _DispositivosActivosPageState();
}

class _DispositivosActivosPageState extends State<DispositivosActivosPage> {
  final _dispositivosService = DispositivoService();
  
  // Lista de dispositivos activos
  List<Dispositivo> _dispositivos = [
    Dispositivo(
      nombre: 'Luz Sala Principal',
      tipo: TipoDispositivo.luz,
      ubicacion: 'Sala Principal',
      activo: true,
      icono: HeroIcons.lightBulb,
      color: const Color(0xFFFFD700),
    ),
    Dispositivo(
      nombre: 'Luz Cocina',
      tipo: TipoDispositivo.luz,
      ubicacion: 'Cocina',
      activo: true,
      icono: HeroIcons.lightBulb,
      color: const Color(0xFFFFD700),
    ),
    Dispositivo(
      nombre: 'Cámara Entrada Principal',
      tipo: TipoDispositivo.camara,
      ubicacion: 'Exterior',
      activo: true,
      icono: HeroIcons.videoCamera,
      color: const Color(0xFF00CED1),
    ),
    Dispositivo(
      nombre: 'Cámara Jardín Trasero',
      tipo: TipoDispositivo.camara,
      ubicacion: 'Exterior',
      activo: true,
      icono: HeroIcons.videoCamera,
      color: const Color(0xFF00CED1),
    ),
    Dispositivo(
      nombre: 'Sensor Temperatura Sala',
      tipo: TipoDispositivo.sensor,
      ubicacion: 'Sala Principal',
      activo: true,
      icono: HeroIcons.signal,
      color: const Color(0xFF7EE787),
    ),
    Dispositivo(
      nombre: 'Sensor Humedad Cocina',
      tipo: TipoDispositivo.sensor,
      ubicacion: 'Cocina',
      activo: true,
      icono: HeroIcons.signal,
      color: const Color(0xFF7EE787),
    ),
    Dispositivo(
      nombre: 'Termostato Principal',
      tipo: TipoDispositivo.termostato,
      ubicacion: 'Sala Principal',
      activo: true,
      materialIcon: Symbols.thermostat,
      color: const Color(0xFFFF6B6B),
    ),
    Dispositivo(
      nombre: 'Cerradura Entrada',
      tipo: TipoDispositivo.cerradura,
      ubicacion: 'Entrada Principal',
      activo: true,
      icono: HeroIcons.lockClosed,
      color: const Color(0xFFA78BFA),
    ),
    Dispositivo(
      nombre: 'Cerradura Garage',
      tipo: TipoDispositivo.cerradura,
      ubicacion: 'Garage',
      activo: true,
      icono: HeroIcons.lockClosed,
      color: const Color(0xFFA78BFA),
    ),
    Dispositivo(
      nombre: 'Zona Riego Jardín Frontal',
      tipo: TipoDispositivo.riego,
      ubicacion: 'Jardín',
      activo: true,
      materialIcon: Symbols.water_drop,
      color: const Color(0xFF00CED1),
    ),
    Dispositivo(
      nombre: 'Ventilador Sala Principal',
      tipo: TipoDispositivo.ventilador,
      ubicacion: 'Sala Principal',
      activo: true,
      materialIcon: Symbols.air,
      color: const Color(0xFF7EE787),
    ),
    Dispositivo(
      nombre: 'Ventilador Dormitorio 1',
      tipo: TipoDispositivo.ventilador,
      ubicacion: 'Dormitorio 1',
      activo: true,
      materialIcon: Symbols.air,
      color: const Color(0xFF7EE787),
    ),
    Dispositivo(
      nombre: 'Cortina Sala Principal',
      tipo: TipoDispositivo.cortina,
      ubicacion: 'Sala Principal',
      activo: true,
      materialIcon: Symbols.blinds,
      color: const Color(0xFF58A6FF),
    ),
    Dispositivo(
      nombre: 'Cortina Dormitorio',
      tipo: TipoDispositivo.cortina,
      ubicacion: 'Dormitorio 1',
      activo: true,
      materialIcon: Symbols.blinds,
      color: const Color(0xFF58A6FF),
    ),
    Dispositivo(
      nombre: 'Alarma Zona Entrada',
      tipo: TipoDispositivo.alarma,
      ubicacion: 'Entrada Principal',
      activo: true,
      icono: HeroIcons.bell,
      color: const Color(0xFFF85149),
    ),
    Dispositivo(
      nombre: 'Alarma Zona Cocina',
      tipo: TipoDispositivo.alarma,
      ubicacion: 'Cocina',
      activo: true,
      icono: HeroIcons.bell,
      color: const Color(0xFFF85149),
    ),
    Dispositivo(
      nombre: 'Luz Dormitorio 1',
      tipo: TipoDispositivo.luz,
      ubicacion: 'Dormitorio 1',
      activo: true,
      icono: HeroIcons.lightBulb,
      color: const Color(0xFFFFD700),
    ),
    Dispositivo(
      nombre: 'Luz Dormitorio 2',
      tipo: TipoDispositivo.luz,
      ubicacion: 'Dormitorio 2',
      activo: true,
      icono: HeroIcons.lightBulb,
      color: const Color(0xFFFFD700),
    ),
    Dispositivo(
      nombre: 'Sensor Movimiento Garaje',
      tipo: TipoDispositivo.sensor,
      ubicacion: 'Garage',
      activo: true,
      icono: HeroIcons.signal,
      color: const Color(0xFF7EE787),
    ),
    Dispositivo(
      nombre: 'Cámara Garage',
      tipo: TipoDispositivo.camara,
      ubicacion: 'Garage',
      activo: true,
      icono: HeroIcons.videoCamera,
      color: const Color(0xFF00CED1),
    ),
    Dispositivo(
      nombre: 'Cámara Piscina',
      tipo: TipoDispositivo.camara,
      ubicacion: 'Exterior',
      activo: true,
      icono: HeroIcons.videoCamera,
      color: const Color(0xFF00CED1),
    ),
    Dispositivo(
      nombre: 'Ventilador Cocina',
      tipo: TipoDispositivo.ventilador,
      ubicacion: 'Cocina',
      activo: true,
      materialIcon: Symbols.air,
      color: const Color(0xFF7EE787),
    ),
    Dispositivo(
      nombre: 'Zona Riego Jardín Trasero',
      tipo: TipoDispositivo.riego,
      ubicacion: 'Jardín',
      activo: true,
      materialIcon: Symbols.water_drop,
      color: const Color(0xFF00CED1),
    ),
    Dispositivo(
      nombre: 'Zona Riego Huerto',
      tipo: TipoDispositivo.riego,
      ubicacion: 'Jardín',
      activo: true,
      materialIcon: Symbols.water_drop,
      color: const Color(0xFF00CED1),
    ),
    // Luces manuales
    Dispositivo(
      nombre: 'Luz Sala',
      tipo: TipoDispositivo.luz,
      ubicacion: 'Sala',
      activo: true,
      icono: HeroIcons.lightBulb,
      color: const Color(0xFFFFD700),
    ),
    Dispositivo(
      nombre: 'Luz Dormitorio 1 (Luces)',
      tipo: TipoDispositivo.luz,
      ubicacion: 'Dormitorio 1',
      activo: true,
      icono: HeroIcons.lightBulb,
      color: const Color(0xFFFFD700),
    ),
    Dispositivo(
      nombre: 'Luz Baño 1',
      tipo: TipoDispositivo.luz,
      ubicacion: 'Baño 1',
      activo: false,
      icono: HeroIcons.lightBulb,
      color: const Color(0xFFFFD700),
    ),
    Dispositivo(
      nombre: 'Luz Garage (Luces)',
      tipo: TipoDispositivo.luz,
      ubicacion: 'Garage',
      activo: false,
      icono: HeroIcons.lightBulb,
      color: const Color(0xFFFFD700),
    ),
    Dispositivo(
      nombre: 'Luz Jardín 1',
      tipo: TipoDispositivo.luz,
      ubicacion: 'Jardín',
      activo: false,
      icono: HeroIcons.lightBulb,
      color: const Color(0xFFFFD700),
    ),
    Dispositivo(
      nombre: 'Luz Living',
      tipo: TipoDispositivo.luz,
      ubicacion: 'Living',
      activo: false,
      icono: HeroIcons.lightBulb,
      color: const Color(0xFFFFD700),
    ),
    Dispositivo(
      nombre: 'Luz Dormitorio 2 (Luces)',
      tipo: TipoDispositivo.luz,
      ubicacion: 'Dormitorio 2',
      activo: false,
      icono: HeroIcons.lightBulb,
      color: const Color(0xFFFFD700),
    ),
    Dispositivo(
      nombre: 'Luz Dormitorio 3',
      tipo: TipoDispositivo.luz,
      ubicacion: 'Dormitorio 3',
      activo: false,
      icono: HeroIcons.lightBulb,
      color: const Color(0xFFFFD700),
    ),
    Dispositivo(
      nombre: 'Luz Jardín 2',
      tipo: TipoDispositivo.luz,
      ubicacion: 'Jardín',
      activo: false,
      icono: HeroIcons.lightBulb,
      color: const Color(0xFFFFD700),
    ),
    Dispositivo(
      nombre: 'Luz Piscina',
      tipo: TipoDispositivo.luz,
      ubicacion: 'Piscina',
      activo: false,
      icono: HeroIcons.lightBulb,
      color: const Color(0xFF00BFFF),
    ),
    Dispositivo(
      nombre: 'Luz Pérgola',
      tipo: TipoDispositivo.luz,
      ubicacion: 'Pérgola',
      activo: false,
      icono: HeroIcons.lightBulb,
      color: const Color(0xFFDDA0DD),
    ),
  ];

  int get _totalDispositivos => _dispositivosService.totalDispositivos;
  int get _dispositivosActivos => _dispositivosService.dispositivosActivos;

  @override
  void initState() {
    super.initState();
    _cargarEstadosDesdeServicio();
  }

  void _cargarEstadosDesdeServicio() {
    if (mounted) {
      setState(() {
        for (var dispositivo in _dispositivos) {
          dispositivo.activo = _dispositivosService.isActivo(dispositivo.nombre);
        }
      });
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

              const SizedBox(height: 12),

              // Estadísticas
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildEstadisticas(),
              ),

              const SizedBox(height: 16),

              // Lista de dispositivos
              Expanded(
                child: _buildListaDispositivos(),
              ),
            ],
          ),
        ),
      ),
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
                  'Dispositivos Activos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '$_dispositivosActivos de $_totalDispositivos activos',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
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
              icon: Symbols.power,
              label: 'Activos',
              value: '$_dispositivosActivos',
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
              icon: Symbols.devices,
              label: 'Total',
              value: '$_totalDispositivos',
              color: AppColors.textSecondary,
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

  Widget _buildListaDispositivos() {
    final dispositivosActivos = _dispositivos.where((d) => d.activo).toList();
    
    if (dispositivosActivos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.devices_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay dispositivos activos',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    // Agrupar dispositivos por tipo
    final Map<TipoDispositivo, List<Dispositivo>> dispositivosPorTipo = {};
    for (var dispositivo in dispositivosActivos) {
      if (!dispositivosPorTipo.containsKey(dispositivo.tipo)) {
        dispositivosPorTipo[dispositivo.tipo] = [];
      }
      dispositivosPorTipo[dispositivo.tipo]!.add(dispositivo);
    }

    // Ordenar los tipos según un orden específico
    final tiposOrdenados = [
      TipoDispositivo.luz,
      TipoDispositivo.camara,
      TipoDispositivo.sensor,
      TipoDispositivo.termostato,
      TipoDispositivo.cerradura,
      TipoDispositivo.riego,
      TipoDispositivo.ventilador,
      TipoDispositivo.cortina,
      TipoDispositivo.alarma,
    ];

    // Crear lista de widgets agrupados
    final List<Widget> widgets = [];
    for (var tipo in tiposOrdenados) {
      if (dispositivosPorTipo.containsKey(tipo)) {
        final dispositivosDelTipo = dispositivosPorTipo[tipo]!;
        
        // Header de la sección
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 12),
            child: _buildSeccionHeader(tipo, dispositivosDelTipo.length),
          ),
        );
        
        // Dispositivos de esta sección
        for (var dispositivo in dispositivosDelTipo) {
          final dispositivoIndex = _dispositivos.indexOf(dispositivo);
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildDispositivoCard(dispositivo, dispositivoIndex),
            ),
          );
        }
      }
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: widgets,
    );
  }

  Widget _buildSeccionHeader(TipoDispositivo tipo, int cantidad) {
    final nombreSeccion = _getNombreSeccion(tipo);
    final iconoSeccion = _getIconoSeccion(tipo);
    final colorSeccion = _getColorSeccion(tipo);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorSeccion.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            iconoSeccion,
            color: colorSeccion,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          nombreSeccion,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: colorSeccion.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$cantidad',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colorSeccion,
            ),
          ),
        ),
      ],
    );
  }

  String _getNombreSeccion(TipoDispositivo tipo) {
    switch (tipo) {
      case TipoDispositivo.luz:
        return 'Luces';
      case TipoDispositivo.camara:
        return 'Cámaras';
      case TipoDispositivo.sensor:
        return 'Sensores';
      case TipoDispositivo.termostato:
        return 'Termostatos';
      case TipoDispositivo.cerradura:
        return 'Cerraduras';
      case TipoDispositivo.riego:
        return 'Riego';
      case TipoDispositivo.ventilador:
        return 'Ventiladores';
      case TipoDispositivo.cortina:
        return 'Cortinas';
      case TipoDispositivo.alarma:
        return 'Alarmas';
    }
  }

  IconData _getIconoSeccion(TipoDispositivo tipo) {
    switch (tipo) {
      case TipoDispositivo.luz:
        return Symbols.lightbulb;
      case TipoDispositivo.camara:
        return Symbols.videocam;
      case TipoDispositivo.sensor:
        return Symbols.sensors;
      case TipoDispositivo.termostato:
        return Symbols.thermostat;
      case TipoDispositivo.cerradura:
        return Symbols.lock;
      case TipoDispositivo.riego:
        return Symbols.water_drop;
      case TipoDispositivo.ventilador:
        return Symbols.air;
      case TipoDispositivo.cortina:
        return Symbols.blinds;
      case TipoDispositivo.alarma:
        return Symbols.notifications;
    }
  }

  Color _getColorSeccion(TipoDispositivo tipo) {
    switch (tipo) {
      case TipoDispositivo.luz:
        return const Color(0xFFFFD700);
      case TipoDispositivo.camara:
        return const Color(0xFF00CED1);
      case TipoDispositivo.sensor:
        return const Color(0xFF7EE787);
      case TipoDispositivo.termostato:
        return const Color(0xFFFF6B6B);
      case TipoDispositivo.cerradura:
        return const Color(0xFFA78BFA);
      case TipoDispositivo.riego:
        return const Color(0xFF00CED1);
      case TipoDispositivo.ventilador:
        return const Color(0xFF7EE787);
      case TipoDispositivo.cortina:
        return const Color(0xFF58A6FF);
      case TipoDispositivo.alarma:
        return const Color(0xFFF85149);
    }
  }

  Widget _buildDispositivoCard(Dispositivo dispositivo, int index) {
    final dispositivoIndex = _dispositivos.indexOf(dispositivo);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dispositivo.activo
              ? dispositivo.color.withValues(alpha: 0.3)
              : AppColors.cardBorder,
          width: dispositivo.activo ? 2 : 1,
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
                  dispositivo.color,
                  dispositivo.color.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: dispositivo.materialIcon != null
                ? Icon(
                    dispositivo.materialIcon,
                    color: Colors.white,
                    size: 20,
                  )
                : HeroIcon(
                    dispositivo.icono!,
                    style: HeroIconStyle.solid,
                    color: Colors.white,
                    size: 20,
                  ),
          ),
          const SizedBox(width: 12),
          // Información
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dispositivo.nombre,
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
                      Icons.location_on,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dispositivo.ubicacion,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: dispositivo.activo
                            ? const Color(0xFF7EE787)
                            : const Color(0xFFF85149),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dispositivo.activo ? 'Activo' : 'Inactivo',
                      style: TextStyle(
                        fontSize: 11,
                        color: dispositivo.activo
                            ? const Color(0xFF7EE787)
                            : const Color(0xFFF85149),
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
            value: dispositivo.activo,
            onChanged: (value) {
              setState(() {
                _dispositivos[dispositivoIndex].activo = value;
                // Guardar en el servicio
                _dispositivosService.cambiarEstado(dispositivo.nombre, value);
              });
              _mostrarSnackbar(
                value
                    ? '${dispositivo.nombre} activado'
                    : '${dispositivo.nombre} desactivado',
              );
            },
            activeColor: dispositivo.color,
          ),
        ],
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
enum TipoDispositivo {
  luz,
  camara,
  sensor,
  termostato,
  cerradura,
  riego,
  ventilador,
  cortina,
  alarma,
}

class Dispositivo {
  final String nombre;
  final TipoDispositivo tipo;
  final String ubicacion;
  bool activo;
  final HeroIcons? icono;
  final IconData? materialIcon;
  final Color color;

  Dispositivo({
    required this.nombre,
    required this.tipo,
    required this.ubicacion,
    required this.activo,
    this.icono,
    this.materialIcon,
    required this.color,
  });
}

