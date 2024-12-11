class RecipeModel {
  final int id;
  final String title;
  final String photoUrl;
  final int likesCount;
  final int commentsCount;
  final String description;
  final String ingredients;
  final String cookingMethod;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModel user; // Hubungan dengan user yang membuat resep

  RecipeModel({
    required this.id,
    required this.title,
    required this.photoUrl,
    required this.likesCount,
    required this.commentsCount,
    required this.description,
    required this.ingredients,
    required this.cookingMethod,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  // Fungsi untuk membuat objek dari JSON
  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'],
      title: json['title'],
      photoUrl: json['photo_url'],
      likesCount: json['likes_count'],
      commentsCount: json['comments_count'],
      description: json['description'],
      ingredients: json['ingredients'],
      cookingMethod: json['cooking_method'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: UserModel.fromJson(json['user']), // Parsing data user
    );
  }

  // Fungsi untuk mengonversi objek ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'photo_url': photoUrl,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'description': description,
      'ingredients': ingredients,
      'cooking_method': cookingMethod,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user.toJson(), // Konversi objek user ke JSON
    };
  }
}

// Model untuk data user
class UserModel {
  final int id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  // Fungsi untuk membuat objek User dari JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  // Fungsi untuk mengonversi objek User ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
