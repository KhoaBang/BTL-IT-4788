import 'package:flutter/material.dart';
import 'register_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    print('Email: $email, Password: $password');
    // Thêm logic xác thực tại đây
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerLeft, // Căn lề trái
              child: Text(
                "Welcome to MealPrep",
                style: TextStyle(
                    fontSize: 40.0, // Kích thước chữ (đơn vị pixel)
                    fontWeight: FontWeight.w200),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft, // Căn lề trái
              child: Text(
                "Enter your Email address and Password for sign in.",
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.green),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              cursorColor: Colors.green,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEEA734),
                padding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: screenWidth * 0.2), // Responsive padding
                minimumSize:
                    Size(screenWidth * 0.8, 15), // Responsive minimum size
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Text(
                'Login',
                selectionColor: Colors.white,
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft, // Căn lề trái
                  child: Text(
                    "Don't have account?",
                    style: TextStyle(
                      fontSize: 10.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                    alignment: Alignment.centerLeft, // Căn lề trái
                    child: TextButton(
                      onPressed: _navigateToRegister,
                      child: Text(
                        'Create New Account',
                        style: TextStyle(
                            fontSize: 10.0,
                            color: Color(0xFFEEA734),
                            fontWeight: FontWeight.w100),
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
