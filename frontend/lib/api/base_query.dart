import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BaseQuery {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Dio _dio = Dio();
  late final String _baseUrl;
  late final String refreshTokenUrl;

  BaseQuery() {
    _initialize();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add Authorization header
        final accessToken = await _storage.read(key: 'access_token');
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        // Handle token expiration
        if (e.response?.statusCode == 403 &&
            e.response?.data['error']['message'] == 'Token expired.') {
          print('Access token expired. Attempting to refresh...');
          await refreshToken();

          // Retry the request
          final accessToken = await _storage.read(key: 'access_token');
          if (accessToken != null) {
            e.requestOptions.headers['Authorization'] = 'Bearer $accessToken';
            final response = await _dio.fetch(e.requestOptions);
            print(e.requestOptions);
            return handler.resolve(response);
          }
        }
        return handler.next(e);
      },
    ));
  }

  void _initialize() {
    try {
      _baseUrl = dotenv.env['MODE'] == 'android'
          ? 'http://10.0.2.2:9000/api'
          : 'http://localhost:9000/api';
      refreshTokenUrl = '$_baseUrl/refreshToken';
    } catch (e) {
      throw Exception('Failed to initialize BaseQuery: $e');
    }
  }

  Future<void> refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) {
        throw Exception('No refresh token found. Please login again.');
      }

      final response = await _dio.post(refreshTokenUrl, data: {
        'refresh_token': refreshToken,
      });

      final data = response.data;
      if (data != null && response.statusCode == 200) {
        final newAccessToken = data['data']['access_token'] as String?;
        if (newAccessToken != null) {
          await _storage.write(key: 'access_token', value: newAccessToken);
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
      await _clearTokens();
      throw Exception('Failed to refresh token. Please login again.');
    }
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<Response> get(String url) async {
    return _dio.get('$_baseUrl$url');
  }

  Future<Response> post(String url, dynamic data) async {
    return _dio.post('$_baseUrl$url', data: data);
  }

  Future<Response> put(String url, dynamic data) async {
    return _dio.put('$_baseUrl$url', data: data);
  }

  Future<Response> patch(String url, dynamic data) async {
    return _dio.patch('$_baseUrl$url', data: data);
  }

  Future<Response> delete(String url, {dynamic data}) async {
    return _dio.delete('$_baseUrl$url', data: data);
  }
}
