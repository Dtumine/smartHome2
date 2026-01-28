import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProgramacionRiego {
  final String zona;
  final String hora; // Formato "HH:mm"
  final int duracion; // minutos
  final Map<String, bool> diasSemana;
  final bool repetirSemanalmente;

  ProgramacionRiego({
    required this.zona,
    required this.hora,
    required this.duracion,
    required this.diasSemana,
    required this.repetirSemanalmente,
  });

  Map<String, dynamic> toJson() {
    return {
      'zona': zona,
      'hora': hora,
      'duracion': duracion,
      'diasSemana': diasSemana,
      'repetirSemanalmente': repetirSemanalmente,
    };
  }

  factory ProgramacionRiego.fromJson(Map<String, dynamic> json) {
    return ProgramacionRiego(
      zona: json['zona'] as String,
      hora: json['hora'] as String,
      duracion: json['duracion'] as int,
      diasSemana: Map<String, bool>.from(json['diasSemana'] as Map),
      repetirSemanalmente: json['repetirSemanalmente'] as bool,
    );
  }
}

class RiegoService {
  static final RiegoService _instance = RiegoService._internal();
  factory RiegoService() => _instance;
  RiegoService._internal();

  static const String _prefsKey = 'programaciones_riego';

  /// Guarda una programación de riego
  Future<bool> guardarProgramacion(ProgramacionRiego programacion) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final programaciones = await obtenerTodasLasProgramaciones();
      
      // Eliminar programación anterior de la misma zona si existe
      programaciones.removeWhere((p) => p.zona == programacion.zona);
      
      // Agregar la nueva programación
      programaciones.add(programacion);
      
      // Guardar todas las programaciones
      final jsonList = programaciones.map((p) => p.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      final guardado = await prefs.setString(_prefsKey, jsonString);
      
      // Verificar que se guardó correctamente
      if (guardado) {
        final verificado = prefs.getString(_prefsKey);
        if (verificado != null && verificado == jsonString) {
          print('✓ Programación guardada exitosamente para: ${programacion.zona}');
          return true;
        } else {
          print('✗ Error: La programación no se guardó correctamente');
          return false;
        }
      } else {
        print('✗ Error: No se pudo guardar la programación');
        return false;
      }
    } catch (e) {
      print('✗ Error al guardar programación: $e');
      return false;
    }
  }

  /// Obtiene la programación de una zona específica
  Future<ProgramacionRiego?> obtenerProgramacion(String zona) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_prefsKey);
      
      if (jsonString == null || jsonString.isEmpty) return null;
      
      final jsonList = jsonDecode(jsonString) as List;
      if (jsonList.isEmpty) return null;
      
      final programaciones = jsonList
          .map((json) => ProgramacionRiego.fromJson(json as Map<String, dynamic>))
          .toList();
      
      try {
        return programaciones.firstWhere(
          (p) => p.zona == zona,
        );
      } catch (e) {
        return null;
      }
    } catch (e) {
      print('Error al obtener programación: $e');
      return null;
    }
  }

  /// Obtiene todas las programaciones guardadas
  Future<List<ProgramacionRiego>> obtenerTodasLasProgramaciones() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_prefsKey);
      
      if (jsonString == null) return [];
      
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((json) => ProgramacionRiego.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Elimina la programación de una zona específica
  Future<void> eliminarProgramacion(String zona) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final programaciones = await obtenerTodasLasProgramaciones();
      
      programaciones.removeWhere((p) => p.zona == zona);
      
      final jsonList = programaciones.map((p) => p.toJson()).toList();
      await prefs.setString(_prefsKey, jsonEncode(jsonList));
    } catch (e) {
      print('Error al eliminar programación: $e');
    }
  }
}

