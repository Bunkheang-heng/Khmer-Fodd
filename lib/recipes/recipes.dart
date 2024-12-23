import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/auth/login.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../widgets/recipe_card.dart';
import '../widgets/rating_dialog.dart';
import '../widgets/buttom_nav_bar.dart';
import '../screens/favorites_page.dart';
import '../widgets/recipe_filters.dart';

class RecipeListPage extends StatefulWidget {
  @override
  _RecipeListPageState createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final RecipeService _recipeService = RecipeService();
  List<Recipe> _allRecipes = [];
  List<Recipe> _filteredRecipes = [];
  String? _selectedTimeFilter;
  double? _selectedRating;
  String? _selectedTag;
  List<String> _availableTags = [];
  late AnimationController _animationController;
  late Animation<double> _animation;
  final Map<String, bool> _favoriteStatus = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _checkAuthAndLoadRecipes();
    _animationController.forward();
    _loadFavoriteStatus();

    // Add listener for search text changes
    _searchController.addListener(() {
      _filterRecipes(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthAndLoadRecipes() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
      return;
    }
    await _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final recipes = await _recipeService.loadRecipesWithFilters(
      timeFilter: _selectedTimeFilter,
      ratingFilter: _selectedRating,
      tagFilter: _selectedTag,
    );

    setState(() {
      _allRecipes = recipes;
      _filteredRecipes = List.from(_allRecipes);

      Set<String> tags = {};
      for (var recipe in _allRecipes) {
        tags.addAll(recipe.tags);
      }
      _availableTags = tags.toList()..sort();

      // Re-apply search filter after loading recipes
      _filterRecipes(_searchController.text);
    });
  }

  Future<void> _rateRecipe(Recipe recipe, double rating) async {
    final selectedRating = await showDialog<double>(
      context: context,
      builder: (context) => RatingDialog(initialRating: rating),
    );

    if (selectedRating == null) return;

    await _recipeService.rateRecipe(recipe.id, selectedRating, context);
    await _loadRecipes();
  }

  void _filterRecipes(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredRecipes = _allRecipes.where((recipe) {
          return _selectedTag == null || recipe.tags.contains(_selectedTag);
        }).toList();
      } else {
        // Normalize the search query by converting to lowercase
        final normalizedQuery = query.toLowerCase().trim();

        _filteredRecipes = _allRecipes.where((recipe) {
          // Check recipe name (both Khmer and any other text)
          bool matchesName =
              recipe.name.toLowerCase().contains(normalizedQuery);

          // Check recipe description
          bool matchesDescription =
              recipe.description?.toLowerCase().contains(normalizedQuery) ??
                  false;

          // Check ingredients
          bool matchesIngredients = recipe.ingredients.any((ingredient) {
            return ingredient.toLowerCase().contains(normalizedQuery);
          });

          // Check if any tags match (optional, but useful for Khmer tag searching)
          bool matchesTags = recipe.tags
              .any((tag) => tag.toLowerCase().contains(normalizedQuery));

          // Combine all search conditions
          bool matchesSearch = matchesName ||
              matchesDescription ||
              matchesIngredients ||
              matchesTags;

          // Apply tag filter if selected
          bool matchesTag =
              _selectedTag == null || recipe.tags.contains(_selectedTag);

          return matchesSearch && matchesTag;
        }).toList();
      }
    });
  }

  void _handleTimeFilter(String? time) {
    setState(() {
      _selectedTimeFilter = time;
    });
    _loadRecipes();
  }

  void _handleRatingFilter(double? rating) {
    setState(() {
      _selectedRating = rating;
    });
    _loadRecipes();
  }

  void _handleTagFilter(String? tag) {
    setState(() {
      _selectedTag = tag;
    });
    _loadRecipes();
  }

  Future<void> _loadFavoriteStatus() async {
    for (var recipe in _allRecipes) {
      _favoriteStatus[recipe.id] = await _recipeService.isFavorite(recipe.id);
    }
    if (mounted) setState(() {});
  }

  Future<bool> _toggleFavorite(Recipe recipe) async {
    try {
      final newStatus = await _recipeService.toggleFavorite(recipe.id);
      setState(() {
        recipe.isFavorite = newStatus;
      });
      return newStatus;
    } catch (e) {
      print('Error toggling favorite: $e');
      return recipe.isFavorite;
    }
  }

  Future<void> _loadFavoriteStatuses() async {
    for (var recipe in _allRecipes) {
      await _recipeService.loadFavoriteStatus(recipe);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Transform.scale(
          scale: 1 + (_animation.value * 0.1),
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesPage()),
              );
            },
            backgroundColor: Colors.green[700],
            icon: const Icon(Icons.favorite, color: Colors.white),
            label: const Text(
              'មុខម្ហូបដែលចូលចិត្ត',
              style: TextStyle(fontFamily: 'Chenla', color: Colors.white),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.green[700],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'មុខម្ហូបខ្មែរ',
                style: TextStyle(
                  fontFamily: 'Chenla',
                  fontSize: 24,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3.0,
                      color: Color.fromARGB(115, 255, 252, 252),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/banner.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.green[700]!,
                              Colors.green[900]!,
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.restaurant_menu,
                            color: Colors.white,
                            size: 64,
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.green.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data?.data() != null) {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final name = userData['name'] as String? ?? 'អ្នកប្រើប្រាស់';
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'សួស្តី $name',
                          style: TextStyle(
                            fontFamily: 'Chenla',
                            fontSize: 24,
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'តើអ្នកចង់ចំអិនអ្វីថ្ងៃនេះ?',
                          style: TextStyle(
                            fontFamily: 'Chenla',
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'ស្វែងរកមុខម្ហូប...',
                            hintStyle: const TextStyle(fontFamily: 'Chenla'),
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.green[700]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: Colors.green[700]!, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => DraggableScrollableSheet(
                      initialChildSize: 0.7,
                      minChildSize: 0.5,
                      maxChildSize: 0.95,
                      builder: (_, controller) => Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: RecipeFilters(
                          searchController: _searchController,
                          selectedTimeFilter: _selectedTimeFilter,
                          selectedRating: _selectedRating,
                          selectedTag: _selectedTag,
                          availableTags: _availableTags,
                          onSearchChanged: _filterRecipes,
                          onTimeFilterSelected: _handleTimeFilter,
                          onRatingSelected: _handleRatingFilter,
                          onTagSelected: _handleTagFilter,
                        ),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: const Icon(Icons.filter_list,
                    size: 20, color: Colors.white),
                label: const Text(
                  'Filter',
                  style: TextStyle(
                    fontFamily: 'Chenla',
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _allRecipes.isEmpty
                ? const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _filteredRecipes.isEmpty
                    ? SliverToBoxAdapter(child: _buildEmptyState())
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) => Transform.scale(
                                scale: 0.95 + (_animation.value * 0.05),
                                child: RecipeCard(
                                  recipe: _filteredRecipes[index],
                                  animation: _animation,
                                  onRatingTap: _rateRecipe,
                                  onFavoriteToggle: _toggleFavorite,
                                ),
                              ),
                            );
                          },
                          childCount: _filteredRecipes.length,
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.green[200]),
          const SizedBox(height: 16),
          Text(
            'រកមិនឃើញមុខម្ហូប',
            style: TextStyle(
              fontFamily: 'Chenla',
              fontSize: 24,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'សូមព្យាយាមស្វែងរកជាមួយពាក្យគន្លឹះផ្សេងទៀត',
            style: TextStyle(
              fontFamily: 'Chenla',
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
