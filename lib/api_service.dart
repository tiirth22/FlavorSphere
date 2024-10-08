import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String appId = '9eda051f'; // Replace with your actual App ID
  static const String appKey = '6926eca6e3a840e7a4024f24d4650a56'; // Replace with your actual App Key
  static const String baseUrl = 'https://api.edamam.com/search';

  // Fetch recipes based on query with retry logic
  Future<List<dynamic>> getRecipes(String query) async {
    final response = await _retryHttpGet(
      Uri.parse('$baseUrl?q=$query&app_id=$appId&app_key=$appKey'),
      retries: 3, // Retry the request up to 3 times if it fails
    );

    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      // Ensure that each recipe has the correct image
      return data['hits'].map((hit) {
        var recipe = hit['recipe'];
        return {
          'label': recipe['label'],
          'image': recipe['image'], // Ensure correct image mapping
          'url': recipe['url'],
          'ingredients': recipe['ingredients']
        };
      }).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  // Retry logic for handling network issues (helpful for login issues)
  Future<http.Response?> _retryHttpGet(Uri uri, {int retries = 3}) async {
    int attempt = 0;
    http.Response? response;

    while (attempt < retries) {
      try {
        response = await http.get(uri);

        // Break the loop if the response is successful
        if (response.statusCode == 200) {
          break;
        }
      } catch (e) {
        print('Attempt $attempt failed: $e');
        attempt++;
        if (attempt >= retries) {
          throw Exception('Failed to connect after $retries attempts');
        }
      }
    }

    return response;
  }

  // Handle login logic with error handling
  Future<bool> loginUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://example.com/login'), // Use your actual login endpoint
        body: jsonEncode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Handle successful login
        print('Login successful');
        return true;
      } else {
        // Handle error response
        print('Login failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Handle any network or other errors
      print('Login error: $e');
      return false;
    }
  }
}
