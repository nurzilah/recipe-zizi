import 'package:flutter/material.dart';
import 'package:flutter_pertemuan7/models/recipe_model.dart';
import 'package:flutter_pertemuan7/services/detail_services.dart';

class RecipeDetailScreen extends StatefulWidget {
  // ID resep, status awal bintang (like), dan jumlah like dari halaman sebelumnya
  final int recipeId;
  final bool initialIsLiked;
  final int initialLikesCount;

  // Constructor untuk menerima data dari layar sebelumnya (Home Screen)
  RecipeDetailScreen({
    required this.recipeId,
    required this.initialIsLiked,
    required this.initialLikesCount,
  });

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  // Future untuk mengambil data detail resep
  late Future<RecipeModel> recipeDetail;
  // Instance service untuk mendapatkan data dari API atau sumber data
  final RecipeService _recipeService = RecipeService();

  // Variabel untuk melacak status bintang dan jumlah like
  late bool _isLiked;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    // Inisialisasi status awal bintang dan jumlah like dari data yang diterima
    _isLiked = widget.initialIsLiked;
    _likesCount = widget.initialLikesCount;

    // Fetch detail resep berdasarkan ID
    recipeDetail = _recipeService.getRecipeById(widget.recipeId);
  }

  // Fungsi untuk mengubah status bintang dan mengupdate jumlah like
  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked; // Toggle status bintang
      // Update jumlah like berdasarkan status bintang
      if (_isLiked) {
        _likesCount += 1;
      } else {
        _likesCount -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        // Tombol kembali yang mengirimkan data status bintang dan jumlah like
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, {
              'isLiked': _isLiked,
              'likesCount': _likesCount,
            });
          },
        ),
      ),
      body: FutureBuilder<RecipeModel>(
        future: recipeDetail, // Future untuk mendapatkan detail resep
        builder: (context, snapshot) {
          // Jika masih menunggu data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Jika terjadi error saat fetch data
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Jika tidak ada data
          else if (!snapshot.hasData) {
            return Center(child: Text('Tidak ada data'));
          }
          // Jika data berhasil didapatkan
          else {
            final recipe = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar Resep
                    Image.network(recipe.photoUrl),
                    SizedBox(height: 16),

                    // Judul Resep
                    Text(
                      recipe.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Bagian Like dan Comment
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _toggleLike, // Toggle bintang ketika ditekan
                          child: Icon(
                            _isLiked ? Icons.star : Icons.star_border,
                            color: _isLiked ? Colors.yellow : Colors.grey, // Warna bintang
                          ),
                        ),
                        SizedBox(width: 4),
                        // Jumlah likes
                        Text("$_likesCount likes"),
                        SizedBox(width: 16),
                        Icon(Icons.comment),
                        SizedBox(width: 4),
                        // Jumlah komentar
                        Text("${recipe.commentsCount} comments"),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Deskripsi Resep
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(recipe.description),
                    SizedBox(height: 16),

                    // Bahan-bahan Resep (Ingredients)
                    Text(
                      'Ingredients',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(recipe.ingredients),
                    SizedBox(height: 16),

                    // Langkah-langkah Memasak (Steps)
                    Text(
                      'Steps',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(recipe.cookingMethod),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
