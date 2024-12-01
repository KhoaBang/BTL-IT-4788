import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

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
}
