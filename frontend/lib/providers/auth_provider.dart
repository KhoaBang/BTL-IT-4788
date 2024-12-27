// lib/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/api/auth_service.dart';
import 'package:frontend/models/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState());

  Future<bool> login(String email, String password) async {
    try {
      final success = await _authService.login(email, password);
      if (success) {
        state = state.copyWith(isAuthenticated: true, username: email);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error in provider: $e');
      return false;
    }
  }

  // Signup method
  Future<void> signup(
      String username, String email, String password, String phone) async {
    final success = await _authService.signup(username, email, password, phone);
    if (success) {
      state = state.copyWith(
          isAuthenticated: true,
          username: username); // Set state to authenticated
    }
  }

  // Logout method
  Future<void> logout() async {
    final success = await _authService.logout();
    if (success) {
      state = state.copyWith(
          isAuthenticated: false,
          username: null,
          accessToken: null,
          refreshToken: null); // Reset state
    }
  }
}

// Create a provider for the AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = AuthService();
  return AuthNotifier(authService);
});
