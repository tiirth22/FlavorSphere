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

  // Initialize SpeechToText
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText(); // Initialize _speech here
  }

  // Method to handle speech input
  Future<void> _startListening() async {
    // Request microphone permission
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
            _searchController.text = result.recognizedWords; // Update text field with recognized words
          });
        });
      }
    } else if (status.isDenied) {
      // Handle the case when the permission is denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microphone permission is denied.')),
      );
    } else if (status.isPermanentlyDenied) {
      // Handle the case when the permission is permanently denied
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
    // Validate input
    if (_searchController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a search term.')),
      );
      return; // Exit early if no input
    }

    setState(() {
      _isLoading = true; // Show loading indicator
      _searchResults.clear(); // Clear previous search results
    });

    // Call your API service to fetch recipes
    ApiService apiService = ApiService();
    try {
      var results = await apiService.getRecipes(_searchController.text);

      setState(() {
        _searchResults = results; // Update search results
        _isLoading = false; // Hide loading indicator
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
      // Handle error (e.g., show a snackbar or an alert)
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a recipe',
                border: OutlineInputBorder(),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                      onPressed: _isListening ? _stopListening : _startListening, // Trigger speech-to-text
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _searchRecipes, // Trigger search on button press
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator(), // Show loading indicator
            if (!_isLoading && _searchResults.isNotEmpty)
              ListView.builder(
                shrinkWrap: true, // Allow ListView to be contained in SingleChildScrollView
                physics: NeverScrollableScrollPhysics(), // Disable scrolling
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final item = _searchResults[index];
                  if (item == null || item['recipe'] == null) {
                    return SizedBox.shrink(); // Skip this item if it's null
                  }

                  final recipe = item['recipe'];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(recipe['label'] ?? 'Unknown Recipe'), // Recipe name with fallback
                      leading: recipe['image'] != null
                          ? Image.network(recipe['image'])
                          : Icon(Icons.image_not_supported), // Fallback if image is null
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailPage(
                              recipe: recipe,
                              onRecipeSaved: () {
                                // Implement any specific action you want to take when a recipe is saved.
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
    );
  }
}
