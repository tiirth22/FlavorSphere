import 'package:flutter/material.dart';
import 'saved_recipes_service.dart';
import 'recipe_detail_page.dart'; // Import RecipeDetailPage to navigate to it

class SavedPage extends StatefulWidget {
  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  List<Map<String, dynamic>> _savedRecipes = [];
  final SavedRecipesService _savedRecipesService = SavedRecipesService();

  @override
  void initState() {
    super.initState();
    _loadSavedRecipes();
  }

  Future<void> _loadSavedRecipes() async {
    List<Map<String, dynamic>> savedRecipes = await _savedRecipesService.getSavedRecipes();
    print('Loaded saved recipes: $savedRecipes'); // Debugging line to check saved data
    setState(() {
      _savedRecipes = savedRecipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Recipes')),
      body: _savedRecipes.isEmpty
          ? Center(child: Text('No saved recipes yet!'))
          : ListView.builder(
        itemCount: _savedRecipes.length,
        itemBuilder: (context, index) {
          final recipe = _savedRecipes[index];
          return ListTile(
            leading: recipe['image'] != null
                ? Image.network(recipe['image'], width: 50, height: 50, fit: BoxFit.cover)
                : null, // Add a placeholder image if necessary
            title: Text(recipe['label']),
            subtitle: Text(recipe['source']),
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
}
