import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../widgets/list_section.dart';
import '../widgets/create_task_dialog.dart';

class ShoppingListDetailPage extends StatelessWidget {
  final String name;
  final String shopping_id;

  const ShoppingListDetailPage({
    Key? key,
    required this.name,
    required this.shopping_id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example items in the shopping list
    final List<Map<String, String>> items = [
      {"name": "Weekly Groceries", "date": "2024-12-01"},
      {"name": "Birthday Party Supplies", "date": "2024-12-03"},
      {"name": "Holiday Shopping", "date": "2024-12-05"},
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Header(
          canGoBack: true, // Allow navigation back
        ),
      ),
      body: Column(
        children: [
          // Page Title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "$name Details",
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
              title: "Items in $name",
              lists: items,
              onAdd: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return InputDialog(
                      title: 'Add new item',
                      hintText: 'Fill in the details',
                      confirmText: 'Add',
                      cancelText: 'Cancel',
                      onConfirm: (groupId, ingredientName, unitId, assignedTo,
                          quantity) {
                        // Handle adding new item logic
                        print(
                            'New item added: Group ID=$groupId, Ingredient Name=$ingredientName, Unit ID=$unitId, Assigned To=$assignedTo, Quantity=$quantity');
                      },
                    );
                  },
                );
              },
              onItemTap: (id, itemName) {
                // Handle item tap
                print('Tapped on item: $itemName with id: $id');
              },
            ),
          ),
          Footer(currentIndex: 0), // Update index to match the detail page
        ],
      ),
    );
  }
}
