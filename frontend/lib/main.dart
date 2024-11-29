import 'package:flutter/material.dart';
import 'pages/signin_page.dart' as signin_page;  // Sử dụng alias cho SignInPage
// import 'pages/signup_page.dart' as signup_page;  // Sử dụng alias cho SignUpPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Sử dụng alias để tránh xung đột
      home: signin_page.SignInPage(),  // Dùng alias signin_page.SignInPage
    );
  }
}
