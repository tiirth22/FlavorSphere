import 'dart:ui'; // Import this for ImageFilter
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'api_service.dart'; // Import API Service for recipe search
import 'search_page.dart'; // Importing SearchPage for recipe search

import 'user_profile_page.dart'; // Import UserProfilePage

import 'saved_page.dart' as SavedPageModule; // Import SavedPage with an alias to avoid conflict

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final ApiService apiService = ApiService(); // Initialize ApiService for search

  static List<Widget> _widgetOptions = <Widget>[
    HomeContent(),  // Home content (Home page body)
    SearchPage(),   // Search page for searching recipes
    SavedPageModule.SavedPage(),    // Use the aliased SavedPage from saved_page.dart
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
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Sign out the user
              Navigator.pushReplacementNamed(context, '/welcome'); // Redirect to login/signup screen
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                // Navigate to UserProfilePage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfilePage()),
                );
              },
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/user.png'), // User profile image
              ),
            ),
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex), // Display selected page
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
            'assets/images/background6.jpg',
            fit: BoxFit.cover,
          ),
        ),
        // Main content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlurredButton(
                imagePath: 'assets/images/breakfast.jpeg',
                label: 'Breakfast',
                onTap: () {
                  // Navigate to SearchPage with meal type Breakfast
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(), // Pass mealType if necessary
                    ),
                  );
                },
              ),
              SizedBox(height: 30), // Adjust spacing as needed
              BlurredButton(
                imagePath: 'assets/images/lunch.jpeg',
                label: 'Lunch',
                onTap: () {
                  // Navigate to SearchPage with meal type Lunch
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(), // Pass mealType if necessary
                    ),
                  );
                },
              ),
              SizedBox(height: 30), // Adjust spacing as needed
              BlurredButton(
                imagePath: 'assets/images/dinner.jpg',
                label: 'Dinner',
                onTap: () {
                  // Navigate to SearchPage with meal type Dinner
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(), // Pass mealType if necessary
                    ),
                  );
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

  BlurredButton({
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
          // Background image
          Image.asset(
            imagePath,
            width: 250, // Reduced width
            height: 150, // Reduced height
            fit: BoxFit.cover,
          ),
          // Blurred effect
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                width: 250, // Match the reduced width
                height: 150, // Match the reduced height
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 24, // Reduced font size for better fit
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
