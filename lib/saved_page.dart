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

  late AnimationController _dustbinAnimationController;
  late Animation<double> _dustbinScaleAnimation;
  late Animation<double> _dustbinRotationAnimation;

  @override
  void initState() {
    super.initState();
    _loadSavedRecipes();

    // Initialize animation controller
    _dustbinAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Scale animation from 1.0 to 1.5 for the dustbin
    _dustbinScaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _dustbinAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Rotation animation from 0 to π/4 (45 degrees) for the dustbin lid effect
    _dustbinRotationAnimation = Tween<double>(begin: 0, end: 0.785398).animate(
      CurvedAnimation(
        parent: _dustbinAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _dustbinAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedRecipes() async {
    try {
      final savedRecipes = await _savedRecipesService.getSavedRecipes();
      setState(() {
        _savedRecipes = savedRecipes;
      });
    } catch (e) {
      print('Error loading saved recipes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading recipes: $e')),
      );
    }
  }

  Future<void> _removeRecipe(String uri, int index) async {
    // Start the dustbin opening animation
    await _dustbinAnimationController.forward();
    // Reverse the animation after opening
    await Future.delayed(const Duration(milliseconds: 300)); // Delay to show the open effect
    _dustbinAnimationController.reverse();

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
                animation: _dustbinAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _dustbinScaleAnimation.value,
                    child: Transform.rotate(
                      angle: _dustbinRotationAnimation.value,
                      child: const Icon(Icons.delete),
                    ),
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
