import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'saved_recipes_service.dart';
import 'dart:convert'; // Import for JSON encoding/decoding

class RecipeDetailPage extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final SavedRecipesService savedRecipesService = SavedRecipesService(); // Create an instance of SavedRecipesService
  final VoidCallback onRecipeSaved; // Callback for when the recipe is saved

  RecipeDetailPage({required this.recipe, required this.onRecipeSaved});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['label']),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              // Log the recipe data before saving
              print('Saving recipe: ${recipe.toString()}'); // Debugging line
              try {
                // Save the recipe using shared_preferences
                await savedRecipesService.saveRecipe(recipe['uri'], json.encode(recipe)); // Encode the recipe map
                onRecipeSaved(); // Notify that the recipe is saved
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recipe saved!')),
                );
              } catch (e) {
                print('Error saving recipe: $e'); // Log any errors that occur
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error saving recipe!')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(recipe['image'], width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            Text(
              'Source: ${recipe['source']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Display ingredients
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recipe['ingredientLines'].map<Widget>((ingredient) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(ingredient),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (recipe['url'] != null)
              GestureDetector(
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse(recipe['url']))) {
                    await launchUrl(Uri.parse(recipe['url']));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not launch URL')),
                    );
                  }
                },
                child: const Text(
                  'View Full Recipe Instructions',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            const Text(
              'Nutritional Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Nutritional Information
            Text('Calories: ${recipe['calories']}'),
            Text('Protein: ${recipe['protein']} g'),
            Text('Fat: ${recipe['fat']} g'),
            Text('Carbohydrates: ${recipe['carbohydrates']} g'),
          ],
        ),
      ),
    );
  }
}
