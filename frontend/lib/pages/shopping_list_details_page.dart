import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../widgets/list_section.dart';
import '../widgets/create_task_dialog.dart';
import 'package:frontend/providers/group_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShoppingListDetailPage extends ConsumerWidget {
  final String name;
  final String shopping_id;

  const ShoppingListDetailPage({
    Key? key,
    required this.name,
    required this.shopping_id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupId = ref.watch(chosenGroupProvider).GID;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Header(
          canGoBack: true,
        ),
      ),
      body: Column(
        children: [
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
              lists: [
                {"name": "Weekly Groceries", "date": "2024-12-01"},
              ],
              onAdd: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return InputDialog(
                      groupId: groupId ?? '',
                      title: 'Add new item',
                      confirmText: 'Add',
                      cancelText: 'Cancel',
                      onConfirm: (groupId, ingredientName, unitId, assignedTo,
                          quantity) {
                        print(
                            'Added: $groupId, $ingredientName, $unitId, $assignedTo, $quantity');
                      },
                    );
                  },
                );
              },
              onItemTap: (id, itemName) {
                print('Tapped item: $itemName');
              },
            ),
          ),
          Footer(currentIndex: 0),
        ],
      ),
    );
  }
}
