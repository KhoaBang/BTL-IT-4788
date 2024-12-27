// lib/models/auth_state.dart

class AuthState {
  final bool isAuthenticated;
  final String? username;
  final String? accessToken;
  final String? refreshToken;

  AuthState({
    // constructor
    this.isAuthenticated = false,
    this.username,
    this.accessToken,
    this.refreshToken,
  });

  AuthState copyWith({
    // ham copyWith
    bool? isAuthenticated,
    String? username,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      username: username ?? this.username,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
