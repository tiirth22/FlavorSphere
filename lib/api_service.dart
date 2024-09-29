import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String appId = '9eda051f'; // Replace with your actual App ID
  static const String appKey = '6926eca6e3a840e7a4024f24d4650a56'; // Replace with your actual App Key
  static const String baseUrl = 'https://api.edamam.com/search';

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
}
