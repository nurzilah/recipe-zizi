import 'dart:convert'; 
import 'package:flutter_pertemuan7/models/recipe_model.dart'; 
import 'package:flutter_pertemuan7/services/session_services.dart'; 
import 'package:http/http.dart' as http; 

class RecipeService {
  final SessionService _sessionService = SessionService(); // Menginisialisasi layanan sesi untuk mengelola token pengguna.
  static const String baseUrl = 'https://recipe.incube.id/api'; // URL dasar API.

  // Fungsi untuk mengambil data resep berdasarkan ID
  Future<RecipeModel> getRecipeById(int recipeId) async {
    // Mendapatkan token dari layanan sesi
    final token = await _sessionService.getToken();

    // Jika token tidak ditemukan, lemparkan exception
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan");
    }

    // Melakukan permintaan GET ke endpoint API menggunakan HTTP
    final response = await http.get(
      Uri.parse('$baseUrl/recipes/$recipeId'), // Endpoint untuk mengambil data resep tertentu.
      headers: {
        'Authorization': 'Bearer $token', // Menambahkan token otorisasi dalam header.
        'Content-Type': 'application/json', // Menentukan jenis konten dalam permintaan.
      },
    );

    // Mengevaluasi status kode dari respons HTTP
    if (response.statusCode == 200) {
      // Jika berhasil (200 OK), decode body respons menjadi JSON
      final data = jsonDecode(response.body)['data'];

      // Mengonversi data JSON menjadi objek RecipeModel dan mengembalikannya
      return RecipeModel.fromJson(data);
    } else if (response.statusCode == 404) {
      // Jika API mengembalikan 404, lemparkan exception bahwa resep tidak ditemukan
      throw Exception("Resep tidak ditemukan");
    } else {
      // Jika status lainnya, lemparkan exception untuk kegagalan lainnya
      throw Exception("Gagal memuat resep");
    }
  }
}