import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Updated import according to your project structure
import 'nutrition_service.dart';
import 'saved_recipes_service.dart';

class RecipeDetailPage extends StatefulWidget {
  final Map<String, dynamic> recipe;
  final VoidCallback onRecipeSaved;

  RecipeDetailPage({required this.recipe, required this.onRecipeSaved});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  final SavedRecipesService savedRecipesService = SavedRecipesService();
  final NutritionService nutritionService = NutritionService();

  bool _isSaved = false;
  bool _isLoading = true;
  bool _isError = false;
  Map<String, dynamic>? nutritionData;

  @override
  void initState() {
    super.initState();
    fetchNutritionInfo();
  }

  Future<void> fetchNutritionInfo() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });
    try {
      List<String> ingredients = List<String>.from(widget.recipe['ingredientLines'] ?? []);
      nutritionData = await nutritionService.fetchNutritionData(ingredients);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching nutrition data: $e');
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe['label'] ?? 'Recipe Details'),
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.favorite : Icons.save,
              color: _isSaved ? Colors.red : Colors.black,
            ),
            onPressed: saveRecipe,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _isError
          ? Center(child: Text('Error fetching nutritional information'))
          : buildRecipeDetail(),
    );
  }

  Widget buildRecipeDetail() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              widget.recipe['image'] ?? '',
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 100),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Source: ${widget.recipe['source'] ?? 'Unknown'}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Ingredients:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ...List<Widget>.from((widget.recipe['ingredientLines'] ?? []).map((ingredient) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(ingredient),
            );
          })),
          const SizedBox(height: 16),
          const Text(
            'Nutritional Information:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          nutritionData != null ? buildNutritionInfo() : Text('No nutritional data available'),
          const SizedBox(height: 16),
          if (widget.recipe['url'] != null)
            GestureDetector(
              onTap: () async {
                final url = Uri.parse(widget.recipe['url']);
                if (await canLaunchUrl(url)) {
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
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildNutritionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Calories: ${nutritionData!['calories']?.toStringAsFixed(0) ?? 'N/A'} kcal'),
        Text('Protein: ${nutritionData!['totalNutrients']['PROCNT']?['quantity']?.toStringAsFixed(1) ?? 'N/A'} g'),
        Text('Fat: ${nutritionData!['totalNutrients']['FAT']?['quantity']?.toStringAsFixed(1) ?? 'N/A'} g'),
        Text('Carbs: ${nutritionData!['totalNutrients']['CHOCDF']?['quantity']?.toStringAsFixed(1) ?? 'N/A'} g'),
      ],
    );
  }

  Future<void> saveRecipe() async {
    try {
      await savedRecipesService.saveRecipe(
          widget.recipe['uri'], json.encode(widget.recipe));
      widget.onRecipeSaved();
      setState(() {
        _isSaved = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe saved!')),
      );
    } catch (e) {
      print('Error saving recipe: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving recipe!')),
      );
    }
  }
}
