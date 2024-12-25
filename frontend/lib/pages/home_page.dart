import 'package:flutter/material.dart';
import 'package:frontend/pages/widgets/header.dart';
import 'package:frontend/pages/widgets/footer.dart';

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
      bottomNavigationBar: const Footer(currentIndex: 0), // Thêm Footer vào đây
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    routes: {
      '/signIn': (context) => SignInPage(), // Placeholder for SignInPage()
    },
  ));
}

// Placeholder for SignInPage
class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Sign In Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
