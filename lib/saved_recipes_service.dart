import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding/decoding

class SavedRecipesService {
  // Save a recipe if it doesn't already exist
  Future<void> saveRecipe(String uri, String recipeJson) async {
    final prefs = await SharedPreferences.getInstance();

    // Load existing recipes
    List<Map<String, dynamic>> recipes = await getSavedRecipes();

    // Check if the recipe already exists
    if (!recipes.any((r) => r['uri'] == uri)) {
      // Add the new recipe to the list
      recipes.add(json.decode(recipeJson));

      // Save the updated list back to SharedPreferences
      await prefs.setString('saved_recipes', json.encode(recipes));
    }
  }

  // Load saved recipes from SharedPreferences
  Future<List<Map<String, dynamic>>> getSavedRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedRecipesString = prefs.getString('saved_recipes');

    // Decode the JSON contents into a list of maps if it exists
    if (savedRecipesString != null) {
      return List<Map<String, dynamic>>.from(json.decode(savedRecipesString));
    }

    // Return an empty list if there are no saved recipes
    return [];
  }

  // Remove a recipe by its URI
  Future<void> removeRecipe(String uri) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> recipes = await getSavedRecipes();

    // Filter out the recipe to be removed
    recipes.removeWhere((recipe) => recipe['uri'] == uri);

    // Save the updated list back to SharedPreferences
    await prefs.setString('saved_recipes', json.encode(recipes));
  }

  // Clear all saved recipes (optional)
  Future<void> clearSavedRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_recipes');
  }
}
