import 'dart:ui';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
            Text(
              'Hello Chef!',
              style: TextStyle(fontSize: 20, color: Colors.deepOrange),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/user.png'), // User image on the top right
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
            'assets/images/background4.jpg',
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

// Placeholder pages for Search and Saved
class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Search Page',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class SavedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Saved Page',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
