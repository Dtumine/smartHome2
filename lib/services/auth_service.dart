import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userFullNameKey = 'user_full_name';
  static const String _userPhoneKey = 'user_phone';
  static const String _userPhotoPathKey = 'user_photo_path';
  static const String _userPhotoBase64Key = 'user_photo_base64'; // Para web

  /// Inicia sesión con email y contraseña
  /// En una app real, esto haría una llamada a un servidor
  Future<bool> login(String email, String password) async {
    try {
      // Simulación de autenticación
      // En producción, aquí harías una llamada a tu API
      await Future.delayed(const Duration(seconds: 1));
      
      // Validación simple (en producción usarías un backend real)
      if (email.isNotEmpty && password.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        
        // Guardar estado de sesión
        await prefs.setBool(_isLoggedInKey, true);
        await prefs.setString(_userEmailKey, email);
        
        // Extraer nombre del email (antes del @)
        final nombre = email.split('@')[0];
        await prefs.setString(_userNameKey, nombre);
        
        return true;
      }
      
      return false;
    } catch (e) {
      print('Error al iniciar sesión: $e');
      return false;
    }
  }

  /// Cierra la sesión del usuario
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, false);
      await prefs.remove(_userEmailKey);
      await prefs.remove(_userNameKey);
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }

  /// Verifica si el usuario está autenticado
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Obtiene el email del usuario actual
  Future<String?> getUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userEmailKey);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene el nombre del usuario actual
  Future<String?> getUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userNameKey);
    } catch (e) {
      return null;
    }
  }

  /// Guarda el nombre completo del usuario
  Future<bool> saveUserFullName(String fullName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userFullNameKey, fullName);
      return true;
    } catch (e) {
      print('Error al guardar nombre completo: $e');
      return false;
    }
  }

  /// Obtiene el nombre completo del usuario
  Future<String?> getUserFullName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userFullNameKey);
    } catch (e) {
      return null;
    }
  }

  /// Guarda el teléfono del usuario
  Future<bool> saveUserPhone(String phone) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userPhoneKey, phone);
      return true;
    } catch (e) {
      print('Error al guardar teléfono: $e');
      return false;
    }
  }

  /// Obtiene el teléfono del usuario
  Future<String?> getUserPhone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userPhoneKey);
    } catch (e) {
      return null;
    }
  }

  /// Guarda la ruta de la foto de perfil (móvil) o base64 (web)
  Future<bool> saveUserPhotoPath(String photoPath, {String? base64Photo}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userPhotoPathKey, photoPath);
      if (base64Photo != null) {
        await prefs.setString(_userPhotoBase64Key, base64Photo);
      } else {
        await prefs.remove(_userPhotoBase64Key);
      }
      return true;
    } catch (e) {
      print('Error al guardar foto de perfil: $e');
      return false;
    }
  }

  /// Obtiene la ruta de la foto de perfil (móvil) o base64 (web)
  Future<String?> getUserPhotoPath() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userPhotoPathKey);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene la foto en base64 (para web)
  Future<String?> getUserPhotoBase64() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userPhotoBase64Key);
    } catch (e) {
      return null;
    }
  }

  /// Actualiza el email del usuario
  Future<bool> updateUserEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userEmailKey, email);
      return true;
    } catch (e) {
      print('Error al actualizar email: $e');
      return false;
    }
  }
}

