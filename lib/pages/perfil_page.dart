import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../theme/app_colors.dart';
import '../services/auth_service.dart';
import '../providers/auth_provider.dart';

class PerfilPage extends ConsumerStatefulWidget {
  const PerfilPage({super.key});

  @override
  ConsumerState<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends ConsumerState<PerfilPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  
  String? _photoPath;
  Uint8List? _photoBytes; // Para web
  bool _isLoading = false;
  bool _isSaving = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _cargarDatosPerfil();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatosPerfil() async {
    setState(() {
      _isLoading = true;
    });

    final authService = AuthService();
    final email = await authService.getUserEmail();
    final nombre = await authService.getUserName();
    final nombreCompleto = await authService.getUserFullName();
    final telefono = await authService.getUserPhone();
    final fotoPath = await authService.getUserPhotoPath();
    
    if (kIsWeb) {
      // Para web: cargar base64
      final fotoBase64 = await authService.getUserPhotoBase64();
      if (fotoBase64 != null && fotoBase64.isNotEmpty) {
        setState(() {
          _photoBytes = base64Decode(fotoBase64);
          _photoPath = 'web_image';
        });
      }
    } else {
      // Para móvil: usar ruta del archivo
      setState(() {
        _photoPath = fotoPath;
      });
    }

    if (mounted) {
      setState(() {
        _emailController.text = email ?? '';
        _nombreController.text = nombreCompleto ?? nombre ?? '';
        _telefonoController.text = telefono ?? '';
        _isLoading = false;
      });
    }
  }

  Future<void> _seleccionarFoto() async {
    print('Iniciando selección de foto desde galería...');
    try {
      print('Llamando a pickImage...');
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      print('Resultado de pickImage: ${image != null ? "Imagen seleccionada" : "Ninguna imagen"}');
      
      if (image != null) {
        print('Nombre del archivo: ${image.name}');
        print('Ruta del archivo: ${image.path}');
        
        if (kIsWeb) {
          // Para web: leer los bytes directamente desde el XFile
          print('Plataforma: Web - Leyendo bytes...');
          try {
            final bytes = await image.readAsBytes();
            print('Bytes leídos: ${bytes.length} bytes');
            if (mounted) {
              setState(() {
                _photoBytes = bytes;
                _photoPath = 'web_image'; // Marcador para web
              });
              print('Foto cargada correctamente en web');
            }
          } catch (e) {
            print('Error al leer bytes de la imagen: $e');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error al procesar la imagen: $e'),
                  backgroundColor: AppColors.errorDark,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          }
        } else {
          // Para móvil: guardar en el directorio de la app
          try {
            final directory = await getApplicationDocumentsDirectory();
            final fileName = 'profile_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
            final savedImage = await File(image.path).copy('${directory.path}/$fileName');
            
            if (mounted) {
              setState(() {
                _photoPath = savedImage.path;
                _photoBytes = null;
              });
            }
          } catch (e) {
            print('Error al guardar imagen: $e');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error al guardar imagen: $e'),
                  backgroundColor: AppColors.errorDark,
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
    } catch (e) {
      print('Error al seleccionar foto: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar foto. Por favor, intenta nuevamente.'),
            backgroundColor: AppColors.errorDark,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _tomarFoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        if (kIsWeb) {
          // Para web: leer los bytes directamente
          final bytes = await image.readAsBytes();
          setState(() {
            _photoBytes = bytes;
            _photoPath = 'web_image'; // Marcador para web
          });
        } else {
          // Para móvil: guardar en el directorio de la app
          final directory = await getApplicationDocumentsDirectory();
          final fileName = 'profile_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final savedImage = await File(image.path).copy('${directory.path}/$fileName');
          
          setState(() {
            _photoPath = savedImage.path;
            _photoBytes = null;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al tomar foto: $e'),
            backgroundColor: AppColors.errorDark,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _mostrarSelectorFoto() async {
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Seleccionar Foto de Perfil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xFF58A6FF),
              ),
              title: const Text(
                'Desde Galería',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _seleccionarFoto();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.camera_alt,
                color: Color(0xFF58A6FF),
              ),
              title: const Text(
                'Tomar Foto',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                _tomarFoto();
              },
            ),
            if (_photoPath != null)
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFFF6B6B),
                ),
                title: const Text(
                  'Eliminar Foto',
                  style: TextStyle(color: Color(0xFFFF6B6B)),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _photoPath = null;
                    _photoBytes = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _guardarPerfil() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final authService = AuthService();
    
    try {
      // Guardar datos del perfil
      await authService.saveUserFullName(_nombreController.text.trim());
      await authService.updateUserEmail(_emailController.text.trim());
      await authService.saveUserPhone(_telefonoController.text.trim());
      
      // Guardar foto según la plataforma
      if (kIsWeb) {
        // Para web: guardar como base64
        if (_photoBytes != null) {
          final base64Photo = base64Encode(_photoBytes!);
          await authService.saveUserPhotoPath('web_image', base64Photo: base64Photo);
        } else {
          await authService.saveUserPhotoPath('', base64Photo: '');
        }
      } else {
        // Para móvil: guardar ruta del archivo
        if (_photoPath != null && _photoPath!.isNotEmpty) {
          await authService.saveUserPhotoPath(_photoPath!);
        } else {
          await authService.saveUserPhotoPath('');
        }
      }

      // Actualizar el nombre de usuario (usado para el avatar inicial)
      // El nombre completo ya se guardó arriba, no es necesario guardarlo de nuevo

      if (mounted) {
        // Invalidar providers para refrescar los datos
        ref.invalidate(userEmailProvider);
        ref.invalidate(userNameProvider);
        ref.invalidate(userFullNameProvider);
        ref.invalidate(userPhoneProvider);
        ref.invalidate(userPhotoPathProvider);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Perfil actualizado correctamente'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Regresar a la página anterior
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar perfil: $e'),
            backgroundColor: AppColors.errorDark,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.celestialBlueGradient,
          ),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF58A6FF)),
            ),
          ),
        ),
      );
    }

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
                        'Editar Perfil',
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

              // Contenido
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Foto de perfil
                        GestureDetector(
                          onTap: _mostrarSelectorFoto,
                          child: Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: _photoPath == null
                                      ? const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF58A6FF),
                                            Color(0xFF0077B6),
                                          ],
                                        )
                                      : null,
                                  color: _photoPath != null ? Colors.transparent : null,
                                  border: Border.all(
                                    color: const Color(0xFF58A6FF),
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF58A6FF).withValues(alpha: 0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: _photoPath != null && _photoPath!.isNotEmpty
                                    ? ClipOval(
                                        child: kIsWeb && _photoBytes != null
                                            ? Image.memory(
                                                _photoBytes!,
                                                fit: BoxFit.cover,
                                              )
                                            : !kIsWeb && File(_photoPath!).existsSync()
                                                ? Image.file(
                                                    File(_photoPath!),
                                                    fit: BoxFit.cover,
                                                  )
                                                : Center(
                                                    child: Text(
                                                      _nombreController.text.isNotEmpty
                                                          ? _nombreController.text
                                                              .substring(0, 1)
                                                              .toUpperCase()
                                                          : 'U',
                                                      style: const TextStyle(
                                                        fontSize: 48,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                      )
                                    : Center(
                                        child: Text(
                                          _nombreController.text.isNotEmpty
                                              ? _nombreController.text
                                                  .substring(0, 1)
                                                  .toUpperCase()
                                              : 'U',
                                          style: const TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF58A6FF),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.cardBackground,
                                      width: 3,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Campo Nombre Completo
                        _buildTextField(
                          controller: _nombreController,
                          label: 'Nombre Completo',
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingresa tu nombre completo';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Campo Email
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingresa tu email';
                            }
                            if (!value.contains('@')) {
                              return 'Ingresa un email válido';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Campo Teléfono
                        _buildTextField(
                          controller: _telefonoController,
                          label: 'Teléfono',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              if (value.trim().length < 8) {
                                return 'Ingresa un teléfono válido';
                              }
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 40),

                        // Botón Guardar
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _guardarPerfil,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF58A6FF),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Guardar Cambios',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColors.textSecondary),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF58A6FF),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        validator: validator,
      ),
    );
  }
}

