import 'package:flutter/material.dart';
import 'package:frontend/pages/widgets/header.dart';
import 'package:frontend/pages/widgets/footer.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Header(),
      ),
      body: Center(
        child: Text(
          "GroupPage",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: const Footer(currentIndex: 1), // Thêm Footer tại đây
    );
  }
}
