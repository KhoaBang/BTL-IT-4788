import 'package:flutter/material.dart';
import 'widgets/header.dart';
import 'widgets/footer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        canGoBack: false, // Không có nút Back
        onChangeProfile: () {
          print('Change profile selected');
        },
        onLogout: () {
          print('Logout selected');
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text('Home Page Content'),
            ),
          ),
          Footer(currentIndex: 0), // Đặt currentIndex là 0
        ],
      ),
    );
  }
}
