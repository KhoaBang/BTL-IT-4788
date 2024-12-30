import '../widgets/ingredients_table.dart';
import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

class IngredientsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Header(
            //canGoBack: false,
            ),
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
