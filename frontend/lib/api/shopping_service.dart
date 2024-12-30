import 'package:dio/dio.dart';
import 'package:frontend/api/base_query.dart';

class ShoppingService {
  // Get all shopping lists for a group
  Future<List<dynamic>?> getAllShoppingLists(String groupId) async {
    try {
      BaseQuery baseQuery = BaseQuery();
      // Send GET request to the backend to fetch all shopping lists
      Response response = await baseQuery.get('/group/$groupId/shopping');

      if (response.statusCode == 200) {
        print('Shopping lists fetched successfully: ${response.data}');
        return response.data; // Return the list of shopping lists
      } else {
        print('Failed to fetch shopping lists: ${response.data['message']}');
        return null; // Return null if the fetch fails
      }
    } catch (e) {
      print('Error fetching shopping lists: $e');
      return null; // Return null if an error occurs
    }
  }

  // create a new shopping list
  Future<bool> createShoppingList(String groupId, String name) async {
    try {
      BaseQuery baseQuery = BaseQuery();
      // Make the POST request to the backend
      Response postResponse = await baseQuery.post(
        '/group/$groupId/shopping',
        {
          'name': name,
        },
      );

      if (postResponse.statusCode == 201) {
        print('Shopping list created: ${postResponse.data}');
        return true;
      } else {
        print('Shopping list creation failed: ${postResponse.data['message']}');
        return false;
      }
    } catch (e) {
      print('Shopping list creation error: $e');
      return false;
    }
  }

  // Get shopping list by ID
  Future<Map<String, dynamic>?> getShoppingListById(
      String groupId, String shoppingId) async {
    try {
      BaseQuery baseQuery = BaseQuery();
      // Make the GET request to the backend
      Response getResponse = await baseQuery.get(
        '/group/$groupId/shopping/$shoppingId',
      );

      if (getResponse.statusCode == 200) {
        print('Shopping list retrieved: ${getResponse.data}');
        return getResponse.data; // Return the shopping list data
      } else {
        print('Shopping list retrieval failed: ${getResponse.data['message']}');
        return null; // Return null if retrieval fails
      }
    } catch (e) {
      print('Shopping list retrieval error: $e');
      return null; // Return null in case of an error
    }
  }

  // Update shopping list by ID
  Future<bool> updateShoppingListById(
      String groupId, String shoppingId, String? name, String? status) async {
    try {
      BaseQuery baseQuery = BaseQuery();
      // Prepare the request data
      Map<String, dynamic> data = {};
      if (name != null) data['name'] = name;
      if (status != null) data['status'] = status;

      // Make the PATCH request to the backend
      Response patchResponse = await baseQuery.patch(
        '/group/$groupId/shopping/$shoppingId',
        data,
      );

      if (patchResponse.statusCode == 200) {
        print('Shopping list updated: ${patchResponse.data}');
        return true;
      } else {
        print('Shopping list update failed: ${patchResponse.data['message']}');
        return false;
      }
    } catch (e) {
      print('Shopping list update error: $e');
      return false;
    }
  }

  // Delete shopping list by ID
  Future<bool> deleteShoppingListById(String groupId, String shoppingId) async {
    try {
      BaseQuery baseQuery = BaseQuery();
      // Make the DELETE request to the backend
      Response deleteResponse = await baseQuery.delete(
        '/group/$groupId/shopping/$shoppingId',
      );

      if (deleteResponse.statusCode == 200) {
        print('Shopping list deleted: ${deleteResponse.data}');
        return true;
      } else {
        print(
            'Shopping list deletion failed: ${deleteResponse.data['message']}');
        return false;
      }
    } catch (e) {
      print('Shopping list deletion error: $e');
      return false;
    }
  }

  // Add task to shopping list
  Future<bool> addTaskToShoppingList(
      String groupId,
      String shoppingId,
      String ingredientName,
      String unitId,
      String assignedTo,
      double quantity) async {
    try {
      BaseQuery baseQuery = BaseQuery();
      // Prepare the request data
      Map<String, dynamic> data = {
        'ingredient_name': ingredientName,
        'unit_id': unitId,
        'assigned_to': assignedTo,
        'quantity': quantity,
      };

      // Make the POST request to the backend
      Response postResponse = await baseQuery.post(
        '/group/$groupId/shopping/$shoppingId/task',
        data,
      );

      if (postResponse.statusCode == 201) {
        print('Task added to shopping list: ${postResponse.data}');
        return true;
      } else {
        print('Task addition failed: ${postResponse.data['message']}');
        return false;
      }
    } catch (e) {
      print('Task addition error: $e');
      return false;
    }
  }

// get All Tasks
  Future<List<Map<String, dynamic>>> getAllTasksForShoppingList(
    String groupId,
    String shoppingId,
  ) async {
    try {
      BaseQuery baseQuery = BaseQuery();

      // Make the GET request to the backend
      Response getResponse = await baseQuery.get(
        '/group/$groupId/shopping/$shoppingId/task',
      );

      if (getResponse.statusCode == 200) {
        List<dynamic> tasks = getResponse.data;
        print('Tasks fetched: $tasks');
        return tasks.cast<Map<String, dynamic>>();
      } else {
        print('Failed to fetch tasks: ${getResponse.data['message']}');
        return [];
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }

  // Get task by ID
  Future<Map<String, dynamic>?> getTaskById(
      String groupId, String shoppingId, String taskId) async {
    try {
      BaseQuery baseQuery = BaseQuery();
      // Make the GET request to the backend
      Response getResponse = await baseQuery.get(
        '/group/$groupId/shopping/$shoppingId/task/$taskId',
      );

      if (getResponse.statusCode == 200) {
        print('Task retrieved: ${getResponse.data}');
        return getResponse.data; // Return the task data
      } else {
        print('Task retrieval failed: ${getResponse.data['message']}');
        return null; // Return null if the task retrieval fails
      }
    } catch (e) {
      print('Task retrieval error: $e');
      return null; // Return null if an error occurs
    }
  }

  // Update task by ID
  Future<bool> updateTaskById(
    String groupId,
    String shoppingId,
    String taskId,
    Map<String, dynamic> updates, // Data that needs to be updated
  ) async {
    try {
      BaseQuery baseQuery = BaseQuery();
      // Make the PATCH request to the backend
      Response patchResponse = await baseQuery.patch(
        '/group/$groupId/shopping/$shoppingId/task/$taskId',
        updates, // The data to be updated
      );

      if (patchResponse.statusCode == 200) {
        print('Task updated: ${patchResponse.data}');
        return true; // Return true if task update is successful
      } else {
        print('Task update failed: ${patchResponse.data['message']}');
        return false; // Return false if task update fails
      }
    } catch (e) {
      print('Task update error: $e');
      return false; // Return false if an error occurs
    }
  }

  // Delete a task by ID
  Future<bool> deleteTaskById(
    String groupId,
    String shoppingId,
    String taskId,
  ) async {
    try {
      BaseQuery baseQuery = BaseQuery();
      // Make the DELETE request to the backend
      Response deleteResponse = await baseQuery.delete(
        '/group/$groupId/shopping/$shoppingId/task/$taskId',
      );

      if (deleteResponse.statusCode == 200) {
        print('Task deleted: ${deleteResponse.data}');
        return true; // Return true if task deletion is successful
      } else {
        print('Task deletion failed: ${deleteResponse.data['message']}');
        return false; // Return false if task deletion fails
      }
    } catch (e) {
      print('Task deletion error: $e');
      return false; // Return false if an error occurs
    }
  }

  // Mark a task as completed
  Future<bool> memCompleteTask(
    String groupId,
    String shoppingId,
    String taskId,
  ) async {
    try {
      BaseQuery baseQuery = BaseQuery();
      // Make the PATCH request to the backend to mark the task as completed
      Response patchResponse = await baseQuery.patch(
        '/group/$groupId/shopping/$shoppingId/task/$taskId/completed',
        {}, // Pass an empty map as the request body if no data is required
      );

      if (patchResponse.statusCode == 200) {
        print('Task completed: ${patchResponse.data}');
        return true; // Return true if task completion is successful
      } else {
        print('Task completion failed: ${patchResponse.data['message']}');
        return false; // Return false if task completion fails
      }
    } catch (e) {
      print('Task completion error: $e');
      return false; // Return false if an error occurs
    }
  }
}
