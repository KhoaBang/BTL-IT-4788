import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/shopping_state.dart';
import 'package:frontend/api/shopping_service.dart';

final shoppingServiceProvider =
    Provider<ShoppingService>((ref) => ShoppingService());

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<ShoppingList>>((ref) {
  final shoppingService = ref.watch(shoppingServiceProvider);
  return ShoppingListNotifier(shoppingService);
});

class ShoppingListNotifier extends StateNotifier<List<ShoppingList>> {
  final ShoppingService _shoppingService;

  ShoppingListNotifier(this._shoppingService) : super([]);

  // Load shopping lists for a specific group
  Future<void> getAllShoppingLists(String groupId) async {
    try {
      // Fetch shopping lists from the API
      List<dynamic>? shoppingListsData =
          await _shoppingService.getAllShoppingLists(groupId);

      if (shoppingListsData != null) {
        // Map the data to ShoppingList objects, handle null values
        state = shoppingListsData
            .map((data) => ShoppingList.fromJson(
                data ?? {})) // Fallback to empty map if null
            .toList();
      } else {
        print('No shopping lists found');
      }
    } catch (e) {
      print('Error loading shopping lists: $e');
    }
  }

  Future<bool> addShoppingList(String groupId, String name) async {
    final success = await _shoppingService.createShoppingList(groupId, name);
    if (success) {
      // Reload the shopping lists after adding a new one
      await getAllShoppingLists(groupId);
    }
    return success;
  }

  Future<void> removeShoppingList(String groupId, String shoppingId) async {
    final success =
        await _shoppingService.deleteShoppingListById(groupId, shoppingId);
    if (success) {
      state = state.where((list) => list.shoppingId != shoppingId).toList();
    }
  }

  Future<void> updateShoppingList(
      String groupId, String shoppingId, String? name, String? status) async {
    final success = await _shoppingService.updateShoppingListById(
        groupId, shoppingId, name, status);
    if (success) {
      await getAllShoppingLists(groupId);
    }
  }
}

//Task
final taskProvider =
    StateNotifierProvider.family<TaskNotifier, List<Task>, String>(
        (ref, shoppingId) {
  final shoppingService = ref.watch(shoppingServiceProvider);
  return TaskNotifier(shoppingService, shoppingId);
});

class TaskNotifier extends StateNotifier<List<Task>> {
  final ShoppingService _shoppingService;
  final String _shoppingId;

  TaskNotifier(this._shoppingService, this._shoppingId) : super([]);

  /// Load tasks for the specific shopping list
  Future<void> loadTasks(String groupId) async {
    try {
      // Fetch tasks from the service
      final tasksData = await _shoppingService.getAllTasksForShoppingList(
          groupId, _shoppingId);

      // Map fetched data to a list of `Task` objects
      state = tasksData.map((data) => Task.fromJson(data)).toList();
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  Future<bool> addTask(String groupId, String ingredientName, String unitId,
      String assignedTo, double quantity) async {
    final success = await _shoppingService.addTaskToShoppingList(
        groupId, _shoppingId, ingredientName, unitId, assignedTo, quantity);
    if (success) {
      await loadTasks(groupId);
    }
    return success;
  }

  Future<void> updateTask(
      String groupId, String taskId, Map<String, dynamic> updates) async {
    final success = await _shoppingService.updateTaskById(
        groupId, _shoppingId, taskId, updates);
    if (success) {
      await loadTasks(groupId);
    }
  }

  Future<void> removeTask(String groupId, String taskId) async {
    final success =
        await _shoppingService.deleteTaskById(groupId, _shoppingId, taskId);
    if (success) {
      state = state.where((task) => task.taskId != taskId).toList();
    }
  }

  // Complete a task by its taskId and update the state
  Future<bool> completeTask(String groupId, String taskId) async {
    try {
      // Call the memCompleteTask method from ShoppingService
      bool success =
          await _shoppingService.memCompleteTask(groupId, _shoppingId, taskId);

      if (success) {
        // Update the state by marking the task as completed
        state = state.map((task) {
          if (task.taskId == taskId) {
            return Task(
              assignedTo: task.assignedTo,
              email: task.email,
              taskId: task.taskId,
              ingredientName: task.ingredientName,
              unitId: task.unitId,
              status: 'completed', // Update status to 'completed'
              unit: task.unit,
              quantity: task.quantity,
            );
          }
          return task;
        }).toList();
        return true; // Return true if the task was successfully completed
      } else {
        return false; // Return false if task completion failed
      }
    } catch (e) {
      print('Error completing task: $e');
      return false; // Return false if an error occurs
    }
  }
}