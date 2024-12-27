import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class ApiUser {
  static late final String _baseUrl = _initializeBaseUrl();

  static String _initializeBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:9000/api'; // Web
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:9000/api'; // Android Emulator
    } else {
      return 'http://localhost:9000/api'; // Other platforms
    }
  }

  // Get all ingredients of a user
  Future<List<Map<String, String>>> getUserIngredients() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    if (accessToken == null) throw Exception('Access token missing');

    final url = Uri.parse("$_baseUrl/userInfo/store/ingredients/me");
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map<Map<String, String>>((item) {
        final name = item['ingredient_name'] as String;
        final unit = item['unit'] != null
            ? item['unit']['unit_name'] as String
            : 'Unknown';
        final unitid = item['unit']['id'].toString();

        return {
          "Name": name,
          "Unit": unit,
          "UnitId": unitid,
        };
      }).toList();
    } else {
      throw Exception("Failed to fetch ingredients: ${response.body}");
    }
  }

  // Create a new ingredient
  Future<void> createIngredient({
    required String ingredientName,
    required int unitId, // The unit ID selected by the user
    List<Map<String, String>>? tags,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    if (accessToken == null) throw Exception('Access token missing');

    final url = Uri.parse("$_baseUrl/userInfo/store/ingredients");
    final body = {
      "ingredient": {
        "ingredient_name": ingredientName,
        "unit_id": unitId,
        "tags": tags ?? [],
      }
    };

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to create ingredient: ${response.body}");
    }
  }

  // New deleteIngredient function
  Future<void> deleteIngredient({required String ingredientName}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    if (accessToken == null) throw Exception('Access token missing');

    final url = Uri.parse("$_baseUrl/userInfo/store/ingredients");
    final body = {
      "ingredient_name": ingredientName,
    };

    final response = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete ingredient: ${response.body}");
    }
  }

  // New updateIngredient function
  Future<void> updateIngredient({
    required String oldIngredientName,
    required String newIngredientName,
    required int unitId,
    required List<Map<String, String>> tags,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    if (accessToken == null) throw Exception('Access token missing');

    final url = Uri.parse("$_baseUrl/userInfo/store/ingredients");
    final body = {
      "old_ingredient_name": oldIngredientName,
      "new_ingredient": {
        "ingredient_name": newIngredientName,
        "unit_id": unitId,
        "tags": tags,
      },
    };

    final response = await http.patch(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update ingredient: ${response.body}");
    }
  }
}
