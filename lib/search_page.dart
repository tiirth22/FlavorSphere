import 'package:flutter/material.dart';
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

  void _searchRecipes() async {
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
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchRecipes, // Trigger search on button press
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
                  final recipe = _searchResults[index]['recipe']; // Access the actual recipe data
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(recipe['label']), // Recipe name
                      leading: Image.network(recipe['image']), // Recipe image
                      onTap: () {
                        // Navigate to RecipeDetailPage with the selected recipe
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailPage(
                              recipe: recipe,
                              onRecipeSaved: () {
                                // You can implement any specific action you want to take when a recipe is saved.
                                // For example, you could update the search results or refresh the page.
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
