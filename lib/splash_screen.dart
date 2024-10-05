import 'package:flutter/material.dart';
import 'dart:async'; // Import for using Timer
import 'home_page.dart'; // Import your HomePage

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0; // Initial opacity
  double _scale = 0.8; // Initial scale

  @override
  void initState() {
    super.initState();

    // Trigger the animation on start
    _startLogoAnimation();
  }

  void _startLogoAnimation() {
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0; // Fade in to full opacity
        _scale = 1.0; // Scale up to full size
      });
    });

    // Navigate to home page after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), // Navigate to the main page
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 1200), // Opacity animation duration
          opacity: _opacity,
          child: AnimatedScale(
            duration: Duration(milliseconds: 1200), // Scale animation duration
            scale: _scale,
            curve: Curves.easeOut, // Smooth scaling curve
            child: Image.asset(
              'assets/images/logo.png', // Your app logo here
              width: 150,
              height: 150,
            ),
          ),
        ),
      ),
    );
  }
}
