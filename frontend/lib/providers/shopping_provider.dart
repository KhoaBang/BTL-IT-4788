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

  Future<void> loadShoppingLists(String groupId) async {
    // Implement API call to fetch all shopping lists for a group.
  }

  Future<bool> addShoppingList(String groupId, String name) async {
    final success = await _shoppingService.createShoppingList(groupId, name);
    if (success) {
      // Reload the shopping lists after adding a new one
      await loadShoppingLists(groupId);
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
      await loadShoppingLists(groupId);
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

  Future<void> loadTasks(String groupId) async {
    // Fetch tasks for the specific shopping list
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
}
