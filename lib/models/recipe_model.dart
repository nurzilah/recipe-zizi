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
  final UserModel user;

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

  // Factory method to create RecipeModel from JSON
  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] ?? 0, // Default value if not present
      title: json['title'] ?? 'Untitled Recipe', // Default if title is missing
      photoUrl: json['photo_url'] ?? '', // Default empty string for photo URL
      likesCount: json['likes_count'] ?? 0, // Default to 0 if likes_count is missing
      commentsCount: json['comments_count'] ?? 0, // Default to 0 if comments_count is missing
      description: json['description'] ?? 'No description available', // Default if no description
      ingredients: json['ingredients'] ?? 'No ingredients listed', // Default if no ingredients
      cookingMethod: json['cooking_method'] ?? 'No method provided', // Default if no method
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at']) // Parse the date if it's available
          : DateTime.now(), // Default to current time if no creation date is available
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at']) // Parse the update time if it's available
          : DateTime.now(), // Default to current time if no update date is available
      user: UserModel.fromJson(json['user'] ?? {}), // Handle user as an empty object if not available
    );
  }

  get comments => null;

  get likes => null;
  get username => null;

  // Convert RecipeModel object to JSON
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
      'created_at': createdAt.toIso8601String(), // Convert DateTime to string
      'updated_at': updatedAt.toIso8601String(), // Convert DateTime to string
      'user': user.toJson(), // Convert UserModel to JSON
    };
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  // Factory method to create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0, // Default value if not present
      name: json['name'] ?? 'Anonymous', // Default name if not present
      email: json['email'] ?? 'noemail@example.com', // Default email if not present
    );
  }

  // Convert UserModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
