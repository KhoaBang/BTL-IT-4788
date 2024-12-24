import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL khởi tạo tuỳ thuộc vào nền tảng
  static late final String _baseUrl = _initializeBaseUrl();

  static String _initializeBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:9000/api'; // Web
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:9000/api'; // Android Emulator
    } else {
      return 'http://localhost:9000/api'; // Các nền tảng khác
    }
  }

  /// Đăng nhập người dùng
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception('Login failed: ${responseData['error']['message']}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  /// Đăng ký người dùng mới
  Future<Map<String, dynamic>> signup(
      String fullName, String email, String phone, String password) async {
    final url = Uri.parse('$_baseUrl/register');
    final payload = {
      'username': fullName,
      'email': email,
      'phone': phone,
      'password': password,
    };
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final responseData = jsonDecode(response.body);
        final errorMessage = responseData['error']['message'] ?? 'Unknown error';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Signup error: $e');
    }
  }

  /// Đăng xuất người dùng
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    final refreshToken = prefs.getString('refresh_token');

    if (accessToken == null || refreshToken == null) {
      throw Exception('Tokens are missing');
    }

    final logoutUrl = Uri.parse('$_baseUrl/auth/logout');
    try {
      final response = await http.post(
        logoutUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('access_token');
        await prefs.remove('refresh_token');
      } else if (response.statusCode == 401) {
        await refreshAccessToken();
        return logout();
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception('Logout failed: ${responseData['message']}');
      }
    } catch (e) {
      throw Exception('Logout error: $e');
    }
  }

  /// Làm mới token truy cập
  Future<void> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');

    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    final url = Uri.parse('$_baseUrl/refreshToken');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final newAccessToken = responseData['data']['access_token'];
        await prefs.setString('access_token', newAccessToken);
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception('Failed to refresh token: ${responseData['message']}');
      }
    } catch (e) {
      throw Exception('Refresh token error: $e');
    }
  }

  /// Tạo nhóm mới
  Future<Map<String, dynamic>> createGroup(String groupName) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      throw Exception('Access token missing');
    }

    final url = Uri.parse('$_baseUrl/group');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'group_name': groupName}),
      );

      if (response.statusCode == 401) {
        await refreshAccessToken();
        return createGroup(groupName);
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create group: ${response.body}');
      }
    } catch (e) {
      throw Exception('Create group error: $e');
    }
  }

  /// Tham gia nhóm bằng mã nhóm
  Future<Map<String, dynamic>> joinGroup(String groupCode) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      throw Exception('Access token missing');
    }

    final url = Uri.parse('$_baseUrl/group/join/$groupCode');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 401) {
        await refreshAccessToken();
        return joinGroup(groupCode);
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body)['group_detail'];
      } else {
        throw Exception('Failed to join group: ${response.body}');
      }
    } catch (e) {
      throw Exception('Join group error: $e');
    }
  }
}
