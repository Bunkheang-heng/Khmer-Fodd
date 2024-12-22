import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/recipe.dart';
import '../recipes/detail.dart';
import '../widgets/rating_dialog.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  final Animation<double> animation;
  final Function(Recipe, double) onRatingTap;
  final Function(Recipe) onFavoriteToggle;

  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.animation,
    required this.onRatingTap,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  void _handleFavoriteToggle() async {
    try {
      // Get current state before changing
      final previousState = widget.recipe.isFavorite;

      // Update UI immediately for responsiveness
      setState(() {
        widget.recipe.isFavorite = !previousState;
      });

      // Call the server
      final success = await widget.onFavoriteToggle(widget.recipe);

      if (mounted) {
        // If server call failed, revert to previous state
        if (widget.recipe.isFavorite != success) {
          setState(() {
            widget.recipe.isFavorite = success;
          });
        }

        // Show feedback message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'បានបន្ថែមទៅក្នុងមុខម្ហូបដែលចូលចិត្ត'
                  : 'បានដកចេញពីមុខម្ហូបដែលចូលចិត្ត',
              style: const TextStyle(fontFamily: 'Chenla'),
            ),
            backgroundColor: success ? Colors.green : Colors.grey,
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // Show error message and revert state
      if (mounted) {
        setState(() {
          widget.recipe.isFavorite = !widget.recipe.isFavorite;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'មានបញ្ហាក្នុងការកែប្រែស្ថានភាព',
              style: TextStyle(fontFamily: 'Chenla'),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _handleRatingTap() async {
    final rating = await showDialog<double>(
      context: context,
      builder: (context) => RatingDialog(
        initialRating: widget.recipe.rating,
      ),
    );

    if (rating != null) {
      widget.onRatingTap(widget.recipe, rating);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'អរគុណសម្រាប់ការវាយតម្លៃ!',
            style:  TextStyle(fontFamily: 'Chenla'),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration:  Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeDetailPage(recipe: widget.recipe),
        ),
      ),
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SizedBox(
          height: 140, // Adjusted height for horizontal layout
          child: Row(
            children: [
              // Image Section
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(15),
                ),
                child: SizedBox(
                  width: 140,
                  height: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.recipe.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Content Section
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe Name and Favorite Button Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.recipe.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Chenla',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          AnimatedScale(
                            scale: widget.recipe.isFavorite ? 1.1 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: IconButton(
                              icon: Icon(
                                widget.recipe.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: widget.recipe.isFavorite
                                    ? Colors.red
                                    : Colors.grey[400],
                                size: 24,
                              ),
                              onPressed: _handleFavoriteToggle,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Rating and Ingredients Info
                      Wrap(
                        spacing: 8, // horizontal spacing between items
                        runSpacing: 8, // vertical spacing between lines
                        children: [
                          // Rating Section
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.amber.shade300,
                                  Colors.amber.shade100,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.amber.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Rating Display
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.recipe.rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Chenla',
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 16,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  width: 1,
                                  color: Colors.amber.shade200,
                                ),
                                // Rate Button
                                GestureDetector(
                                  onTap: () async {
                                    final rating = await showDialog<double>(
                                      context: context,
                                      builder: (context) => RatingDialog(
                                        initialRating: widget.recipe.rating,
                                      ),
                                    );

                                    if (rating != null) {
                                      widget.onRatingTap(widget.recipe, rating);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              const Icon(
                                                Icons.star_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              const Text(
                                                'អរគុណសម្រាប់ការវាយតម្លៃ!',
                                                style: TextStyle(
                                                  fontFamily: 'Chenla',
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          backgroundColor:
                                              Colors.green.shade600,
                                          behavior: SnackBarBehavior.floating,
                                          duration: const Duration(seconds: 2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline_rounded,
                                        color: Colors.amber.shade700,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        'វាយតម្លៃ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Chenla',
                                          color: Colors.amber.shade900,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Ingredients Count (updated style to match)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.green.shade300,
                                  Colors.green.shade100,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.restaurant_rounded,
                                  color: Colors.green.shade700,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.recipe.ingredients.length} មុខ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green.shade900,
                                    fontFamily: 'Chenla',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
