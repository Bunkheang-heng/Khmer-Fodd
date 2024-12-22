import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String name;
  final List<String> ingredients;
  final List<String> instructions;
  final String imageUrl;
  final DateTime createdAt;
  final String? description;
  final String? videoUrl;
  final List<String> tags;
  final double rating;
  final int ratingCount;
  bool isFavorite;
  final int favoriteCount;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.imageUrl,
    required this.createdAt,
    this.description,
    this.videoUrl,
    this.tags = const [],
    this.rating = 0.0,
    this.ratingCount = 0,
    this.isFavorite = false,
    this.favoriteCount = 0,
  });

  factory Recipe.fromFirestore(Map<String, dynamic> data, String id) {
    return Recipe(
      id: id,
      name: data['name'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      instructions: List<String>.from(data['instructions'] ?? []),
      imageUrl: data['imageUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      description: data['description'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      rating: (data['rating'] ?? 0.0).toDouble(),
      ratingCount: data['ratingCount'] ?? 0,
      isFavorite: false,
      favoriteCount: data['favoriteCount'] ?? 0,
    );
  }
}
