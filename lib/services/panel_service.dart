import 'package:flutter/foundation.dart';
import '../data/smart_home_data.dart';
import '../models/smart_home_option.dart';

/// Servicio singleton para gestionar la configuración del panel de control
class PanelService {
  static final PanelService _instance = PanelService._internal();
  factory PanelService() => _instance;
  PanelService._internal();

  // Lista de iconos activos en el panel (inicialmente los mismos que en home)
  List<SmartHomeOption> _iconosActivos = List.from(smartHomeOptions);
  
  // Notificador para cambios en los iconos
  final ValueNotifier<List<SmartHomeOption>> _iconosNotifier = 
      ValueNotifier<List<SmartHomeOption>>(List.from(smartHomeOptions));
  
  /// Stream de cambios en los iconos
  ValueNotifier<List<SmartHomeOption>> get iconosNotifier => _iconosNotifier;

  /// Obtiene la lista de iconos activos en el panel
  List<SmartHomeOption> get iconosActivos => List.unmodifiable(_iconosActivos);

  /// Actualiza la lista de iconos activos
  void actualizarIconos(List<SmartHomeOption> nuevosIconos) {
    _iconosActivos = List.from(nuevosIconos);
    _iconosNotifier.value = List.from(_iconosActivos);
  }

  /// Agrega un icono al panel
  void agregarIcono(SmartHomeOption icono) {
    if (!_iconosActivos.any((activo) => activo.route == icono.route)) {
      _iconosActivos.add(icono);
      _iconosNotifier.value = List.from(_iconosActivos);
    }
  }

  /// Elimina un icono del panel
  void eliminarIcono(int index) {
    if (index >= 0 && index < _iconosActivos.length) {
      _iconosActivos.removeAt(index);
      _iconosNotifier.value = List.from(_iconosActivos);
    }
  }

  /// Reordena los iconos del panel
  void reordenarIconos(int indexActual, int nuevoIndex) {
    if (indexActual >= 0 &&
        indexActual < _iconosActivos.length &&
        nuevoIndex >= 0 &&
        nuevoIndex < _iconosActivos.length) {
      final item = _iconosActivos.removeAt(indexActual);
      _iconosActivos.insert(nuevoIndex, item);
      _iconosNotifier.value = List.from(_iconosActivos);
    }
  }

  /// Resetea los iconos a la configuración por defecto
  void resetear() {
    _iconosActivos = List.from(smartHomeOptions);
  }
}

