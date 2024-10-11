import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt; // Import the speech_to_text package
import 'package:permission_handler/permission_handler.dart'; // Import the permission_handler package
import 'api_service.dart'; // Import your API service
import 'recipe_detail_page.dart'; // Import your RecipeDetailPage

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText(); // Initialize _speech here
  }

  Future<void> _startListening() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Speech Status: $status'),
        onError: (error) => print('Speech Error: $error'),
      );

      if (available) {
        setState(() {
          _isListening = true;
        });

        _speech.listen(onResult: (result) {
          setState(() {
            _searchController.text = result.recognizedWords;
          });
        });
      }
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microphone permission is denied.')),
      );
    } else if (status.isPermanentlyDenied) {
      openAppSettings(); // Open app settings to enable permission manually
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _searchRecipes() async {
    setState(() {
      _isLoading = true;
      _searchResults.clear();
    });

    ApiService apiService = ApiService();
    try {
      var results = await apiService.getRecipes(_searchController.text);

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching recipes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Recipes'),
      ),
      body: Stack(
        children: [
          // Add the background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background7.jpg'), // Path to your food image
                fit: BoxFit.cover, // Make sure the image covers the entire screen
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search for a recipe',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white.withOpacity(0.8), // Slight transparency for better readability
                    filled: true,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                          onPressed: _isListening ? _stopListening : _startListening,
                        ),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: _searchRecipes,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (_isLoading)
                  CircularProgressIndicator(),
                if (!_isLoading && _searchResults.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final recipe = _searchResults[index]['recipe'];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Text(recipe['label']),
                          leading: Image.network(recipe['image']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailPage(
                                  recipe: recipe,
                                  onRecipeSaved: () {
                                    // Implement any specific action when a recipe is saved.
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                if (!_isLoading && _searchResults.isEmpty)
                  Text(
                    'No results found.',
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
