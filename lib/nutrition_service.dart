import 'dart:convert';
import 'package:http/http.dart' as http;

class NutritionService {
  final String appId = 'b94f1fa0';
  final String appKey = 'd0dd581e03e3a598da6a7ef123637d01';
  final String apiUrl = 'https://api.edamam.com/api/nutrition-details';

  Future<Map<String, dynamic>> fetchNutritionData(List<String> ingredients) async {
    final Uri url = Uri.parse('$apiUrl?app_id=$appId&app_key=$appKey');

    final Map<String, dynamic> body = {
      'ingr': ingredients,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch nutrition data');
    }
  }
}
