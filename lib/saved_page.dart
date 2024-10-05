import 'package:flutter/material.dart';
import 'saved_recipes_service.dart';
import 'recipe_detail_page.dart';
import 'search_page.dart';

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
      _loadSavedRecipes();
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
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmRemoveRecipe(recipe['uri']),
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
                _removeRecipe(uri);
              },
            ),
          ],
        );
      },
    );
  }
}
