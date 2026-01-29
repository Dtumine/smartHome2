class DispositivoService {
  static final DispositivoService _instance = DispositivoService._internal();
  factory DispositivoService() => _instance;
  DispositivoService._internal();

  // Lista de dispositivos con su estado
  final Map<String, bool> _estadosDispositivos = {
    'Luz Sala Principal': true,
    'Luz Cocina': true,
    'Cámara Entrada Principal': true,
    'Cámara Jardín Trasero': true,
    'Sensor Temperatura Sala': true,
    'Sensor Humedad Cocina': true,
    'Termostato Principal': true,
    'Cerradura Entrada': true,
    'Cerradura Garage': true,
    'Zona Riego Jardín Frontal': true,
    'Ventilador Sala Principal': true,
    'Ventilador Dormitorio 1': true,
    'Cortina Sala Principal': true,
    'Cortina Dormitorio': true,
    'Alarma Zona Entrada': true,
    'Alarma Zona Cocina': true,
    'Luz Dormitorio 1': true,
    'Luz Dormitorio 2': true,
    'Sensor Movimiento Garaje': true,
    'Cámara Garage': true,
    'Cámara Piscina': true,
    'Ventilador Cocina': true,
    'Zona Riego Jardín Trasero': true,
    'Zona Riego Huerto': true,
    // Luces manuales
    'Luz Sala': true,
    'Luz Dormitorio 1 (Luces)': true,
    'Luz Baño 1': false,
    'Luz Garage (Luces)': false,
    'Luz Jardín 1': false,
    'Luz Living': false,
    'Luz Dormitorio 2 (Luces)': false,
    'Luz Dormitorio 3': false,
    'Luz Jardín 2': false,
    'Luz Piscina': false,
    'Luz Pérgola': false,
  };

  // Total de dispositivos (incluyendo inactivos)
  int get totalDispositivos => _estadosDispositivos.length;

  // Obtener el estado de un dispositivo
  bool isActivo(String nombre) {
    return _estadosDispositivos[nombre] ?? false;
  }

  // Cambiar el estado de un dispositivo
  void cambiarEstado(String nombre, bool activo) {
    _estadosDispositivos[nombre] = activo;
  }

  // Obtener el número de dispositivos activos
  int get dispositivosActivos {
    return _estadosDispositivos.values.where((activo) => activo).length;
  }

  // Obtener todos los estados
  Map<String, bool> get todosLosEstados => Map.from(_estadosDispositivos);
}

