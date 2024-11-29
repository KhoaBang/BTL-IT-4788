import 'package:flutter/material.dart';
import 'signup_page.dart';

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _emailError;
  String? _passwordError;

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    print('Email: $email, Password: $password');
    // Thêm logic xác thực tại đây
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
        title: const Text('Sign In', style: TextStyle(fontSize: 20),),
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
            const SizedBox(height: 16.0),

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
            const SizedBox(height: 16.0),

            // SIGN IN Button
            Center(
              child: GestureDetector(
                onTap: _login,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                  decoration: BoxDecoration(
                    color: Colors.yellow[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
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
