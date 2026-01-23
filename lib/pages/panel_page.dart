import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../data/smart_home_data.dart';
import '../models/smart_home_option.dart';
import '../services/panel_service.dart';
import '../theme/app_colors.dart';

class PanelPage extends StatefulWidget {
  const PanelPage({super.key});

  @override
  State<PanelPage> createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  int _selectedNavIndex = 1; // Panel está seleccionado
  bool _modoEdicion = false;
  
  final PanelService _panelService = PanelService();
  
  // Lista de iconos activos en el panel (se obtiene del servicio)
  List<SmartHomeOption> get _iconosActivos => _panelService.iconosActivos;
  
  // Lista de todas las opciones disponibles (incluyendo las que no están en el panel)
  final List<SmartHomeOption> _todasLasOpciones = [
    ...smartHomeOptions,
    // Opciones adicionales que se pueden agregar
    SmartHomeOption(
      title: 'Cortinas',
      subtitle: '6 dispositivos',
      heroIcon: HeroIcons.rectangleStack,
      color: const Color(0xFF9370DB),
      gradientEnd: const Color(0xFF6A5ACD),
      route: '/cortinas',
    ),
    SmartHomeOption(
      title: 'Riego',
      subtitle: '3 zonas',
      materialIcon: Symbols.water_drop,
      color: const Color(0xFF00CED1),
      gradientEnd: const Color(0xFF008B8B),
      route: '/riego',
    ),
    SmartHomeOption(
      title: 'Ventilación',
      subtitle: '5 ventiladores',
      materialIcon: Symbols.air,
      color: const Color(0xFF87CEEB),
      gradientEnd: const Color(0xFF4682B4),
      route: '/ventilacion',
    ),
    SmartHomeOption(
      title: 'Alarmas',
      subtitle: 'Sistema activo',
      heroIcon: HeroIcons.shieldCheck,
      color: const Color(0xFFFF6B6B),
      gradientEnd: const Color(0xFFDC143C),
      route: '/alarmas',
    ),
  ];

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
                    const Expanded(
                      child: Text(
                        'Panel de Control',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Botón de edición
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _modoEdicion = !_modoEdicion;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: _modoEdicion
                              ? const Color(0xFF58A6FF).withValues(alpha: 0.2)
                              : AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _modoEdicion
                                ? const Color(0xFF58A6FF)
                                : AppColors.cardBorder,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _modoEdicion ? Icons.check : Icons.edit,
                              size: 16,
                              color: _modoEdicion
                                  ? const Color(0xFF58A6FF)
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _modoEdicion ? 'Listo' : 'Editar',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _modoEdicion
                                    ? const Color(0xFF58A6FF)
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Contenido
              Expanded(
                child: _modoEdicion ? _buildVistaEdicion() : _buildVistaNormal(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildVistaNormal() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Información
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.cardBorder,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF58A6FF).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const HeroIcon(
                    HeroIcons.squares2x2,
                    style: HeroIconStyle.solid,
                    color: Color(0xFF58A6FF),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Iconos en el Panel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_iconosActivos.length} módulos activos',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7EE787).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_iconosActivos.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7EE787),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Título de sección
          const Text(
            'Panel Principal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          // Grid de iconos actuales
          _buildGridIconos(_iconosActivos, esVistaEdicion: false),

          const SizedBox(height: 24),

          // Botón para agregar más iconos
          GestureDetector(
            onTap: () {
              _mostrarDialogoAgregarIconos();
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF58A6FF).withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF58A6FF).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Color(0xFF58A6FF),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Agregar Módulos al Panel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF58A6FF),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildVistaEdicion() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instrucciones
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFFFD700).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFFFFD700),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Mantén presionado un icono para reordenarlo. Toca el X para eliminarlo.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Grid de iconos con opción de eliminar
          _buildGridIconos(_iconosActivos, esVistaEdicion: true),

          const SizedBox(height: 24),

          // Botón para agregar más iconos
          GestureDetector(
            onTap: () {
              _mostrarDialogoAgregarIconos();
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF58A6FF).withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF58A6FF).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Color(0xFF58A6FF),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Agregar Módulos al Panel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF58A6FF),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildGridIconos(List<SmartHomeOption> iconos, {required bool esVistaEdicion}) {
    return Center(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: iconos.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          return _buildIconoCard(option, index, esVistaEdicion);
        }).toList(),
      ),
    );
  }

  Widget _buildIconoCard(SmartHomeOption option, int index, bool esVistaEdicion) {
    return GestureDetector(
      onLongPress: esVistaEdicion ? () {
        _mostrarDialogoReordenar(index);
      } : null,
      child: Stack(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.cardBorder,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        option.color,
                        option.gradientEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: option.color.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: option.materialIcon != null
                      ? Icon(
                          option.materialIcon,
                          color: Colors.white,
                          size: 20,
                        )
                      : HeroIcon(
                          option.heroIcon!,
                          style: HeroIconStyle.solid,
                          color: Colors.white,
                          size: 20,
                        ),
                ),
                const SizedBox(height: 8),
                Text(
                  option.title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Botón eliminar (disponible en ambas vistas)
          Positioned(
            top: -4,
            right: -4,
            child: GestureDetector(
              onTap: () {
                if (esVistaEdicion) {
                  // En modo edición, eliminar directamente
                  _eliminarIcono(index);
                } else {
                  // En vista normal, mostrar confirmación
                  _mostrarConfirmacionEliminar(index, option.title);
                }
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: esVistaEdicion 
                      ? const Color(0xFFFF6B6B)
                      : const Color(0xFFFF6B6B).withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.cardBackground,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.close,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _eliminarIcono(int index) {
    setState(() {
      _panelService.eliminarIcono(index);
    });
    _mostrarSnackbar('Módulo eliminado del panel');
  }

  void _mostrarConfirmacionEliminar(int index, String nombreModulo) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Eliminar Módulo',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          '¿Estás seguro de que quieres eliminar "$nombreModulo" del panel?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _eliminarIcono(index);
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Color(0xFFFF6B6B)),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoReordenar(int index) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Reordenar Módulo',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Selecciona la nueva posición para "${_iconosActivos[index].title}"',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _mostrarSelectorPosicion(index);
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  void _mostrarSelectorPosicion(int indexActual) {
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
              'Seleccionar Nueva Posición',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(_iconosActivos.length, (nuevoIndex) {
              if (nuevoIndex == indexActual) {
                return const SizedBox.shrink();
              }
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _iconosActivos[nuevoIndex].color,
                        _iconosActivos[nuevoIndex].gradientEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _iconosActivos[nuevoIndex].materialIcon != null
                        ? Icon(
                            _iconosActivos[nuevoIndex].materialIcon,
                            color: Colors.white,
                            size: 18,
                          )
                        : HeroIcon(
                            _iconosActivos[nuevoIndex].heroIcon!,
                            style: HeroIconStyle.solid,
                            color: Colors.white,
                            size: 18,
                          ),
                  ),
                ),
                title: Text(
                  _iconosActivos[nuevoIndex].title,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Mover aquí',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward,
                  color: Color(0xFF58A6FF),
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _reordenarIcono(indexActual, nuevoIndex);
                },
              );
            }),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _reordenarIcono(int indexActual, int nuevoIndex) {
    setState(() {
      _panelService.reordenarIconos(indexActual, nuevoIndex);
    });
    _mostrarSnackbar('Módulo reordenado');
  }

  void _mostrarDialogoAgregarIconos() {
    final iconosDisponibles = _todasLasOpciones
        .where((opcion) => !_iconosActivos.any((activo) => activo.route == opcion.route))
        .toList();

    if (iconosDisponibles.isEmpty) {
      _mostrarSnackbar('No hay más módulos disponibles para agregar');
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Agregar Módulos al Panel',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: iconosDisponibles.length,
                itemBuilder: (context, index) {
                  final option = iconosDisponibles[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackgroundAlt,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.cardBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                option.color,
                                option.gradientEnd,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: option.materialIcon != null
                              ? Icon(
                                  option.materialIcon,
                                  color: Colors.white,
                                  size: 24,
                                )
                              : HeroIcon(
                                  option.heroIcon!,
                                  style: HeroIconStyle.solid,
                                  color: Colors.white,
                                  size: 24,
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                option.subtitle,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(sheetContext).pop();
                            _agregarIcono(option);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF58A6FF).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Color(0xFF58A6FF),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _agregarIcono(SmartHomeOption option) {
    setState(() {
      _panelService.agregarIcono(option);
    });
    _mostrarSnackbar('${option.title} agregado al panel');
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
          // Ya estamos en panel
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

