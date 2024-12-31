import 'package:dio/dio.dart';
import 'package:frontend/api/base_query.dart';

class MealService {
  final BaseQuery baseQuery = BaseQuery();

  // Hàm xử lý lỗi chung
  void _handleError(DioException error) {
    if (error.response != null) {
      print('Server responded with error: ${error.response?.data}');
    } else {
      print('Unexpected error: ${error.message}');
    }
  }

  // Tạo một meal mới
  Future<dynamic> createMeal(String GID, Map<String, dynamic> mealData) async {
    try {
      Response response = await baseQuery.post('/group/$GID/meals', mealData);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  // Lấy danh sách tất cả meals
  Future<List<dynamic>> getAllMeals(String GID) async {
    try {
      Response response = await baseQuery.get('/group/$GID/meals');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      _handleError(e);
      return [];
    }
  }

  // Lấy thông tin chi tiết của một meal
  Future<dynamic> getMealById(String GID, String mealId) async {
    try {
      Response response = await baseQuery.get('/group/$GID/meals/$mealId');
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  // Cập nhật thông tin của một meal
  Future<dynamic> updateMeal(
      String GID, String mealId, Map<String, dynamic> updates) async {
    try {
      Response response =
          await baseQuery.patch('/group/$GID/meals/$mealId', updates);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  // Xóa một meal
  Future<bool> deleteMeal(String GID, String mealId) async {
    try {
      Response response = await baseQuery.delete('/group/$GID/meals/$mealId');
      return response.statusCode == 200;
    } on DioException catch (e) {
      _handleError(e);
      return false;
    }
  }

  // Thêm nguyên liệu vào một meal
  Future<dynamic> addIngredientToMeal(
      String GID, String mealId, Map<String, dynamic> ingredient) async {
    try {
      Response response = await baseQuery.post(
        '/group/$GID/meals/$mealId/ingredients',
        {'ingredient': ingredient},
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  // Xóa nguyên liệu khỏi một meal
  Future<bool> removeIngredientFromMeal(
      String GID, String mealId, String ingredientId) async {
    try {
      Response response = await baseQuery.delete(
        '/group/$GID/meals/$mealId/ingredients/$ingredientId',
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      _handleError(e);
      return false;
    }
  }
}
