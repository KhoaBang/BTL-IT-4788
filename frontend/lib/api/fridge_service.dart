import 'package:dio/dio.dart';
import 'package:frontend/api/base_query.dart';

class FridgeService {
  final BaseQuery baseQuery = BaseQuery();

  // Hàm xử lý lỗi chung
  void _handleError(DioError error) {
    if (error.response != null) {
      print('Server responded with error: ${error.response?.data}');
    } else {
      print('Unexpected error: ${error.message}');
    }
  }

  // Thêm nguyên liệu vào tủ lạnh
  Future<List<dynamic>> addIngredientToFridge(
      String GID, Map<String, dynamic> ingredient) async {
    try {
      Response response = await baseQuery.post('/group/$GID/fridge', {
        'ingredient': ingredient,
      });

      return response.data;
    } on DioError catch (e) {
      _handleError(e);
      return [];
    }
  }

  // Lấy danh sách nguyên liệu từ tủ lạnh
  Future<List<dynamic>> getFridge(String GID) async {
    try {
      Response response = await baseQuery.get('/group/$GID/fridge');
      return response.data;
    } on DioError catch (e) {
      _handleError(e);
      return [];
    }
  }

  // Chỉnh sửa nguyên liệu trong tủ lạnh
  Future<List<dynamic>> updateIngredient(String GID, String oldIngredientName,
      Map<String, dynamic> updatedIngredient) async {
    try {
      Response response = await baseQuery.patch('/group/$GID/fridge', {
        'old_ingredient_name': oldIngredientName,
        'ingredient': updatedIngredient,
      });
      return response.data;
    } on DioError catch (e) {
      _handleError(e);
      return [];
    }
  }

  // Xóa nguyên liệu khỏi tủ lạnh
  Future<List<dynamic>> deleteIngredient(
      String GID, String ingredientName) async {
    try {
      Response response = await baseQuery.delete('/group/$GID/fridge', data: {
        'ingredient_name': ingredientName,
      });
      return response.data;
    } on DioError catch (e) {
      _handleError(e);
      return [];
    }
  }

  // Tiêu thụ nguyên liệu trong tủ lạnh
  Future<List<dynamic>> consumeIngredient(
      String GID, String ingredientName, int quantity) async {
    try {
      Response response = await baseQuery.patch('/group/$GID/fridge/consume', {
        'ingredient_name': ingredientName,
        'quantity': quantity,
      });
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
      return [];
    }
  }
}
