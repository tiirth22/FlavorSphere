import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String appId = '9eda051f'; // Replace with your actual App ID
  static const String appKey = '6926eca6e3a840e7a4024f24d4650a56'; // Replace with your actual App Key
  static const String baseUrl = 'https://api.edamam.com/search';

  // Fetch recipes and return the hits (list of recipes)
  Future<List<dynamic>> getRecipes(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl?q=$query&app_id=$appId&app_key=$appKey'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data['hits']; // Return the list of recipes
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  // Fetch ingredients for a specific recipe URI
  List<dynamic> getIngredients(dynamic recipe) {
    return recipe['ingredients'];
  }

  // Save a recipe to local storage
  Future<void> saveRecipe(dynamic recipe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedRecipes = prefs.getStringList('savedRecipes') ?? [];

    // Check if the recipe already exists in the saved list
    String recipeJson = jsonEncode(recipe);
    if (!savedRecipes.contains(recipeJson)) {
      savedRecipes.add(recipeJson);
      await prefs.setStringList('savedRecipes', savedRecipes);
    }
  }

  // Remove a recipe from saved list
  Future<void> removeRecipe(dynamic recipe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedRecipes = prefs.getStringList('savedRecipes') ?? [];

    // Convert recipe to JSON and remove it
    String recipeJson = jsonEncode(recipe);
    savedRecipes.remove(recipeJson);
    await prefs.setStringList('savedRecipes', savedRecipes);
  }

  // Fetch saved recipes from local storage
  Future<List<dynamic>> getSavedRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedRecipes = prefs.getStringList('savedRecipes') ?? [];

    // Decode each saved recipe back to its original form
    List<dynamic> recipeList = savedRecipes.map((recipeJson) => jsonDecode(recipeJson)).toList();
    return recipeList;
  }
}
