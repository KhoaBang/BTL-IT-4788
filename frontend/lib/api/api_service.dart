import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static late final String _baseUrl = _initializeBaseUrl();

  static String _initializeBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:9000/api'; // Địa chỉ cho Web
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:9000/api'; // Địa chỉ cho Android Emulator
    } else if (Platform.isIOS ||
        Platform.isMacOS ||
        Platform.isLinux ||
        Platform.isWindows) {
      return 'http://localhost:9000/api'; // Địa chỉ cho các nền tảng khác
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      throw Exception('Login failed: ${responseData['error']['message']}');
    } else {
      throw Exception('Unexpected Error');
    }
  }

  Future<Map<String, dynamic>> signup(
      String fullName, String email, String phone, String password) async {
    final payload = {
      'username': fullName,
      'email': email,
      'phone': phone,
      'password': password,
    };
    final response = await http.post(
      Uri.parse('http://localhost:9000/api/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(payload),
    );
    final responseData = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if ("Email already exists." == responseData['error']['message']) {
      throw (Exception('Email already exists.'));
    } else {
      throw (Exception('Unexpected Error'));
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    String? refreshToken = prefs.getString('refresh_token');
    final logoutUrl = Uri.parse('$_baseUrl/auth/logout');
    final refreshTokenUrl = Uri.parse('$_baseUrl/refreshToken');

    if (accessToken == null || refreshToken == null) {
      throw Exception('Tokens are missing');
    }

    try {
      // Gọi API Logout
      final response = await http.post(
        logoutUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 1) {
          // Xóa token khỏi SharedPreferences
          await prefs.remove('access_token');
          await prefs.remove('refresh_token');
          return;
        } else {
          throw Exception(responseBody['message']);
        }
      } else if (response.statusCode == 401) {
        // Access token hết hạn, gọi refreshToken
        final refreshResponse = await http.post(
          refreshTokenUrl,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refresh_token': refreshToken}),
        );

        if (refreshResponse.statusCode == 200) {
          final refreshBody = jsonDecode(refreshResponse.body);
          if (refreshBody['status'] == 1) {
            // Cập nhật access token mới
            String newAccessToken = refreshBody['data']['access_token'];
            await prefs.setString('access_token', newAccessToken);

            // Thử logout lại với token mới
            final retryResponse = await http.post(
              logoutUrl,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $newAccessToken',
              },
            );

            if (retryResponse.statusCode == 200) {
              final retryBody = jsonDecode(retryResponse.body);
              if (retryBody['status'] == 1) {
                await prefs.remove('access_token');
                await prefs.remove('refresh_token');
                return;
              } else {
                throw Exception(retryBody['message']);
              }
            } else {
              throw Exception('Logout failed on retry');
            }
          } else {
            throw Exception(refreshBody['message']);
          }
        } else {
          throw Exception('Failed to refresh token');
        }
      } else {
        throw Exception(
            'Logout failed with status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Logout error: $e');
    }
  }
}
