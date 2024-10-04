import 'package:flutter/material.dart';
import 'login_screen.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _welcomeTextOpacityAnimation;
  late Animation<Offset> _welcomeTextSlideAnimation;
  late Animation<double> _buttonOpacityAnimation;
  late Animation<Offset> _buttonSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // Full animation duration
    );

    // Define the scale animation for the logo (from 0 to 1.2 for a pop effect)
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut, // Elastic curve for a bouncy pop effect
      ),
    );

    // Define the opacity animation for the logo (from transparent to fully visible)
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn), // Logo animation during the first half
      ),
    );

    // Define the opacity animation for the welcome text
    _welcomeTextOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.8, curve: Curves.easeIn), // Welcome text animation
      ),
    );

    // Define the slide-up animation for the welcome text
    _welcomeTextSlideAnimation = Tween<Offset>(begin: Offset(0, 0.2), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.8, curve: Curves.easeIn), // Slide-up effect for welcome text
      ),
    );

    // Define the opacity animation for the button (starts later)
    _buttonOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.easeIn), // Button animation starts after logo
      ),
    );

    // Define the slide-up animation for the button (from below the screen)
    _buttonSlideAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.easeInOut), // Button animation starts after logo
      ),
    );

    // Start the animation when the page loads
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background3.jpg'), // Example background asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Animated welcome text with fade and slide effect
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _welcomeTextSlideAnimation, // Slide up animation
                        child: Opacity(
                          opacity: _welcomeTextOpacityAnimation.value, // Fade in effect
                          child: Text(
                            'Welcome to FlavorSphere',
                            style: TextStyle(
                              fontFamily: 'Montserrat', // Custom font
                              fontSize: 36, // Larger font size
                              fontWeight: FontWeight.bold, // Bold font weight
                              color: Colors.deepOrange[900], // Darker orange color
                              letterSpacing: 1.5, // Increased letter spacing for modern look
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 50),
                  // Animated logo with scaling and opacity
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScaleAnimation.value, // Apply scale animation
                        child: Opacity(
                          opacity: _logoOpacityAnimation.value, // Apply opacity animation
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/images/logo.png'), // Example logo asset
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 50),
                  // Animated "Start Cooking" button with slide and fade effect
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _buttonSlideAnimation, // Slide from below the screen
                        child: Opacity(
                          opacity: _buttonOpacityAnimation.value, // Apply fade-in effect
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );
                            },
                            child: Text(
                              'Start Cooking',
                              style: TextStyle(
                                fontFamily: 'Montserrat', // Custom font
                                fontSize: 20, // Adjusted font size for button
                                fontWeight: FontWeight.bold, // Bold font weight
                                color: Colors.white, // White text color
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange, // Button background color
                              padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20), // Spacing for button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // Rounded corners
                              ),
                              shadowColor: Colors.orangeAccent, // Button shadow color
                              elevation: 8, // Shadow elevation for depth effect
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
