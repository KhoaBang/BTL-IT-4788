import 'package:flutter/material.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/footer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Header(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Home Page!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('This is a simple Home Page!')),
                );
              },
              child: Text('Click Me'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(
        currentIndex: 0,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    routes: {
      '/signIn': (context) => SignInPage(),
    },
  ));
}

// SignInPage widget now correctly places Footer inside Scaffold
class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Center(
        child: Text(
          'Sign In Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: Footer(
        currentIndex: 1, // Adjust according to your navigation logic
      ),
    );
  }
}
