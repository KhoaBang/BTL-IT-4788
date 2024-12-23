import 'package:flutter/material.dart';
import 'widgets/header.dart';
import 'widgets/footer.dart';
import 'widgets/members_table.dart';

class MemberTablePage extends StatelessWidget {
  final List<Map<String, String>> members;

  const MemberTablePage({Key? key, required this.members}) : super(key: key);

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
            child: ResponsiveMemberTable(members: members),
          ),
        ],
      ),
      bottomNavigationBar: Footer(currentIndex: 1), // Adjust index if needed
    );
  }
}
