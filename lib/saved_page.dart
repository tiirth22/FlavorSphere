import 'package:flutter/material.dart';
import 'saved_recipes_service.dart';
import 'recipe_detail_page.dart';
import 'search_page.dart';

class SavedPage extends StatefulWidget {
  @override
  SavedPageState createState() => SavedPageState();
}

class SavedPageState extends State<SavedPage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _savedRecipes = [];
  final SavedRecipesService _savedRecipesService = SavedRecipesService();
  final List<AnimationController> _dustbinAnimationControllers = [];
  final List<Animation<double>> _dustbinAnimations = [];

  @override
  void initState() {
    super.initState();
    _loadSavedRecipes();
  }

  Future<void> _loadSavedRecipes() async {
    try {
      final savedRecipes = await _savedRecipesService.getSavedRecipes();
      setState(() {
        _savedRecipes = savedRecipes;
        _initializeDustbinAnimations(); // Initialize animations for each saved recipe
      });
    } catch (e) {
      print('Error loading saved recipes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading recipes: $e')),
      );
    }
  }

  void _initializeDustbinAnimations() {
    for (int i = 0; i < _savedRecipes.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );

      final animation = Tween<double>(begin: 1.0, end: 1.5).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );

      _dustbinAnimationControllers.add(controller);
      _dustbinAnimations.add(animation);
    }
  }

  Future<void> _removeRecipe(String uri, int index) async {
    // Start the dustbin animation
    await _dustbinAnimationControllers[index].forward();
    await Future.delayed(const Duration(milliseconds: 300)); // Delay to show the open effect
    await _dustbinAnimationControllers[index].reverse();

    // Simulate some delay for the animation to complete
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      await _savedRecipesService.removeRecipe(uri);
      setState(() {
        _savedRecipes.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe removed!')),
      );
    } catch (e) {
      print('Error removing recipe: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing recipe: $e')),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _dustbinAnimationControllers) {
      controller.dispose(); // Dispose of each animation controller
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSavedRecipes,
          ),
        ],
      ),
      body: _savedRecipes.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        itemCount: _savedRecipes.length,
        itemBuilder: (context, index) {
          final recipe = _savedRecipes[index];

          return ListTile(
            leading: recipe['image'] != null
                ? FadeInImage.assetNetwork(
              placeholder: 'assets/placeholder.png',
              image: recipe['image'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
                : const Icon(Icons.image),
            title: Text(
              recipe['label'],
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              recipe['source'],
              overflow: TextOverflow.ellipsis,
            ),
            trailing: GestureDetector(
              onTap: () => _confirmRemoveRecipe(recipe['uri'], index),
              child: AnimatedBuilder(
                animation: _dustbinAnimations[index],
                builder: (context, child) {
                  return Transform.scale(
                    scale: _dustbinAnimations[index].value,
                    child: const Icon(Icons.delete),
                  );
                },
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailPage(
                    recipe: recipe,
                    onRecipeSaved: () {
                      _loadSavedRecipes();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bookmark_outline, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            'No saved recipes yet!',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            child: const Text('Browse Recipes'),
          ),
        ],
      ),
    );
  }

  void _confirmRemoveRecipe(String uri, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Recipe'),
          content: const Text('Are you sure you want to remove this recipe?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Remove'),
              onPressed: () {
                Navigator.of(context).pop();
                _removeRecipe(uri, index);
              },
            ),
          ],
        );
      },
    );
  }
}
