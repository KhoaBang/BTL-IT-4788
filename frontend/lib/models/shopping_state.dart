// shopping_state.dart
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

  // Convert JSON data to ShoppingList object
  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
      gid: json['gid'] as String? ?? '', // Default to empty string if null
      shoppingId: json['shopping_id'] as String? ??
          '', // Default to empty string if null
      name: json['name'] as String? ??
          'Unnamed List', // Default to 'Unnamed List' if null
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(), // Default to current date if null or invalid format
      taskList: List<String>.from(
          json['task_list'] ?? []), // Safely handle empty or missing task list
      status: json['status'] as String? ??
          'unknown', // Default to 'unknown' if null
    );
  }

  // Convert ShoppingList object to JSON (optional, in case you need to send it to a backend)
  Map<String, dynamic> toJson() {
    return {
      'gid': gid,
      'shopping_id': shoppingId,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'task_list': taskList,
      'status': status,
    };
  }
}

// task
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
