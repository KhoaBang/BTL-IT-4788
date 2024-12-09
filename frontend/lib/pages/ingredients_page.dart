import 'widgets/ingredients_table.dart';
import 'package:flutter/material.dart';
import 'widgets/header.dart';
import 'widgets/footer.dart';

class IngredientsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        canGoBack: true, // Enable back navigation
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
            child: IngredientsTable(),
          ),
        ],
      ),
      bottomNavigationBar: Footer(currentIndex: 2), // Adjust index if needed
    );
  }
}
