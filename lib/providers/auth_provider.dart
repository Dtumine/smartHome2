import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

/// Provider para el servicio de autenticación
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Provider para el estado de autenticación
final authStateProvider = StateNotifierProvider<AuthStateNotifier, bool>((ref) {
  return AuthStateNotifier(ref.read(authServiceProvider));
});

/// Notifier que maneja el estado de autenticación
class AuthStateNotifier extends StateNotifier<bool> {
  final AuthService _authService;

  AuthStateNotifier(this._authService) : super(false) {
    _checkAuthStatus();
  }

  /// Verifica el estado de autenticación al inicializar
  Future<void> _checkAuthStatus() async {
    final isLoggedIn = await _authService.isLoggedIn();
    state = isLoggedIn;
  }

  /// Inicia sesión
  Future<bool> login(String email, String password) async {
    final success = await _authService.login(email, password);
    if (success) {
      state = true;
    }
    return success;
  }

  /// Cierra sesión
  Future<void> logout() async {
    await _authService.logout();
    state = false;
  }

  /// Actualiza el estado de autenticación
  Future<void> refresh() async {
    await _checkAuthStatus();
  }
}

/// Provider para obtener el email del usuario
final userEmailProvider = FutureProvider<String?>((ref) async {
  final authService = ref.read(authServiceProvider);
  return await authService.getUserEmail();
});

/// Provider para obtener el nombre del usuario
final userNameProvider = FutureProvider<String?>((ref) async {
  final authService = ref.read(authServiceProvider);
  return await authService.getUserName();
});

/// Provider para obtener el nombre completo del usuario
final userFullNameProvider = FutureProvider<String?>((ref) async {
  final authService = ref.read(authServiceProvider);
  return await authService.getUserFullName();
});

/// Provider para obtener el teléfono del usuario
final userPhoneProvider = FutureProvider<String?>((ref) async {
  final authService = ref.read(authServiceProvider);
  return await authService.getUserPhone();
});

/// Provider para obtener la ruta de la foto de perfil
final userPhotoPathProvider = FutureProvider<String?>((ref) async {
  final authService = ref.read(authServiceProvider);
  return await authService.getUserPhotoPath();
});

