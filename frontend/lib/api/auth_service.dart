// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
//   final Dio _dio = Dio();

//   // API URLs
//   final String signupUrl = 'http://localhost:9000/api/register';
//   final String loginUrl = 'http://localhost:9000/api/auth/login';
//   final String logoutUrl = 'http://localhost:9000/api/auth/logout';
//   final String refreshTokenUrl = 'http://localhost:9000/api/refreshToken';

//   // Function: Signup
//   Future<void> signup(
//       String username, String email, String password, String phone) async {
//     try {
//       Response response = await _dio.post(signupUrl, data: {
//         "username": username,
//         "email": email,
//         "password": password,
//         "phone": phone,
//       });

//       if (response.data['status'] == 1) {
//         print('Signup successful: ${response.data['message']}');
//         print('User data: ${response.data['data']}');
//       } else {
//         print('Signup failed: ${response.data['message']}');
//       }
//     } catch (e) {
//       print('Signup error: $e');
//     }
//   }

//   // Function: Login
//   Future<bool> login(String email, String password) async {
//     try {
//       Response response = await _dio.post(loginUrl, data: {
//         "email": email,
//         "password": password,
//       });

//       if (response.data['status'] == 1) {
//         print('Login successful: ${response.data['message']}');

//         // Extract tokens
//         String accessToken = response.data['data']['access_token'];
//         String refreshToken = response.data['data']['refresh_token'];

//         // Save tokens using shared_preferences
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('access_token', accessToken);
//         await prefs.setString('refresh_token', refreshToken);

//         print('Tokens saved:');
//         print('Access Token: $accessToken');
//         print('Refresh Token: $refreshToken');

//         return true; // Đăng nhập thành công
//       } else {
//         throw Exception(response.data['message']); // Đăng nhập thất bại
//       }
//     } catch (e) {
//       print('Login error: $e');
//       throw Exception('Login failed: $e'); // Ném ngoại lệ khi có lỗi
//     }
//   }

//   // Function: Get saved tokens
//   Future<Map<String, String?>> getSavedTokens() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? accessToken = prefs.getString('access_token');
//     String? refreshToken = prefs.getString('refresh_token');
//     return {
//       "access_token": accessToken,
//       "refresh_token": refreshToken,
//     };
//   }

//   // Function: Logout
//   Future<void> logout() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? accessToken = prefs.getString('access_token');

//       if (accessToken == null) {
//         throw Exception('No access token found. Please login again.');
//       }

//       try {
//         // Gửi yêu cầu logout
//         final response = await _dio.post(
//           logoutUrl,
//           options: Options(
//             headers: {'Authorization': 'Bearer $accessToken'},
//           ),
//         );

//         if (response.data['status'] == 1) {
//           print('Logout successful: ${response.data['message']}');

//           // Xóa token sau khi logout thành công
//           await prefs.remove('access_token');
//           await prefs.remove('refresh_token');
//         } else {
//           throw Exception('Logout failed: ${response.data['message']}');
//         }
//       } catch (e) {
//         // Nếu lỗi do token hết hạn
//         if (e is DioException && e.response?.statusCode == 403) {
//           print('Access token expired. Attempting to refresh...');
//           await refreshToken();

//           // Lấy token mới sau khi làm mới
//           accessToken = prefs.getString('access_token');
//           if (accessToken != null) {
//             final retryResponse = await _dio.post(
//               logoutUrl,
//               options: Options(
//                 headers: {'Authorization': 'Bearer $accessToken'},
//               ),
//             );

//             if (retryResponse.data['status'] == 1) {
//               print(
//                   'Logout successful after retry: ${retryResponse.data['message']}');

//               // Xóa token sau khi logout thành công
//               await prefs.remove('access_token');
//               await prefs.remove('refresh_token');
//             } else {
//               throw Exception(
//                   'Logout failed after retry: ${retryResponse.data['message']}');
//             }
//           } else {
//             throw Exception('Failed to refresh access token for logout.');
//           }
//         } else {
//           throw Exception('Unexpected error: $e');
//         }
//       }
//     } catch (e) {
//       print('Logout error: $e');
//       throw Exception('Logout failed: $e');
//     }
//   }

//   // Future<void> logout() async {
//   //   try {
//   //     SharedPreferences prefs = await SharedPreferences.getInstance();
//   //     String? accessToken = prefs.getString('access_token');

//   //     if (accessToken == null) {
//   //       throw Exception('No access token found. Please login again.');
//   //     }

//   //     try {
//   //       final response = await _dio.post(
//   //         logoutUrl,
//   //         options: Options(
//   //           headers: {'Authorization': 'Bearer $accessToken'},
//   //         ),
//   //       );

//   //       if (response.data['status'] == 1) {
//   //         print('Logout successful: ${response.data['message']}');

//   //         // Clear tokens
//   //         await prefs.remove('access_token');
//   //         await prefs.remove('refresh_token');
//   //       } else {
//   //         print('Logout failed: ${response.data['message']}');
//   //       }
//   //     } catch (e) {
//   //       // Attempt to refresh the token if access token is expired
//   //       print('Access token expired. Attempting to refresh...');
//   //       await refreshToken();

//   //       // Retry logout with refreshed token
//   //       accessToken = prefs.getString('access_token');
//   //       if (accessToken != null) {
//   //         final retryResponse = await _dio.post(
//   //           logoutUrl,
//   //           options: Options(
//   //             headers: {'Authorization': 'Bearer $accessToken'},
//   //           ),
//   //         );

//   //         if (retryResponse.data['status'] == 1) {
//   //           print(
//   //               'Logout successful after retry: ${retryResponse.data['message']}');

//   //           // Clear tokens
//   //           await prefs.remove('access_token');
//   //           await prefs.remove('refresh_token');
//   //         } else {
//   //           throw Exception(
//   //               'Logout failed after retry: ${retryResponse.data['message']}');
//   //         }
//   //       } else {
//   //         throw Exception('Failed to refresh access token for logout.');
//   //       }
//   //     }
//   //   } catch (e) {
//   //     print('Logout error: $e');
//   //     throw Exception('Logout failed: $e');
//   //   }
//   // }

//   // Function: Refresh Token
//   // Future<void> refreshToken() async {
//   //   try {
//   //     SharedPreferences prefs = await SharedPreferences.getInstance();
//   //     String? refreshToken = prefs.getString('refresh_token');

//   //     if (refreshToken != null) {
//   //       Response response = await _dio.post(refreshTokenUrl, data: {
//   //         "refresh_token": refreshToken,
//   //       });

//   //       if (response.data['status'] == 1) {
//   //         String newAccessToken = response.data['data']['access_token'];
//   //         await prefs.setString('access_token', newAccessToken);
//   //         print('Access token refreshed: $newAccessToken');
//   //       } else {
//   //         print('Refresh token failed: ${response.data['message']}');
//   //       }
//   //     } else {
//   //       print('No refresh token found.');
//   //     }
//   //   } catch (e) {
//   //     print('Refresh token error: $e');
//   //   }
//   // }
//   Future<void> refreshToken() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? refreshToken = prefs.getString('refresh_token');

//       if (refreshToken == null) {
//         throw Exception('No refresh token found. Please login again.');
//       }

//       Response response = await _dio.post(refreshTokenUrl, data: {
//         "refresh_token": refreshToken,
//       });

//       if (response.data['status'] == 1) {
//         String newAccessToken = response.data['data']['access_token'];
//         await prefs.setString('access_token', newAccessToken);
//         print('Access token refreshed: $newAccessToken');
//       } else {
//         throw Exception('Refresh token failed: ${response.data['message']}');
//       }
//     } catch (e) {
//       print('Refresh token error: $e');
//       // Xóa thông tin đăng nhập và yêu cầu đăng nhập lại
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.remove('access_token');
//       await prefs.remove('refresh_token');
//       throw Exception('Failed to refresh token. Please login again.');
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:frontend/api/base_query.dart';

class AuthService {
  Future<bool> login(String email, String password) async {
    try {
      BaseQuery baseQuery = BaseQuery();
      Response postResponse = await baseQuery.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (postResponse.data['status'] == 1) {
        print('Login successful: ${postResponse.data}');
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

      if (postResponse.data['status'] == 1) {
        print('Signup successful: ${postResponse.data}');
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

      if (postResponse.data['status'] == 1) {
        print('Logout successful.');
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
}
