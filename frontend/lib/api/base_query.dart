import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseQuery {
  final Dio _dio = Dio();
  late final String _baseUrl;
  late final String refreshTokenUrl;
  BaseQuery() {
    // Initialize dotenv in a Future or ensure it’s loaded before accessing the environment variables
    _initialize();
  }

  void _initialize() {
    // Assign platform-specific base URL
    if (dotenv.env['MODE'] == 'android') {
      _baseUrl = 'http://10.0.2.2:9000/api';
    } else {
      _baseUrl = 'http://localhost:9000/api';
    }
    refreshTokenUrl = _baseUrl + '/refreshToken';
  }

  Future<void> refreshToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? refreshToken = prefs.getString('refresh_token');

      if (refreshToken == null) {
        throw Exception('No refresh token found. Please login again.');
      }

      Response response = await _dio.post(
        refreshTokenUrl,
        data: {"refresh_token": refreshToken},
      );

      final data = response.data;
      if (data != null && data is Map<String, dynamic> && data['status'] == 1) {
        String? newAccessToken = data['data']?['access_token'] as String?;
        if (newAccessToken != null) {
          await prefs.setString('access_token', newAccessToken);
          print('Access token refreshed: $newAccessToken');
        } else {
          throw Exception('Access token missing in response.');
        }
      } else {
        throw Exception(
            'Refresh token failed: ${data?['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Refresh token error: $e');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      throw Exception('Failed to refresh token. Please login again.');
    }
  }

  Future<Response> get(String url) async {
    return _handleRequest(() => _dio.get(_baseUrl + url));
  }

  Future<Response> post(String url, dynamic data) async {
    return _handleRequest(() async {
      Response response = await _dio.post(_baseUrl + url, data: data);

      // Check if response contains refresh_token or access_token and store them
      final responseData = response.data;
      if (responseData != null && responseData is Map<String, dynamic>) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        final refreshToken = responseData['data']?['refresh_token'] as String?;
        if (refreshToken != null) {
          await prefs.setString('refresh_token', refreshToken);
          print('New refresh token stored: $refreshToken');
        }

        final accessToken = responseData['data']?['access_token'] as String?;
        if (accessToken != null) {
          await prefs.setString('access_token', accessToken);
          print('New access token stored: $accessToken');
        }
      } else {
        print('Response data is null or not a valid Map: $responseData');
      }

      return response;
    });
  }

  Future<Response> put(String url, dynamic data) async {
    return _handleRequest(() => _dio.put(_baseUrl + url, data: data));
  }

  Future<Response> patch(String url, dynamic data) async {
    return _handleRequest(() => _dio.patch(_baseUrl + url, data: data));
  }

  Future<Response> delete(String url, {dynamic data}) async {
    return _handleRequest(() => _dio.delete(_baseUrl + url, data: data));
  }

  Future<Response> _handleRequest(Future<Response> Function() request) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    try {
      // Add Authorization header dynamically
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';

      // Execute the HTTP request
      return await request();
    } catch (e) {
      // Handle token expiration and retry logic
      if (e is DioException && e.response?.statusCode == 403) {
        print('Access token expired. Attempting to refresh...');
        await refreshToken();

        // Fetch the new access token
        accessToken = prefs.getString('access_token');
        if (accessToken != null) {
          try {
            // Update Authorization header with the new token
            _dio.options.headers['Authorization'] = 'Bearer $accessToken';

            // Retry the request
            return await request();
          } catch (retryError) {
            print('Retry failed: $retryError');
            throw Exception('Retry failed. Please try again.');
          }
        } else {
          throw Exception(
              'Failed to retrieve new access token. Please login again.');
        }
      } else if (e is DioException && e.response?.statusCode == 400) {
        print('Update password error: $e');
        throw Exception('Update password failed: $e');
      } else {
        print('Request failed: $e');
        throw Exception('Request failed. Please try again.');
      }
    }
  }
}
