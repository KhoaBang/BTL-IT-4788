// lib/services/auth_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/api/base_query.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    try {
      BaseQuery baseQuery = BaseQuery();

      Response postResponse = await baseQuery.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (postResponse.statusCode == 200) {
        print('Login successful: ${postResponse.data}');
        await _storeTokens(postResponse.data['data']);
        return true;
      } else {
        print('Login failed: ${postResponse.data['message']}');
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> signup(
      String username, String email, String password, String phone) async {
    try {
      BaseQuery baseQuery = BaseQuery();

      Response postResponse = await baseQuery.post('/register', {
        'username': username,
        'email': email,
        'password': password,
        'phone': phone,
      });

      if (postResponse.statusCode == 201) {
        print('Signup successful: ${postResponse.data}');
        await _storeTokens(postResponse.data['data']);
        return true;
      } else {
        print('Signup failed: ${postResponse.data['message']}');
        return false;
      }
    } catch (e) {
      print('Signup error: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      BaseQuery baseQuery = BaseQuery();

      Response postResponse = await baseQuery.post('/auth/logout', {});

      if (postResponse.statusCode == 200) {
        // Clear tokens from storage
        await _clearTokens();
        return true;
      } else {
        print('Logout failed: ${postResponse.data['message']}');
        return false;
      }
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  // Helper methods to handle tokens
  Future<void> _storeTokens(Map<String, dynamic> data) async {
    await _storage.write(key: 'access_token', value: data['access_token']);
    await _storage.write(key: 'refresh_token', value: data['refresh_token']);
    print('Tokens stored successfully.');
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    print('Tokens cleared from secure storage.');
  }
}
