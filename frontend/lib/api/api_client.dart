import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  late Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:9000/api')); // Base URL của bạn

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Lấy access token từ SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final accessToken = prefs.getString('access_token');
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options); // Tiếp tục request
      },
      onResponse: (response, handler) {
        return handler.next(response); // Tiếp tục xử lý response
      },
      onError: (DioError error, handler) async {
        if (error.response?.statusCode == 401) {
          // Khi gặp lỗi 401, thử làm mới token
          try {
            await _refreshToken();
            // Lấy access token mới
            final prefs = await SharedPreferences.getInstance();
            final newAccessToken = prefs.getString('access_token');
            if (newAccessToken != null) {
              // Gắn token mới vào request
              error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
              // Gửi lại request
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response); // Trả lại response thành công
            }
          } catch (e) {
            // Nếu refresh token thất bại, logout người dùng
            await _logout();
            return handler.reject(error);
          }
        }
        return handler.next(error); // Tiếp tục xử lý lỗi
      },
    ));
  }

  Dio get dio => _dio; // Truy cập Dio từ bên ngoài

  Future<void> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');
    if (refreshToken == null) {
      throw Exception('Refresh token is missing');
    }

    final response = await _dio.post('/refreshToken', data: {'refresh_token': refreshToken});
    if (response.statusCode == 200) {
      final newAccessToken = response.data['data']['access_token'];
      await prefs.setString('access_token', newAccessToken);
    } else {
      throw Exception('Failed to refresh token');
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Xoá toàn bộ dữ liệu token
    // Điều hướng người dùng về màn hình đăng nhập
    // e.g., Navigator.of(context).pushReplacementNamed('/login');
  }
}
