import 'package:flutter/material.dart';
import 'screens/signin_screen.dart';

void main() {
  runApp(MealPrepApp());
}

class MealPrepApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFEEA734),
        scaffoldBackgroundColor: Colors.white, // Màu nền toàn bộ mà
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFEEA734))),
          labelStyle: TextStyle(color: Colors.black),
        ),
      ),
      home: SignInScreen(),
    );
  }
}
