import 'dart:ui';
import 'package:flutter/material.dart';
import 'user_profile_page.dart'; // Import the User Profile Page

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Duration of the animation
    );

    // Fade animation from 0 (transparent) to 1 (fully visible)
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // Slide animation to move the text from left to right
    _slideAnimation = Tween<Offset>(
      begin: Offset(-1, 0), // Start position (off-screen to the left)
      end: Offset(0, 0),    // End position (fully visible)
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start the animation when the HomePage is built
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose the controller when the widget is destroyed
    super.dispose();
  }

  static List<Widget> _widgetOptions = <Widget>[
    HomeContent(), // Home content (current HomePage content)
    SearchPage(),  // Search page
    SavedPage(),   // Saved page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/logo.png',
                width: 40,
                height: 40,
              ), // App logo on the top left
            ),
            // Wrap "Hello Chef!" in both FadeTransition and SlideTransition
            FadeTransition(
              opacity: _fadeAnimation, // Apply fade-in animation
              child: SlideTransition(
                position: _slideAnimation, // Apply slide-in animation
                child: Text(
                  'Hello Chef!',
                  style: TextStyle(fontSize: 20, color: Colors.deepOrange),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                // Navigate to the UserProfilePage when the user icon is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfilePage()),
                );
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/user.png'), // User image on the top right
              ),
            ),
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex), // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
        ),
        // Main content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Breakfast button with blurred image
              BlurredButton(
                imagePath: 'assets/images/breakfast.jpeg',
                label: 'Breakfast',
                onTap: () {
                  // Handle Breakfast button tap
                },
              ),
              SizedBox(height: 50),
              // Lunch button with blurred image
              BlurredButton(
                imagePath: 'assets/images/lunch.jpeg',
                label: 'Lunch',
                onTap: () {
                  // Handle Lunch button tap
                },
              ),
              SizedBox(height: 50),
              // Dinner button with blurred image
              BlurredButton(
                imagePath: 'assets/images/dinner.jpg',
                label: 'Dinner',
                onTap: () {
                  // Handle Dinner button tap
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BlurredButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;

  const BlurredButton({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Blurred image background
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              imagePath,
              width: MediaQuery.of(context).size.width * 0.8, // Adjust width to fit the screen
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          // Blurred overlay with 40% blur effect
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Adjust width to fit the screen
                height: 100,
                color: Colors.black.withOpacity(0.4), // 40% blur effect
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Search page implementation
class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Recipes',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.food_bank),
                    title: Text('Recipe 1'),
                    subtitle: Text('Delicious recipe description...'),
                  ),
                  ListTile(
                    leading: Icon(Icons.food_bank),
                    title: Text('Recipe 2'),
                    subtitle: Text('Tasty recipe description...'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Saved page implementation
class SavedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Saved Recipes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.bookmark),
                    title: Text('Saved Recipe 1'),
                    subtitle: Text('Saved recipe description...'),
                  ),
                  ListTile(
                    leading: Icon(Icons.bookmark),
                    title: Text('Saved Recipe 2'),
                    subtitle: Text('Favorite recipe description...'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
