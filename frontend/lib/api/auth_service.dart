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
