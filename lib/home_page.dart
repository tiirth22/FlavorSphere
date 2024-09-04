import 'dart:ui';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logo.png'), // App logo on the top left
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
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background4.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Main content
          Column(
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
              SizedBox(height: 16),
              // Lunch button with blurred image
              BlurredButton(
                imagePath: 'assets/images/lunch.jpeg',
                label: 'Lunch',
                onTap: () {
                  // Handle Lunch button tap
                },
              ),
              SizedBox(height: 16),
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
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: [
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
            label: 'Save',
          ),
        ],
      ),
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
              width: 200,
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
                width: 200,
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
