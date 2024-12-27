import 'package:dio/dio.dart';
import 'base_query.dart';

class RecipeService {
  final BaseQuery _baseQuery = BaseQuery();

  /// Add a new recipe
  Future<Map<String, dynamic>> addRecipe(Map<String, dynamic> recipe) async {
    const String url = '/userInfo/store/recipe';
    try {
      Response response = await _baseQuery.post(url, {'recipe': recipe});
      return response.data;
    } catch (e) {
      print('Error adding recipe: $e');
      throw Exception('Failed to add recipe.');
    }
  }

  /// Update an existing recipe
  Future<Map<String, dynamic>> updateRecipe(
      String oldRecipeName, Map<String, dynamic> newRecipe) async {
    const String url = '/userInfo/store/recipe';
    try {
      Response response = await _baseQuery.put(url, {
        'old_recipe_name': oldRecipeName,
        'new_recipe': newRecipe,
      });
      return response.data;
    } catch (e) {
      print('Error updating recipe: $e');
      throw Exception('Failed to update recipe.');
    }
  }

  /// Delete a recipe
  Future<Map<String, dynamic>> deleteRecipe(String recipeName) async {
    const String url = '/userInfo/store/recipe';
    try {
      Response response =
          await _baseQuery.delete(url, data: {'recipe_name': recipeName});
      return response.data;
    } catch (e) {
      print('Error deleting recipe: $e');
      throw Exception('Failed to delete recipe.');
    }
  }

  /// Get all recipes
  Future<List<Map<String, dynamic>>> getAllRecipes() async {
    const String url = '/userInfo/store/recipe?getAll=true';
    try {
      Response response = await _baseQuery.get(url);
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('Error fetching recipes: $e');
      throw Exception('Failed to fetch recipes.');
    }
  }
}
