import 'package:flutter/material.dart';
import 'widgets/header.dart';
import 'widgets/footer.dart';
import 'widgets/list_section.dart';
import 'widgets/input_dialog.dart';

class ShoppingListDetailPage extends StatelessWidget {
  final String listName;

  const ShoppingListDetailPage({Key? key, required this.listName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example items in the shopping list
    final List<Map<String, String>> items = [
      {"name": "Weekly Groceries", "date": "2024-12-01"},
      {"name": "Birthday Party Supplies", "date": "2024-12-03"},
      {"name": "Holiday Shopping", "date": "2024-12-05"},
    ];

    return Scaffold(
      appBar: Header(
        canGoBack: true,
        onChangeProfile: () {
          print('Change profile selected');
        },
        onLogout: () {
          print('Logout selected');
        },
      ),
      body: Column(
        children: [
          // Page Title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "$listName Details",
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
            child: ListSection(
              title: "Items in $listName",
              lists: items,
              onAdd: () {
                // Add new items to the list
                showDialog(
                  context: context,
                  builder: (context) {
                    return InputDialog(
                      title: 'Add new item',
                      hintText: 'Type item name here',
                      confirmText: 'Add',
                      cancelText: 'Cancel',
                      onConfirm: (input) {
                        print('New item added: $input');
                      },
                    );
                  },
                );
              },
              onItemTap: (item) {
                print('Tapped on item: $item');
                // Handle item tap (e.g., show details or edit item)
              },
            ),
          ),
          Footer(currentIndex: 0), // Update index to match detail page
        ],
      ),
    );
  }
}
