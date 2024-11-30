import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'signin_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(); // Phone Number Controller
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false; // Điều khiển hiển thị mật khẩu
  String? _fullNameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  bool _isLoading = false; // Trạng thái tải

  Future<void> _registerUser() async {
  final fullName = _fullNameController.text;
  final email = _emailController.text;
  final phone = _phoneController.text;
  final password = _passwordController.text;

  // Kiểm tra dữ liệu hợp lệ
  if (fullName.isEmpty) {
    setState(() {
      _fullNameError = "Full name cannot be empty";
    });
    return;
  }
  if (!email.endsWith("@gmail.com")) {
    setState(() {
      _emailError = "Email must end with @gmail.com";
    });
    return;
  }
  if (phone.length < 10 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
    setState(() {
      _phoneError = "Phone number must be at least 10 digits";
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
    final payload = {
      'username': fullName,
      'email': email,
      'phone': phone,
      'password': password,
    };

    print('Request Payload: ${jsonEncode(payload)}');

    final response = await http.post(
      Uri.parse('http://localhost:9000/api/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(payload),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData['email'] == email) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Registration failed!')),
        );
      }
    } else if (response.statusCode == 400) {
      final responseData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'] ?? 'Invalid request data')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong! Please try again later.')),
      );
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $error')),
    );
  } finally {
    setState(() {
      _isLoading = false; // Ẩn trạng thái tải
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Sign up",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title "Create Account"
            const Text(
              "Create Account",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildRichText(context),
            const SizedBox(height: 24),

            // Full Name Field
            const Text(
              "FULL NAME",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            TextField(
              controller: _fullNameController,
              onChanged: (value) {
                setState(() {
                  _fullNameError = value.isNotEmpty ? null : "Full name cannot be empty";
                });
              },
              decoration: InputDecoration(
                hintText: "Your full name",
                suffixIcon: _fullNameError == null && _fullNameController.text.isNotEmpty
                    ? const Icon(Icons.check, color: Colors.orange)
                    : null,
              ),
            ),
            if (_fullNameError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _fullNameError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),

            // Email Address Field
            const Text(
              "EMAIL ADDRESS",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            TextField(
              controller: _emailController,
              onChanged: (value) {
                setState(() {
                  _emailError = value.endsWith("@gmail.com") ? null : "Email must end with @gmail.com";
                });
              },
              decoration: InputDecoration(
                hintText: "abc@gmail.com",
                suffixIcon: _emailError == null && _emailController.text.isNotEmpty
                    ? const Icon(Icons.check, color: Colors.orange)
                    : null,
              ),
            ),
            if (_emailError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _emailError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),

            // Phone Number Field
            const Text(
              "PHONE NUMBER",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            TextField(
              controller: _phoneController,
              onChanged: (value) {
                setState(() {
                  _phoneError = (value.length >= 10 && RegExp(r'^[0-9]+$').hasMatch(value))
                      ? null
                      : "Phone number must be at least 10 digits";
                });
              },
              decoration: InputDecoration(
                hintText: "Your phone number",
                suffixIcon: _phoneError == null && _phoneController.text.isNotEmpty
                    ? const Icon(Icons.check, color: Colors.orange)
                    : null,
              ),
            ),
            if (_phoneError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _phoneError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),

            // Password Field
            const Text(
              "PASSWORD",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
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
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
            const SizedBox(height: 30),

            // SIGN UP Button
            Center(
              child: GestureDetector(
                onTap: _isLoading
                    ? null
                    : () {
                        _registerUser();
                      },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                  decoration: BoxDecoration(
                    color: _isLoading ? Colors.grey : Colors.yellow[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "SIGN UP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Terms and Conditions Text
            Center(
              child: Text(
                "By signing up you agree to our Terms, Conditions & Privacy Policy.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // RichText Widget
  Widget _buildRichText(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        children: [
          const TextSpan(
            text: "Enter your Name, Email, Phone, and Password for sign up. ",
          ),
          TextSpan(
            text: "Already have an account?",
            style: const TextStyle(
              color: Color(0xFFEEA734),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                );
              },
          ),
        ],
      ),
    );
  }
}
