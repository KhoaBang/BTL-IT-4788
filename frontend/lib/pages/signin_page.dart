import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/api/api_service.dart'; // Đảm bảo import đúng đường dẫn

import 'signup_page.dart';
import 'home_page.dart'; // Giả sử đây là trang HomePage

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Hiển thị trạng thái tải
  String? _emailError;
  String? _passwordError;

  // Hàm xử lý logic đăng nhập
  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Kiểm tra dữ liệu hợp lệ
    if (!email.endsWith("@gmail.com")) {
      setState(() {
        _emailError = "Email must end with @gmail.com";
      });
      return;
    }
    if (password.length < 8) {
      setState(() {
        _passwordError = "Password must be at least 8 characters long";
      });
      return;
    }

    setState(() {
      _isLoading = true; // Hiển thị trạng thái tải
    });

    try {
      final response = await ApiService()
          .login(email, password); // Gọi hàm login từ api_service.dart

      // Lưu token vào SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', response['data']['access_token']);
      await prefs.setString('refresh_token', response['data']['refresh_token']);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Login Successful!')),
      // );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
      // Chuyển đến HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage()), // Giả sử HomePage đã có
      );
    } catch (error) {
      // Xử lý lỗi kết nối
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$error')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Ẩn trạng thái tải
      });
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign In',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome to MealPrep",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w200,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter your Email address and Password for sign in.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),

            // Email Field
            const Text(
              "EMAIL ADDRESS",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            TextField(
              controller: _emailController,
              onChanged: (value) {
                setState(() {
                  _emailError = value.endsWith("@gmail.com")
                      ? null
                      : "Email must end with @gmail.com";
                });
              },
              decoration: InputDecoration(
                hintText: "abc@gmail.com",
                suffixIcon:
                    _emailError == null && _emailController.text.isNotEmpty
                        ? const Icon(Icons.check, color: Colors.orange)
                        : null,
                errorText: _emailError,
              ),
            ),
            const SizedBox(height: 16.0),

            // Password Field
            const Text(
              "PASSWORD",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              onChanged: (value) {
                setState(() {
                  _passwordError = value.length < 8
                      ? "Password must be at least 8 characters long"
                      : null;
                });
              },
              decoration: InputDecoration(
                hintText: "********",
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                errorText: _passwordError,
              ),
            ),
            const SizedBox(height: 16.0),

            // SIGN IN Button
            Center(
              child: GestureDetector(
                onTap: _isLoading ? null : _login,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                  decoration: BoxDecoration(
                    color: _isLoading ? Colors.grey : Colors.yellow[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "SIGN IN",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Don't have account? Text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: _navigateToRegister,
                  child: const Text(
                    'Create New Account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFEEA734),
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
