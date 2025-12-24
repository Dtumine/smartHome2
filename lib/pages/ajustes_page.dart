import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import '../theme/app_colors.dart';

class AjustesPage extends StatefulWidget {
  const AjustesPage({super.key});

  @override
  State<AjustesPage> createState() => _AjustesPageState();
}

class _AjustesPageState extends State<AjustesPage> {
  int _selectedNavIndex = 3; // Ajustes está seleccionado

  // Estado de las configuraciones
  bool _notificacionesAlertas = true;
  bool _notificacionesDispositivos = true;
  bool _notificacionesSeguridad = true;
  bool _notificacionesPush = true;
  bool _autenticacionBiometrica = true;
  bool _bloqueoAutomatico = false;
  bool _sincronizacionNube = true;
  bool _modoOscuro = true;
  String _idiomaSeleccionado = 'Español';
  String _temaSeleccionado = 'Automático';

  // Datos del usuario
  final String _nombreUsuario = 'Juan Pérez';
  final String _emailUsuario = 'juan.perez@email.com';
  final String _avatarInicial = 'JP';

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
                        'Ajustes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Lista de ajustes
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // Perfil de usuario
                    _buildPerfilCard(),
                    const SizedBox(height: 20),

                    // Notificaciones
                    _buildSeccionTitulo('Notificaciones', Icons.notifications, const Color(0xFF58A6FF)),
                    const SizedBox(height: 12),
                    _buildSwitchItem(
                      icon: Icons.warning_amber_rounded,
                      title: 'Alertas',
                      subtitle: 'Notificaciones de alertas del sistema',
                      value: _notificacionesAlertas,
                      onChanged: (value) => setState(() => _notificacionesAlertas = value),
                    ),
                    _buildSwitchItem(
                      icon: Icons.devices,
                      title: 'Dispositivos',
                      subtitle: 'Cambios de estado en dispositivos',
                      value: _notificacionesDispositivos,
                      onChanged: (value) => setState(() => _notificacionesDispositivos = value),
                    ),
                    _buildSwitchItem(
                      icon: Icons.security,
                      title: 'Seguridad',
                      subtitle: 'Eventos de seguridad importantes',
                      value: _notificacionesSeguridad,
                      onChanged: (value) => setState(() => _notificacionesSeguridad = value),
                    ),
                    _buildSwitchItem(
                      icon: Icons.phone_android,
                      title: 'Notificaciones Push',
                      subtitle: 'Recibir notificaciones en el dispositivo',
                      value: _notificacionesPush,
                      onChanged: (value) => setState(() => _notificacionesPush = value),
                    ),
                    const SizedBox(height: 20),

                    // Seguridad
                    _buildSeccionTitulo('Seguridad', Icons.security, const Color(0xFF7EE787)),
                    const SizedBox(height: 12),
                    _buildSwitchItem(
                      icon: Icons.fingerprint,
                      title: 'Autenticación Biométrica',
                      subtitle: 'Usar huella dactilar o Face ID',
                      value: _autenticacionBiometrica,
                      onChanged: (value) => setState(() => _autenticacionBiometrica = value),
                    ),
                    _buildSwitchItem(
                      icon: Icons.lock_clock,
                      title: 'Bloqueo Automático',
                      subtitle: 'Bloquear app después de inactividad',
                      value: _bloqueoAutomatico,
                      onChanged: (value) => setState(() => _bloqueoAutomatico = value),
                    ),
                    _buildActionItem(
                      icon: Icons.lock_reset,
                      title: 'Cambiar Contraseña',
                      subtitle: 'Actualizar tu contraseña',
                      onTap: () => _mostrarDialogoCambioContrasena(),
                    ),
                    const SizedBox(height: 20),

                    // Dispositivos
                    _buildSeccionTitulo('Dispositivos', Icons.devices, const Color(0xFFA78BFA)),
                    const SizedBox(height: 12),
                    _buildActionItem(
                      icon: Icons.add_circle_outline,
                      title: 'Agregar Dispositivo',
                      subtitle: 'Conectar un nuevo dispositivo',
                      onTap: () => _mostrarDialogoAgregarDispositivo(),
                    ),
                    _buildActionItem(
                      icon: Icons.sync,
                      title: 'Sincronizar Dispositivos',
                      subtitle: 'Actualizar estado de todos los dispositivos',
                      onTap: () => _mostrarSnackbar('Sincronizando dispositivos...'),
                    ),
                    _buildActionItem(
                      icon: Icons.settings_backup_restore,
                      title: 'Restaurar Configuración',
                      subtitle: 'Volver a la configuración por defecto',
                      onTap: () => _mostrarDialogoRestaurar(),
                    ),
                    const SizedBox(height: 20),

                    // Aplicación
                    _buildSeccionTitulo('Aplicación', Icons.settings, const Color(0xFFFFD700)),
                    const SizedBox(height: 12),
                    _buildSelectorItem(
                      icon: Icons.language,
                      title: 'Idioma',
                      subtitle: _idiomaSeleccionado,
                      onTap: () => _mostrarSelectorIdioma(),
                    ),
                    _buildSelectorItem(
                      icon: Icons.palette,
                      title: 'Tema',
                      subtitle: _temaSeleccionado,
                      onTap: () => _mostrarSelectorTema(),
                    ),
                    _buildSwitchItem(
                      icon: Icons.cloud_sync,
                      title: 'Sincronización en la Nube',
                      subtitle: 'Guardar datos en la nube',
                      value: _sincronizacionNube,
                      onChanged: (value) => setState(() => _sincronizacionNube = value),
                    ),
                    _buildActionItem(
                      icon: Icons.info_outline,
                      title: 'Acerca de',
                      subtitle: 'Versión 1.0.0',
                      onTap: () => _mostrarDialogoAcercaDe(),
                    ),
                    const SizedBox(height: 20),

                    // Privacidad y Datos
                    _buildSeccionTitulo('Privacidad y Datos', Icons.privacy_tip, const Color(0xFFFF6B6B)),
                    const SizedBox(height: 12),
                    _buildActionItem(
                      icon: Icons.download,
                      title: 'Exportar Datos',
                      subtitle: 'Descargar tus datos',
                      onTap: () => _mostrarSnackbar('Exportando datos...'),
                    ),
                    _buildActionItem(
                      icon: Icons.delete_outline,
                      title: 'Eliminar Datos',
                      subtitle: 'Borrar todos los datos locales',
                      onTap: () => _mostrarDialogoEliminarDatos(),
                      isDestructive: true,
                    ),
                    const SizedBox(height: 20),

                    // Ayuda y Soporte
                    _buildSeccionTitulo('Ayuda y Soporte', Icons.help_outline, const Color(0xFF00CED1)),
                    const SizedBox(height: 12),
                    _buildActionItem(
                      icon: Icons.help_center,
                      title: 'Centro de Ayuda',
                      subtitle: 'Preguntas frecuentes y guías',
                      onTap: () => _mostrarSnackbar('Abriendo centro de ayuda...'),
                    ),
                    _buildActionItem(
                      icon: Icons.feedback,
                      title: 'Enviar Comentarios',
                      subtitle: 'Comparte tu opinión',
                      onTap: () => _mostrarSnackbar('Abriendo formulario de comentarios...'),
                    ),
                    _buildActionItem(
                      icon: Icons.bug_report,
                      title: 'Reportar Problema',
                      subtitle: 'Notificar un error o bug',
                      onTap: () => _mostrarSnackbar('Abriendo formulario de reporte...'),
                    ),
                    const SizedBox(height: 20),

                    // Cerrar Sesión
                    _buildCerrarSesionButton(),
                    const SizedBox(height: 20),
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

  Widget _buildPerfilCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF58A6FF),
                  Color(0xFF0077B6),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF58A6FF).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _avatarInicial,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Información
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _nombreUsuario,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _emailUsuario,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Botón editar
          GestureDetector(
            onTap: () => _mostrarDialogoEditarPerfil(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundAlt,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.cardBorder,
                ),
              ),
              child: const Icon(
                Icons.edit,
                size: 18,
                color: Color(0xFF58A6FF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionTitulo(String titulo, IconData icono, Color color) {
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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            child: Icon(
              icon,
              size: 20,
              color: const Color(0xFF58A6FF),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF58A6FF),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? const Color(0xFFFF6B6B) : const Color(0xFF58A6FF);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? color : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
                color: const Color(0xFFFFD700).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.language,
                size: 20,
                color: Color(0xFFFFD700),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCerrarSesionButton() {
    return GestureDetector(
      onTap: () => _mostrarDialogoCerrarSesion(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6B6B).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout,
              color: Color(0xFFFF6B6B),
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Cerrar Sesión',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6B6B),
              ),
            ),
          ],
        ),
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
          context.push('/alertas');
        } else if (index == 3) {
          // Ya estamos en ajustes
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

  // Diálogos y acciones
  void _mostrarDialogoEditarPerfil() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Editar Perfil',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Funcionalidad de edición de perfil próximamente disponible.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoCambioContrasena() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Cambiar Contraseña',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Funcionalidad de cambio de contraseña próximamente disponible.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoAgregarDispositivo() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Agregar Dispositivo',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Funcionalidad de agregar dispositivo próximamente disponible.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoRestaurar() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Restaurar Configuración',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Estás seguro de que deseas restaurar la configuración por defecto? Esta acción no se puede deshacer.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (mounted) {
                _mostrarSnackbar('Configuración restaurada');
              }
            },
            child: const Text(
              'Restaurar',
              style: TextStyle(color: Color(0xFFFF6B6B)),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoEliminarDatos() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Eliminar Datos',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Estás seguro de que deseas eliminar todos los datos locales? Esta acción no se puede deshacer.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (mounted) {
                _mostrarSnackbar('Datos eliminados');
              }
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

  void _mostrarDialogoCerrarSesion() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Cerrar Sesión',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Estás seguro de que deseas cerrar sesión?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (mounted) {
                _mostrarSnackbar('Sesión cerrada');
              }
            },
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Color(0xFFFF6B6B)),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoAcercaDe() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Acerca de',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart Home App',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Versión 1.0.0',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aplicación para el control inteligente de tu hogar.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _mostrarSelectorIdioma() {
    if (!mounted) return;
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
              'Seleccionar Idioma',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildOpcionIdioma('Español', 'Español', sheetContext),
            _buildOpcionIdioma('English', 'Inglés', sheetContext),
            _buildOpcionIdioma('Français', 'Francés', sheetContext),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildOpcionIdioma(String valor, String label, BuildContext sheetContext) {
    final isSelected = _idiomaSeleccionado == valor;
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFF58A6FF) : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: Color(0xFF58A6FF))
          : null,
      onTap: () {
        if (!mounted) return;
        setState(() {
          _idiomaSeleccionado = valor;
        });
        Navigator.of(sheetContext).pop();
        _mostrarSnackbar('Idioma cambiado a $label');
      },
    );
  }

  void _mostrarSelectorTema() {
    if (!mounted) return;
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
              'Seleccionar Tema',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildOpcionTema('Automático', 'Automático', sheetContext),
            _buildOpcionTema('Oscuro', 'Oscuro', sheetContext),
            _buildOpcionTema('Claro', 'Claro', sheetContext),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildOpcionTema(String valor, String label, BuildContext sheetContext) {
    final isSelected = _temaSeleccionado == valor;
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFF58A6FF) : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: Color(0xFF58A6FF))
          : null,
      onTap: () {
        if (!mounted) return;
        setState(() {
          _temaSeleccionado = valor;
        });
        Navigator.of(sheetContext).pop();
        _mostrarSnackbar('Tema cambiado a $label');
      },
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

