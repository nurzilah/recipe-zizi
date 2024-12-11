import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_pertemuan7/models/recipe_model.dart';
import 'package:flutter_pertemuan7/services/session_services.dart';

const String baseUrl = 'https://recipe.incube.id/api';

class RecipeService {
  final SessionService _sessionService = SessionService();

  // Mendapatkan semua resep
  Future<List<RecipeModel>> getAllRecipes() async {
    final token = await _sessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/recipes'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      try {
        final List data = jsonDecode(response.body)['data']['data'];
        return data.map((json) => RecipeModel.fromJson(json)).toList();
      } catch (e) {
        throw Exception("Error parsing data: $e");
      }
    } else {
      throw Exception("Failed to load recipes: ${response.reasonPhrase}");
    }
  }

  // Menambah resep baru
  Future<bool> createRecipe({
    required String title,
    required String description,
    required String cookingMethod,
    required String ingredients,
    required String photoPath,
  }) async {
    final token = await _sessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan");
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/recipes'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['cooking_method'] = cookingMethod;
    request.fields['ingredients'] = ingredients;

    if (photoPath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('photo', photoPath));
    }

    final response = await request.send();
    return response.statusCode == 201;
  }

  // Memperbarui resep
  Future<bool> updateRecipe({
    required int id,
    required String title,
    required String description,
    required String cookingMethod,
    required String ingredients,
    required String photoPath,
  }) async {
    final token = await _sessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan");
    }

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('$baseUrl/recipes/$id'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['cooking_method'] = cookingMethod;
    request.fields['ingredients'] = ingredients;

    if (photoPath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('photo', photoPath));
    }

    final response = await request.send();
    return response.statusCode == 200;
  }

  // Menghapus resep
  Future<bool> deleteRecipe(int id) async {
    final token = await _sessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan");
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/recipes/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }
}
