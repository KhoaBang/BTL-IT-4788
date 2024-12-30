import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../widgets/list_section.dart';
import '../widgets/create_task_dialog.dart';
import 'package:frontend/providers/group_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/shopping_provider.dart';

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
    final shoppingListNotifier = ref.read(shoppingListProvider.notifier);

    // StateProvider to manage the current name
    final nameProvider = StateProvider<String>((ref) => name);
    final currentName = ref.watch(nameProvider);

    void _deleteShoppingList() async {
      if (groupId != null) {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Delete Shopping List'),
              content: Text('Are you sure you want to delete "$currentName"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );

        if (confirm == true) {
          await shoppingListNotifier.removeShoppingList(groupId, shopping_id);
          Navigator.pop(context); // Navigate back to the previous page
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Group ID is not available')),
        );
      }
    }

    void _editShoppingList() async {
      String? newName;

      // Initialize TextEditingController with current name
      final nameController = TextEditingController(text: currentName);

      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Shopping List'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller:
                      nameController, // Set controller with current name
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter shopping list name',
                  ),
                  onChanged: (value) => newName = value,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Save', style: TextStyle(color: Colors.blue)),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        if (groupId != null) {
          await shoppingListNotifier.updateShoppingList(
            groupId,
            shopping_id,
            newName ??
                currentName, // Fallback to original name if new name is null
            null, // No status field to update
          );
          ref.read(nameProvider.notifier).state =
              newName ?? currentName; // Update local state
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Group ID is not available')),
          );
        }
      }
    }

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "List Details", // Display the updated name
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: 'Oxygen',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: _editShoppingList,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: _deleteShoppingList,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListSection(
              title: "Tasks",
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
          Footer(currentIndex: -1),
        ],
      ),
    );
  }
}
