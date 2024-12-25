import 'package:dio/dio.dart';
import 'base_query.dart';

class IngredientService {
  final BaseQuery _baseQuery = BaseQuery();

  /// Add a new ingredient
  ///
  /// Returns the list of all ingredients including the newly added one.
  Future<List<dynamic>> addIngredient(Map<String, dynamic> ingredient) async {
    try {
      Response response = await _baseQuery.post(
        '/userInfo/store/ingredients',
        {'ingredient': ingredient},
      );
      return response.data as List<dynamic>;
    } catch (e) {
      print('Add ingredient failed: $e');
      throw Exception('Failed to add ingredient. Please try again.');
    }
  }

  /// Update an existing ingredient
  ///
  /// Returns the list of all ingredients after the update.
  Future<List<dynamic>> updateIngredient(
    String oldIngredientName,
    Map<String, dynamic> newIngredient,
  ) async {
    try {
      Response response = await _baseQuery.patch(
        '/userInfo/store/ingredients',
        {
          'old_ingredient_name': oldIngredientName,
          'new_ingredient': newIngredient,
        },
      );
      return response.data as List<dynamic>;
    } catch (e) {
      print('Update ingredient failed: $e');
      throw Exception('Failed to update ingredient. Please try again.');
    }
  }

  /// Delete an ingredient
  ///
  /// Returns the list of all ingredients after the deletion.
  Future<List<dynamic>> deleteIngredient(String ingredientName) async {
    try {
      Response response = await _baseQuery.delete(
        '/userInfo/store/ingredients',
        data: {'ingredient_name': ingredientName},
      );
      return response.data as List<dynamic>;
    } catch (e) {
      print('Delete ingredient failed: $e');
      throw Exception('Failed to delete ingredient. Please try again.');
    }
  }

  /// Get all ingredients
  ///
  /// Returns the list of all ingredients in the expected structure.
  Future<List<dynamic>> getIngredients() async {
    try {
      Response response =
          await _baseQuery.get('/userInfo/store/ingredients/me');
      return response.data as List<dynamic>;
    } catch (e) {
      print('Get ingredients failed: $e');
      throw Exception('Failed to fetch ingredients. Please try again.');
    }
  }
}
