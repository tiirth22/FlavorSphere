import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'saved_recipes_service.dart'; // Import the service to save recipes

class RecipeDetailPage extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final SavedRecipesService savedRecipesService = SavedRecipesService(); // Create an instance of SavedRecipesService
  final VoidCallback onRecipeSaved; // Callback for when the recipe is saved

  RecipeDetailPage({required this.recipe, required this.onRecipeSaved}); // Add callback to constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['label']),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              // Save recipe logic
              await savedRecipesService.saveRecipe(recipe['uri'], recipe.toString());
              onRecipeSaved(); // Notify that the recipe is saved
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Recipe saved!'),
              ));
            },
          ),
        ],
      ),
      body: SingleChildScrollView( // Wrap the body with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(recipe['image']),
            SizedBox(height: 16),
            Text(
              'Source: ${recipe['source']}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...recipe['ingredientLines'].map<Widget>((ingredient) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(ingredient),
              );
            }).toList(),
            SizedBox(height: 16),
            Text(
              'Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (recipe['url'] != null)
              GestureDetector(
                onTap: () {
                  launch(recipe['url']); // Open the URL in a browser
                },
                child: Text(
                  'View Full Recipe Instructions',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
