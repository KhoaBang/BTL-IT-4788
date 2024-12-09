import 'package:flutter/material.dart';
import 'widgets/header.dart';
import 'widgets/footer.dart';
import 'widgets/confirmation_dialog.dart';
import 'widgets/input_dialog.dart';
import 'widgets/list_section.dart';
import 'widgets/list_section_noicon.dart';
import 'shopping_list_details_page.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final List<Map<String, String>> personalLists = [
    {"name": "Weekly Groceries", "date": "2024-12-01"},
    {"name": "Birthday Party Supplies", "date": "2024-12-03"},
    {"name": "Holiday Shopping", "date": "2024-12-05"},
  ];

  final List<Map<String, String>> sharedLists = [
    {"name": "Family Shopping", "date": "2024-11-28"},
    {"name": "Office Party Planning", "date": "2024-11-30"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        canGoBack: false,
        onChangeProfile: () {
          print('Change profile selected');
        },
        onLogout: () {
          print('Logout selected');
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Your Shopping Lists",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Oxygen',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: [
                ListSection(
                  title: "Personal Lists",
                  lists: personalLists,
                  onAdd: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return InputDialog(
                          title: 'Create new shopping list',
                          hintText: 'Type list name here',
                          confirmText: 'Create',
                          cancelText: 'Cancel',
                          onConfirm: (input) {
                            print('New personal list created: $input');
                          },
                        );
                      },
                    );
                  },
                  onItemTap: (list) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ShoppingListDetailPage(listName: list),
                      ),
                    );
                  },
                ),
                SizedBox(height: 32),
                ListSectionNoicon(
                  title: "Shared Lists",
                  lists: sharedLists,
                  onItemTap: (list) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ShoppingListDetailPage(listName: list),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Footer(currentIndex: -1),
        ],
      ),
    );
  }
}
