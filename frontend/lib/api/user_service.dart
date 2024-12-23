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
      if (e is DioException && e.response?.statusCode == 400) {
        print('Change password error: $e');
      } else {
        print('Unexpected error: $e');
      }
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
