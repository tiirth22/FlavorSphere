import 'package:flutter/material.dart';
import 'saved_recipes_service.dart';
import 'recipe_detail_page.dart'; // Import RecipeDetailPage to navigate to it
import 'search_page.dart'; // Import SearchPage to navigate to it

class SavedPage extends StatefulWidget {
  @override
  SavedPageState createState() => SavedPageState();
}

class SavedPageState extends State<SavedPage> {
  List<Map<String, dynamic>> _savedRecipes = [];
  final SavedRecipesService _savedRecipesService = SavedRecipesService();

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
      });
    } catch (e) {
      print('Error loading saved recipes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading recipes: $e')),
      );
    }
  }

  Future<void> _removeRecipe(String uri) async {
    try {
      await _savedRecipesService.removeRecipe(uri);
      _loadSavedRecipes(); // Reload the recipes after removing one
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
            onPressed: _loadSavedRecipes, // Reload saved recipes manually
          ),
        ],
      ),
      body: _savedRecipes.isEmpty
          ? _buildEmptyState() // Add an empty state with illustration or button
          : ListView.builder(
        itemCount: _savedRecipes.length,
        itemBuilder: (context, index) {
          final recipe = _savedRecipes[index];
          return ListTile(
            leading: recipe['image'] != null
                ? Image.network(
              recipe['image'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
                : const Icon(Icons.image), // Use const for static widgets
            title: Text(recipe['label']),
            subtitle: Text(recipe['source']),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmRemoveRecipe(recipe['uri']), // Confirm removal before deleting
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailPage(
                    recipe: recipe,
                    onRecipeSaved: () {
                      // Reload saved recipes when navigating back
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
            onPressed: () {
              // Navigate to SearchPage when browsing for recipes
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(), // Change this to your SearchPage class
                ),
              );
            },
            child: const Text('Browse Recipes'),
          ),
        ],
      ),
    );
  }

  // Confirmation dialog before removing a recipe
  void _confirmRemoveRecipe(String uri) {
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
                _removeRecipe(uri); // Call removeRecipe when confirmed
              },
            ),
          ],
        );
      },
    );
  }
}
