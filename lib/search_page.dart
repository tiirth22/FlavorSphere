import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'api_service.dart';
import 'recipe_detail_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false; // Track if a search was made

  // Initialize SpeechToText
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  // Method to handle speech input
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
      openAppSettings();
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _searchRecipes() async {
    if (_searchController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a search term.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true; // Mark that a search has been made
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
                  final item = _searchResults[index];
                  if (item == null || item['recipe'] == null) {
                    return SizedBox.shrink();
                  }

                  final recipe = item['recipe'];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(recipe['label'] ?? 'Unknown Recipe'),
                      leading: recipe['image'] != null
                          ? Image.network(recipe['image'])
                          : Icon(Icons.image_not_supported),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailPage(
                              recipe: recipe,
                              onRecipeSaved: () {},
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            // Show "No results found" only if a search was performed
            if (!_isLoading && _searchResults.isEmpty && _hasSearched)
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
