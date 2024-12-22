import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../widgets/recipe_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final RecipeService _recipeService = RecipeService();
  List<Recipe> _favoriteRecipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteRecipes();
  }

  Future<void> _loadFavoriteRecipes() async {
    setState(() => _isLoading = true);
    _favoriteRecipes = await _recipeService.getFavoriteRecipes();
    setState(() => _isLoading = false);
  }

  Future<void> _toggleFavorite(Recipe recipe) async {
    try {
      final newStatus = await _recipeService.toggleFavorite(recipe.id);
      if (!newStatus) {
        // If removed from favorites
        await _loadFavoriteRecipes(); // Reload the favorites list
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'មុខម្ហូបដែលូលចិត្ត',
          style: TextStyle(fontFamily: 'Chenla'),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteRecipes.isEmpty
              ? const Center(
                  child: Text(
                    'មិនមានមុខម្ហូបដែលចូលចិត្តទេ',
                    style: TextStyle(fontFamily: 'Chenla', fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _favoriteRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _favoriteRecipes[index];
                    recipe.isFavorite = true;
                    return RecipeCard(
                      recipe: recipe,
                      animation: const AlwaysStoppedAnimation(1.0),
                      onFavoriteToggle: _toggleFavorite,
                      onRatingTap: (recipe, rating) async {
                        await _recipeService.rateRecipe(
                            recipe.id, rating, context);
                        await _loadFavoriteRecipes();
                      },
                    );
                  },
                ),
    );
  }
}
