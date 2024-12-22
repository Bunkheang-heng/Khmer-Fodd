import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../widgets/recipe_description.dart';
import '../widgets/recipe_instructions.dart';
import '../widgets/recipe_ingredients.dart';
import '../widgets/ai_bar_1.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage>
    with SingleTickerProviderStateMixin {
  final RecipeService _recipeService = RecipeService();
  bool _isFavorite = false;
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadFavoriteStatus() async {
    final isFavorite = await _recipeService.isFavorite(widget.recipe.id);
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  Future<void> _toggleFavorite() async {
    await _recipeService.toggleFavorite(widget.recipe.id);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
              ],
            ),
          ),
        ),
        title: Text(
          widget.recipe.name,
          style: const TextStyle(
            fontFamily: 'Chenla',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: Colors.black45,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Add share functionality
            },
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  _toggleFavorite();
                  _controller.reset();
                  _controller.forward();
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.recipe.imageUrl.isNotEmpty)
              Stack(
                children: [
                  Hero(
                    tag: 'recipe-${widget.recipe.id}',
                    child: Container(
                      height: 350,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.recipe.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                        )),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade700,
                            Colors.green.shade900
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 22),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.recipe.rating.toStringAsFixed(1)} (${widget.recipe.ratingCount})',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'បង្កើតនៅថ្ងៃទី: ${DateFormat.yMd().format(widget.recipe.createdAt)}',
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontSize: 14,
                              fontFamily: 'Chenla',
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          children: widget.recipe.tags
                              .map((tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.green.shade400,
                                          Colors.green.shade600
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.green.withOpacity(0.3),
                                          spreadRadius: 1,
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      tag,
                                      style: const TextStyle(
                                        fontFamily: 'Chenla',
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTabButton('ការពិពណ៌នា', 0, Icons.description),
                          _buildTabButton(
                              'គ្រឿងផ្សំ', 1, Icons.restaurant_menu),
                          _buildTabButton('វិធីធ្វើ', 2, Icons.menu_book),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _selectedIndex == 0
                          ? RecipeDescription(recipe: widget.recipe)
                          : _selectedIndex == 1
                              ? RecipeIngredients(recipe: widget.recipe)
                              : RecipeInstructions(recipe: widget.recipe),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => AIBar(
                initialPrompt: '',
                context:
                    "មុខម្ហូប: ${widget.recipe.name}\nគ្រឿងផ្សំ: ${widget.recipe.ingredients.join(', ')}\nវិធីធ្វើ: ${widget.recipe.instructions.join('\n')}",
                systemMessage:
                    """អ្នកជាជំនួយការផ្នែកម្ហូបអាហារខ្មែរ។ សូមឆ្លើយសំណួរទាក់ទងតែនឹងម្ហូប ${widget.recipe.name} ប៉ុណ្ណោះ។""",
              ),
            );
          },
          backgroundColor: Colors.green.shade700,
          icon: const Icon(
            Icons.chat_bubble_outline,
            color: Colors.white,
            size: 28,
          ),
          label: const Text(
            'សួរAI',
            style: TextStyle(
              fontFamily: 'Chenla',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, int index, IconData icon) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [Colors.green.shade600, Colors.green.shade800],
                )
              : null,
          borderRadius: BorderRadius.circular(15),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.green.shade700,
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Chenla',
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.green.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
