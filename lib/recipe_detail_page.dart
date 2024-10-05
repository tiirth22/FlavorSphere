import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'saved_recipes_service.dart';
import 'dart:convert'; // Import for JSON encoding/decoding

class RecipeDetailPage extends StatefulWidget {
  final Map<String, dynamic> recipe;
  final VoidCallback onRecipeSaved; // Callback for when the recipe is saved

  RecipeDetailPage({required this.recipe, required this.onRecipeSaved});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final SavedRecipesService savedRecipesService = SavedRecipesService();
  bool _isSaved = false; // To track the saved state
  bool _isAnimating = false; // To track if the animation is playing

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe['label']),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: _isSaved
                  ? const Icon(Icons.favorite, key: ValueKey<bool>(true), color: Colors.red)
                  : const Icon(Icons.save, key: ValueKey<bool>(false), color: Colors.black),
            ),
            onPressed: () async {
              setState(() {
                _isAnimating = true;
              });

              try {
                // Save the recipe using shared_preferences
                await savedRecipesService.saveRecipe(
                    widget.recipe['uri'], json.encode(widget.recipe)); // Encode the recipe map
                widget.onRecipeSaved(); // Notify that the recipe is saved

                // Show success and trigger animation
                setState(() {
                  _isSaved = true;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recipe saved!')),
                );
              } catch (e) {
                print('Error saving recipe: $e'); // Log any errors that occur
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error saving recipe!')),
                );
              } finally {
                // End animation after saving
                setState(() {
                  _isAnimating = false;
                });
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
              child: Image.network(widget.recipe['image'], width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            Text(
              'Source: ${widget.recipe['source']}',
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
              children: widget.recipe['ingredientLines'].map<Widget>((ingredient) {
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
            if (widget.recipe['url'] != null)
              GestureDetector(
                onTap: () async {
                  final url = Uri.parse(widget.recipe['url']); // Parse the URL
                  if (await canLaunchUrl(url)) {
                    // Launch URL in external browser
                    await launchUrl(url, mode: LaunchMode.externalApplication);
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
            Text('Calories: ${widget.recipe['calories']}'),
            Text('Protein: ${widget.recipe['protein']} g'),
            Text('Fat: ${widget.recipe['fat']} g'),
            Text('Carbohydrates: ${widget.recipe['carbohydrates']} g'),
          ],
        ),
      ),
    );
  }
}
