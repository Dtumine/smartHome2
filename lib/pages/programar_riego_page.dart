import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme/app_colors.dart';
import '../services/riego_service.dart';

class ProgramarRiegoPage extends StatefulWidget {
  final String? zonaNombre;
  final int? zonaIndex;

  const ProgramarRiegoPage({
    super.key,
    this.zonaNombre,
    this.zonaIndex,
  });

  @override
  State<ProgramarRiegoPage> createState() => _ProgramarRiegoPageState();
}

class _ProgramarRiegoPageState extends State<ProgramarRiegoPage> {
  // Lista completa de zonas disponibles
  final List<String> _todasLasZonas = [
    'Jardín Frontal',
    'Jardín Trasero',
    'Huerto',
    'Macetas Terraza',
    'Césped Lateral',
  ];

  // Lista de zonas a mostrar (solo la seleccionada si viene como parámetro)
  late List<String> _zonas;
  String _zonaSeleccionada = 'Jardín Frontal';
  TimeOfDay _horaSeleccionada = const TimeOfDay(hour: 8, minute: 0);
  int _duracion = 30; // minutos
  final Map<String, bool> _diasSemana = {
    'Lunes': false,
    'Martes': false,
    'Miércoles': false,
    'Jueves': false,
    'Viernes': false,
    'Sábado': false,
    'Domingo': false,
  };
  bool _repetirSemanalmente = true;
  bool _zonaPredefinida = false; // Indica si la zona viene predefinida

  @override
  void initState() {
    super.initState();
    if (widget.zonaNombre != null) {
      // Si viene una zona específica, solo mostrar esa
      _zonaSeleccionada = widget.zonaNombre!;
      _zonas = [widget.zonaNombre!];
      _zonaPredefinida = true;
    } else {
      // Si no viene zona específica, mostrar todas
      _zonas = List.from(_todasLasZonas);
      _zonaSeleccionada = _todasLasZonas[0];
      _zonaPredefinida = false;
    }
    
    // Cargar programación guardada después de que el frame se haya construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _cargarProgramacionGuardada();
      }
    });
  }

  Future<void> _cargarProgramacionGuardada() async {
    try {
      final riegoService = RiegoService();
      final programacion = await riegoService.obtenerProgramacion(_zonaSeleccionada);
      
      if (mounted) {
        setState(() {
          if (programacion != null) {
            // Cargar valores guardados
            try {
              final partesHora = programacion.hora.split(':');
              _horaSeleccionada = TimeOfDay(
                hour: int.parse(partesHora[0]),
                minute: int.parse(partesHora[1]),
              );
              
              _duracion = programacion.duracion;
              
              // Cargar días de la semana guardados
              _diasSemana.clear();
              _diasSemana.addAll(programacion.diasSemana);
              
              _repetirSemanalmente = programacion.repetirSemanalmente;
              
              print('✓ Programación cargada para: $_zonaSeleccionada');
              print('  Hora: ${programacion.hora}, Duración: ${programacion.duracion}');
            } catch (e) {
              print('✗ Error al parsear programación guardada: $e');
              // Si hay error al parsear, usar valores por defecto
              _diasSemana.updateAll((key, value) => true);
            }
          } else {
            // Solo establecer valores por defecto si no hay programación guardada
            _diasSemana.updateAll((key, value) => true);
            print('ℹ No hay programación guardada para: $_zonaSeleccionada');
          }
        });
      }
    } catch (e) {
      print('✗ Error al cargar programación: $e');
      if (mounted) {
        setState(() {
          _diasSemana.updateAll((key, value) => true);
        });
      }
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

              // Contenido
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Información
                      Container(
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
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00CED1).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Symbols.schedule,
                                color: Color(0xFF00CED1),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Programar Riego',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Configura horarios automáticos',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Selector de zona
                      _buildTituloSeccion('Zona de Riego'),
                      const SizedBox(height: 12),
                      _buildSelectorZona(),

                      const SizedBox(height: 20),

                      // Selector de hora
                      _buildTituloSeccion('Hora de Riego'),
                      const SizedBox(height: 12),
                      _buildSelectorHora(),

                      const SizedBox(height: 20),

                      // Duración
                      _buildTituloSeccion('Duración'),
                      const SizedBox(height: 12),
                      _buildSelectorDuracion(),

                      const SizedBox(height: 20),

                      // Días de la semana
                      _buildTituloSeccion('Días de la Semana'),
                      const SizedBox(height: 12),
                      _buildSelectorDias(),

                      const SizedBox(height: 20),

                      // Opción de repetir
                      _buildOpcionRepetir(),

                      const SizedBox(height: 30),

                      // Botón guardar
                      _buildBotonGuardar(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
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
          const Expanded(
            child: Text(
              'Programar Riego',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTituloSeccion(String titulo) {
    return Text(
      titulo,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSelectorZona() {
    // Si la zona está predefinida, mostrar solo el nombre sin selector
    if (_zonaPredefinida) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF00CED1).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF00CED1).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Symbols.eco,
                color: Color(0xFF00CED1),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _zonaSeleccionada,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Zona seleccionada',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    
    // Si no está predefinida, mostrar el selector normal
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder,
        ),
      ),
      child: DropdownButton<String>(
        value: _zonaSeleccionada,
        isExpanded: true,
        dropdownColor: AppColors.cardBackground,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        underline: Container(),
        icon: const Icon(
          Symbols.arrow_drop_down,
          color: Color(0xFF00CED1),
        ),
        items: _zonas.map((zona) {
          return DropdownMenuItem<String>(
            value: zona,
            child: Text(zona),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _zonaSeleccionada = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildSelectorHora() {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: _horaSeleccionada,
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFF00CED1),
                  onPrimary: Colors.white,
                  surface: AppColors.cardBackground,
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            _horaSeleccionada = picked;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.cardBorder,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Symbols.access_time,
                  color: Color(0xFF00CED1),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  _horaSeleccionada.format(context),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Icon(
              Symbols.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorDuracion() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Duración',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '$_duracion minutos',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Slider(
            value: _duracion.toDouble(),
            min: 5,
            max: 120,
            divisions: 23,
            activeColor: const Color(0xFF00CED1),
            inactiveColor: AppColors.cardBorder,
            label: '$_duracion minutos',
            onChanged: (value) {
              setState(() {
                _duracion = value.toInt();
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBotonDuracion(5),
              _buildBotonDuracion(15),
              _buildBotonDuracion(30),
              _buildBotonDuracion(60),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBotonDuracion(int minutos) {
    final isSelected = _duracion == minutos;
    return GestureDetector(
      onTap: () {
        setState(() {
          _duracion = minutos;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00CED1).withValues(alpha: 0.15)
              : AppColors.cardBackgroundAlt,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF00CED1)
                : AppColors.cardBorder,
          ),
        ),
        child: Text(
          '$minutos min',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? const Color(0xFF00CED1)
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectorDias() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder,
        ),
      ),
      child: Column(
        children: _diasSemana.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _diasSemana[entry.key] = !entry.value;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: entry.value
                          ? const Color(0xFF00CED1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: entry.value
                            ? const Color(0xFF00CED1)
                            : AppColors.cardBorder,
                      ),
                    ),
                    child: entry.value
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOpcionRepetir() {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(
                Symbols.repeat,
                color: Color(0xFF00CED1),
                size: 20,
              ),
              SizedBox(width: 12),
              Text(
                'Repetir Semanalmente',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Switch(
            value: _repetirSemanalmente,
            onChanged: (value) {
              setState(() {
                _repetirSemanalmente = value;
              });
            },
            activeColor: const Color(0xFF00CED1),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonGuardar() {
    return GestureDetector(
      onTap: () {
        _guardarProgramacion();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00CED1),
              Color(0xFF008B8B),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00CED1).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.check,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Guardar Programación',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _guardarProgramacion() async {
    final diasSeleccionados = _diasSemana.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (diasSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Selecciona al menos un día de la semana'),
          backgroundColor: AppColors.cardBackground,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Guardar la programación usando el servicio
    final riegoService = RiegoService();
    final horaFormateada = '${_horaSeleccionada.hour.toString().padLeft(2, '0')}:${_horaSeleccionada.minute.toString().padLeft(2, '0')}';
    
    final programacion = ProgramacionRiego(
      zona: _zonaSeleccionada,
      hora: horaFormateada,
      duracion: _duracion,
      diasSemana: Map<String, bool>.from(_diasSemana),
      repetirSemanalmente: _repetirSemanalmente,
    );

    final guardado = await riegoService.guardarProgramacion(programacion);

    if (mounted) {
      if (guardado) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Riego programado para $_zonaSeleccionada a las ${_horaSeleccionada.format(context)}',
            ),
            backgroundColor: AppColors.cardBackground,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Regresar a la página anterior
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Error al guardar la programación. Intenta nuevamente.',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }
}

