import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
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

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');
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
  }

  Future<Map<String, dynamic>> signup(
      String fullName, String email, String phone, String password) async {
    final url = Uri.parse('$_baseUrl/register');
    final payload = {
      'username': fullName,
      'email': email,
      'phone': phone,
      'password': password,
    };
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
      if (responseData['error']['message'] == "Email already exists.") {
        throw Exception('Email already exists.');
      } else {
        throw Exception('Signup failed: ${responseData['error']['message']}');
      }
    }
  }

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
        // Xóa token sau khi logout thành công
        await prefs.remove('access_token');
        await prefs.remove('refresh_token');
      } else if (response.statusCode == 401) {
        // Nếu token hết hạn, làm mới token
        await refreshAccessToken();
        return logout(); // Thử lại logout
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception('Logout failed: ${responseData['message']}');
      }
    } catch (e) {
      throw Exception('Logout error: $e');
    }
  }

  Future<void> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    final url = Uri.parse('$_baseUrl/refreshToken');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 1) {
        final newAccessToken = responseData['data']['access_token'];
        await prefs.setString('access_token', newAccessToken);
      } else {
        throw Exception('Refresh token failed: ${responseData['message']}');
      }
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createGroup(String groupName) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    if (accessToken == null) throw Exception('Access token missing');

    final url = Uri.parse('$_baseUrl/group');
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
  }

  Future<void> joinGroup(String groupCode) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    if (accessToken == null) throw Exception('Access token missing');

    final url = Uri.parse('$_baseUrl/group/join/$groupCode');
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
    } else if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to join group: ${response.body}');
    }
  }
}
