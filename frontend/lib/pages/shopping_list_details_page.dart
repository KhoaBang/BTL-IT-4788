import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../widgets/list_section_task.dart';
import '../widgets/create_task_dialog.dart';
import 'package:frontend/providers/group_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/shopping_provider.dart';
import 'package:frontend/models/shopping_state.dart';

class ShoppingListDetailPage extends ConsumerStatefulWidget {
  final String name;
  final String shopping_id;

  const ShoppingListDetailPage({
    Key? key,
    required this.name,
    required this.shopping_id,
  }) : super(key: key);

  @override
  _ShoppingListDetailPageState createState() => _ShoppingListDetailPageState();
}

class _ShoppingListDetailPageState
    extends ConsumerState<ShoppingListDetailPage> {
  late final String shoppingId;

  @override
  void initState() {
    super.initState();
    shoppingId = widget.shopping_id;
    _loadTasks(); // Load tasks the first time the widget initializes
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTasks(); // Ensure tasks are reloaded when navigating back to this page
  }

  void _loadTasks() {
    final groupId = ref.read(chosenGroupProvider).GID;
    if (groupId != null) {
      final taskNotifier = ref.read(taskProvider(shoppingId).notifier);
      taskNotifier.loadTasks(groupId); // Load tasks
    }
  }

  void _toggleCompletion(Task task) async {
    final groupId = ref.read(chosenGroupProvider).GID;
    if (groupId != null) {
      final taskNotifier = ref.read(taskProvider(shoppingId).notifier);
      bool success = await taskNotifier.completeTask(groupId, task.taskId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task marked as completed')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark task as completed')),
        );
      }
    }
  }

  void _deleteShoppingList() async {
    final groupId = ref.read(chosenGroupProvider).GID;
    final shoppingListNotifier = ref.read(shoppingListProvider.notifier);

    if (groupId != null) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Shopping List'),
            content: Text('Are you sure you want to delete "${widget.name}"?'),
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
        await shoppingListNotifier.removeShoppingList(groupId, shoppingId);
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
    final nameController = TextEditingController(text: widget.name);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Shopping List'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController, // Set controller with current name
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
      final groupId = ref.read(chosenGroupProvider).GID;
      if (groupId != null) {
        await ref.read(shoppingListProvider.notifier).updateShoppingList(
              groupId,
              shoppingId,
              newName ??
                  widget.name, // Fallback to original name if new name is null
              null, // No status field to update
            );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Group ID is not available')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: Consumer(
              builder: (context, ref, _) {
                final taskState = ref.watch(taskProvider(shoppingId));

                return ListSection(
                  title: "Tasks",
                  tasks: taskState,
                  onAdd: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return InputDialog(
                          groupId: groupId ?? '',
                          title: 'Add new item',
                          confirmText: 'Add',
                          cancelText: 'Cancel',
                          onConfirm: (groupId, ingredientName, unitId,
                              assignedTo, quantity) async {
                            final success = await ref
                                .read(taskProvider(shoppingId).notifier)
                                .addTask(groupId, ingredientName, unitId,
                                    assignedTo, quantity);

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Task added successfully')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to add task')),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                  onItemTap: (taskId, ingredientName) {
                    print('Tapped task: $taskId - $ingredientName');
                  },
                  onEditTask: (task) {
                    // Open edit dialog
                  },
                  onDeleteTask: (task) async {
                    // Confirm before deletion
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Delete Task'),
                          content: Text(
                              'Are you sure you want to delete "${task.ingredientName}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm == true) {
                      final groupId = ref.read(chosenGroupProvider).GID;
                      if (groupId != null) {
                        await ref
                            .read(taskProvider(shoppingId).notifier)
                            .removeTask(groupId, task.taskId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Task deleted successfully')),
                        );
                      }
                    }
                  },
                  onToggleCompletion: (task, isCompleted) {
                    _toggleCompletion(task); // Handle task completion toggle
                  },
                );
              },
            ),
          ),
          Footer(currentIndex: -1),
        ],
      ),
    );
  }
}
