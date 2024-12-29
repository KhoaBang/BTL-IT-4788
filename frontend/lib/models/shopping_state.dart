// shopping_list.dart
class ShoppingList {
  final String gid;
  final String shoppingId;
  final String name;
  final DateTime createdAt;
  final List<String> taskList; // List of task UUIDs
  final String status;

  ShoppingList({
    required this.gid,
    required this.shoppingId,
    required this.name,
    required this.createdAt,
    required this.taskList,
    required this.status,
  });
}

// task.dart
class Task {
  final String assignedTo;
  final String taskId;
  final String ingredientName;
  final int unitId;
  final String status;

  Task({
    required this.assignedTo,
    required this.taskId,
    required this.ingredientName,
    required this.unitId,
    required this.status,
  });
}
