import 'package:flutter/material.dart';
import 'package:flutter_pertemuan7/models/recipe_model.dart';
import 'package:flutter_pertemuan7/services/recipe_services.dart';
import 'package:flutter_pertemuan7/services/session_services.dart';
import 'package:flutter_pertemuan7/ui/edit_recipe_screen.dart';
import 'package:flutter_pertemuan7/ui/add_recipe_screen.dart';
import 'package:flutter_pertemuan7/ui/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _recipeService = RecipeService();
  final SessionService _sessionService = SessionService();
  late Future<List<RecipeModel>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = _recipeService.getAllRecipes();
  }

  void _logout() async {
    await _sessionService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<List<RecipeModel>>(
        future: futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureRecipes = _recipeService.getAllRecipes();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes available'));
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 2 / 2.5,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final recipe = snapshot.data![index];
                return LikeableRecipeCard(
                  recipe: recipe,
                  onDeleted: () {
                    setState(() {
                      futureRecipes = _recipeService.getAllRecipes(); // Update after delete/edit
                    });
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
          ).then((value) {
            if (value == true) {
              setState(() {
                futureRecipes = _recipeService.getAllRecipes(); // Update after adding new recipe
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


class LikeableRecipeCard extends StatefulWidget {
  final RecipeModel recipe;
  final VoidCallback onDeleted;

  const LikeableRecipeCard({Key? key, required this.recipe, required this.onDeleted}) : super(key: key);

  @override
  State<LikeableRecipeCard> createState() => _LikeableRecipeCardState();
}

class _LikeableRecipeCardState extends State<LikeableRecipeCard> {
  final RecipeService _recipeService = RecipeService();
  bool isLiked = false;

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void _deleteRecipe() async {
    try {
      final success = await _recipeService.deleteRecipe(widget.recipe.id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recipe deleted successfully')),
        );
        widget.onDeleted();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete recipe: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              child: widget.recipe.photoUrl.isNotEmpty
                  ? Image.network(
                      widget.recipe.photoUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : const Icon(
                      Icons.image,
                      size: 50,
                      color: Colors.grey,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.recipe.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Like Section
                    GestureDetector(
                      onTap: _toggleLike,
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: isLiked ? Colors.amber : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text('${widget.recipe.likesCount}'),
                        ],
                      ),
                    ),
                    // Comment Section
                    Row(
                      children: [
                        const Icon(Icons.comment, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('${widget.recipe.commentsCount}'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Edit and Delete Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditRecipeScreen(
                              recipeId: widget.recipe.id,
                              initialTitle: widget.recipe.title,
                              initialDescription: widget.recipe.description,
                              initialCookingMethod: widget.recipe.cookingMethod,
                              initialIngredients: widget.recipe.ingredients,
                              initialPhotoUrl: widget.recipe.photoUrl,
                            ),
                          ),
                        ).then((value) {
                          if (value == true) {
                            widget.onDeleted();
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: _deleteRecipe,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
