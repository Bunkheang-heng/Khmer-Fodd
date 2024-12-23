import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recipe.dart';
import 'package:flutter/material.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Recipe>> loadRecipes() async {
    QuerySnapshot snapshot = await _firestore.collection('recipes').get();
    return snapshot.docs
        .map((doc) =>
            Recipe.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> rateRecipe(
      String recipeId, double rating, BuildContext context) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final recipeRef = _firestore.collection('recipes').doc(recipeId);
    final userRatingRef =
        _firestore.collection('ratings').doc('${recipeId}_${user.uid}');

    try {
      await _firestore.runTransaction((transaction) async {
        final recipeDoc = await transaction.get(recipeRef);
        final currentRating = recipeDoc.data()?['rating'] ?? 0.0;
        final currentCount = recipeDoc.data()?['ratingCount'] ?? 0;

        final newRating =
            ((currentRating * currentCount) + rating) / (currentCount + 1);

        transaction.set(userRatingRef, {
          'userId': user.uid,
          'recipeId': recipeId,
          'rating': rating,
          'timestamp': FieldValue.serverTimestamp(),
        });

        transaction.update(recipeRef, {
          'rating': newRating,
          'ratingCount': currentCount + 1,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('អរគុណសម្រាប់ការវាយតម្លៃ!',
              style: TextStyle(fontFamily: 'Chenla')),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('មានបញ្ហាក្នុងការវាយតម្លៃ',
              style: TextStyle(fontFamily: 'Chenla')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> toggleFavorite(String recipeId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    try {
      final userRef = _firestore.collection('users').doc(user.uid);
      final userDoc = await userRef.get();
      List<String> favorites =
          List<String>.from(userDoc.data()?['favorites'] ?? []);

      // Toggle the favorite status
      final willBeFavorite = !favorites.contains(recipeId);

      if (willBeFavorite) {
        favorites.add(recipeId);
      } else {
        favorites.remove(recipeId);
      }

      // Update Firestore
      await userRef.update({'favorites': favorites});

      // Return the new status
      return willBeFavorite;
    } catch (e) {
      print('Error toggling favorite: $e');
      rethrow;
    }
  }

  Future<bool> isFavorite(String recipeId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      final favorites = List<String>.from(userDoc.data()?['favorites'] ?? []);
      return favorites.contains(recipeId);
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  Future<void> loadFavoriteStatus(Recipe recipe) async {
    try {
      final isFav = await isFavorite(recipe.id);
      recipe.isFavorite = isFav;
    } catch (e) {
      print('Error loading favorite status: $e');
      recipe.isFavorite = false;
    }
  }

  Future<List<Recipe>> getFavoriteRecipes() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final favorites = List<String>.from(userDoc.data()?['favorites'] ?? []);

      if (favorites.isEmpty) return [];

      final recipeDocs = await _firestore
          .collection('recipes')
          .where(FieldPath.documentId, whereIn: favorites)
          .get();

      final recipes = recipeDocs.docs
          .map((doc) =>
              Recipe.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      for (var recipe in recipes) {
        recipe.isFavorite = true;
      }

      return recipes;
    } catch (e) {
      print('Error getting favorite recipes: $e');
      return [];
    }
  }

  Future<List<Recipe>> loadRecipesWithFilters({
    String? timeFilter,
    double? ratingFilter,
    String? tagFilter,
  }) async {
    try {
      Query query = _firestore.collection('recipes');

      // Default sorting if no time filter is selected
      if (timeFilter == null || timeFilter == 'Newest') {
        query = query.orderBy('createdAt', descending: true);
      } else {
        switch (timeFilter) {
          case 'Oldest':
            query = query.orderBy('createdAt', descending: false);
            break;
          case 'Trading':
            query = query.orderBy('favoriteCount', descending: true).orderBy(
                'createdAt',
                descending: true); // Secondary sort for equal counts
            break;
        }
      }

      // Execute base query
      var snapshot = await query.get();
      var recipes = snapshot.docs
          .map((doc) =>
              Recipe.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      // Apply tag filter if selected
      if (tagFilter != null && tagFilter != 'All') {
        recipes = recipes
            .where((recipe) => recipe.tags
                .any((tag) => tag.toLowerCase() == tagFilter.toLowerCase()))
            .toList();
      }

      // Apply rating filter if selected
      if (ratingFilter != null) {
        recipes =
            recipes.where((recipe) => recipe.rating >= ratingFilter).toList();
      }

      // Load favorite status for filtered recipes
      for (var recipe in recipes) {
        await loadFavoriteStatus(recipe);
      }

      return recipes;
    } catch (e) {
      print('Error loading recipes with filters: $e');
      return [];
    }
  }
}
