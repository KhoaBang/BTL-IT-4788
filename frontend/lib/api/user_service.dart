// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserService {
//   final Dio _dio = Dio();

//   // API URLs
//   final String updatePasswordUrl =
//       'http://localhost:9000/api/userInfo/update_pass/me';
//   final String updateProfileUrl =
//       'http://localhost:9000/api/userInfo/profile/update_info/me';
//   final String getProfileUrl = 'http://localhost:9000/api/userInfo/profile/me';
//   final String refreshTokenUrl = 'http://localhost:9000/api/refreshToken';

//   // Function: Update Password
//   Future<void> updatePassword(String oldPassword, String newPassword) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? accessToken = prefs.getString('access_token');

//       if (accessToken == null) {
//         throw Exception('No access token found. Please login again.');
//       }

//       try {
//         final response = await _dio.post(
//           updatePasswordUrl,
//           data: {
//             "oldPassword": oldPassword,
//             "newPassword": newPassword,
//           },
//           options: Options(
//             headers: {'Authorization': 'Bearer $accessToken'},
//           ),
//         );

//         if (response.data['message'] == 'Password updated successfully.') {
//           print('Password updated successfully.');
//         } else {
//           throw Exception(response.data['message']);
//         }
//       } catch (e) {
//         if (e is DioException && e.response?.statusCode == 403) {
//           print('Access token expired. Attempting to refresh...');
//           await refreshToken();

//           // Lấy token mới sau khi làm mới
//           accessToken = prefs.getString('access_token');
//           if (accessToken != null) {
//             // Thử lại yêu cầu
//             final retryResponse = await _dio.post(
//               updatePasswordUrl,
//               data: {
//                 "oldPassword": oldPassword,
//                 "newPassword": newPassword,
//               },
//               options: Options(
//                 headers: {'Authorization': 'Bearer $accessToken'},
//               ),
//             );

//             if (retryResponse.data['message'] ==
//                 'Password updated successfully.') {
//               print('Password updated successfully after retry.');
//             } else {
//               throw Exception(retryResponse.data['message']);
//             }
//           } else {
//             throw Exception(
//                 'Failed to refresh access token for password update.');
//           }
//         } else if (e is DioException && e.response?.statusCode == 400) {
//           print('Update password error: $e');
//           throw Exception('Update password failed: $e');
//         } else {
//           throw Exception('Unexpected error: $e');
//         }
//       }
//     } catch (e) {
//       print('Update password error: $e');
//       throw Exception('Update password failed: $e');
//     }
//   }

//   // Function: Update Profile
//   Future<void> updateProfile(String username, String phone) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? accessToken = prefs.getString('access_token');

//       if (accessToken == null) {
//         throw Exception('No access token found. Please login again.');
//       }

//       try {
//         final response = await _dio.post(
//           updateProfileUrl,
//           data: {
//             "username": username,
//             "phone": phone,
//           },
//           options: Options(
//             headers: {'Authorization': 'Bearer $accessToken'},
//           ),
//         );

//         if (response.data['message'] == 'Profile updated successfully') {
//           print('Profile updated successfully.');
//         } else {
//           throw Exception(response.data['message']);
//         }
//       } catch (e) {
//         if (e is DioException && e.response?.statusCode == 403) {
//           print('Access token expired. Attempting to refresh...');
//           await refreshToken();

//           // Lấy token mới sau khi làm mới
//           accessToken = prefs.getString('access_token');
//           if (accessToken != null) {
//             final retryResponse = await _dio.post(
//               updateProfileUrl,
//               data: {
//                 "username": username,
//                 "phone": phone,
//               },
//               options: Options(
//                 headers: {'Authorization': 'Bearer $accessToken'},
//               ),
//             );

//             if (retryResponse.data['message'] ==
//                 'Profile updated successfully') {
//               print('Profile updated successfully after retry.');
//             } else {
//               throw Exception(retryResponse.data['message']);
//             }
//           } else {
//             throw Exception(
//                 'Failed to refresh access token for profile update.');
//           }
//         } else {
//           throw Exception('Unexpected error: $e');
//         }
//       }
//     } catch (e) {
//       print('Update profile error: $e');
//       throw Exception('Update profile failed: $e');
//     }
//   }

//   // Function: Get Profile
//   Future<Map<String, dynamic>> getUserProfile() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? accessToken = prefs.getString('access_token');

//       if (accessToken == null) {
//         throw Exception('No access token found. Please login again.');
//       }

//       try {
//         final response = await _dio.get(
//           getProfileUrl,
//           options: Options(
//             headers: {'Authorization': 'Bearer $accessToken'},
//           ),
//         );

//         return response.data;
//       } catch (e) {
//         if (e is DioException && e.response?.statusCode == 403) {
//           print('Access token expired. Attempting to refresh...');
//           await refreshToken();

//           // Lấy token mới sau khi làm mới
//           accessToken = prefs.getString('access_token');
//           if (accessToken != null) {
//             final retryResponse = await _dio.get(
//               getProfileUrl,
//               options: Options(
//                 headers: {'Authorization': 'Bearer $accessToken'},
//               ),
//             );

//             return retryResponse.data;
//           } else {
//             throw Exception(
//                 'Failed to refresh access token for fetching profile.');
//           }
//         } else {
//           throw Exception('Unexpected error: $e');
//         }
//       }
//     } catch (e) {
//       print('Get profile error: $e');
//       throw Exception('Get profile failed: $e');
//     }
//   }

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

class UserService {
  // Function: Update Password
  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    try {
      BaseQuery baseQuery = BaseQuery();
      Response postResponse = await baseQuery.post('/userInfo/update_pass/me', {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      });
      print('Change password successful: ${postResponse.data}');
      return true;
    } catch (e) {
      print('Change password error: $e');
      return false;
    }
  }

  // Function: Update Profile
  Future<bool> updateProfile(String username, String phone) async {
    try {
      BaseQuery baseQuery = BaseQuery();
      Response postResponse =
          await baseQuery.post('/userInfo/profile/update_info/me', {
        'username': username,
        'phone': phone,
      });
      print('Change profile successful: ${postResponse.data['message']}');
      return true;
    } catch (e) {
      print('Change profile error: $e');
      return false;
    }
  }

  // Function: Update Profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      BaseQuery baseQuery = BaseQuery();
      Response postResponse = await baseQuery.get('/userInfo/profile/me');

      return postResponse.data;
    } catch (e) {
      print('Get profile error: $e');
      throw Exception('Get profile failed: $e');
    }
  }
}
