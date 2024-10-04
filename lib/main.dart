import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'firebase_options.dart'; // Import Firebase options for initialization
import 'splash_screen.dart'; // Import SplashScreen for logo animation
import 'home_page.dart'; // Import HomePage
import 'welcome.dart'; // Import WelcomePage for login/sign up
import 'user_profile_page.dart'; // Import User profile page
import 'saved_page.dart'; // Import SavedPage for saved recipes

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Initialize Firebase
  );

  runApp(MyApp()); // Run the main application
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      title: 'FlavorSphere', // Set the title of the app
      theme: ThemeData(
        primarySwatch: Colors.orange, // Set the primary color theme
      ),
      home: SplashScreen(), // Start with the SplashScreen
      routes: {
        '/welcome': (context) => WelcomePage(), // Define route for the Welcome page
        '/home': (context) => HomePage(), // Define route for the Home page
        '/userProfile': (context) => UserProfilePage(), // Define route for the User Profile page
        '/savedRecipes': (context) => SavedPage(), // Define route for the Saved page
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _scale = 0.8;

  @override
  void initState() {
    super.initState();
    _startLogoAnimation();
  }

  void _startLogoAnimation() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0; // Fade-in animation
        _scale = 1.0; // Scale-up animation
      });
    });

    // After the animation completes, check the authentication status
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthCheck()), // Navigate to auth check
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

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen to auth state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // Show loading spinner while waiting
            ),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'), // Show error message
            ),
          );
        }
        if (snapshot.hasData) {
          // If the user is logged in, navigate to HomePage
          return HomePage();
        } else {
          // If the user is not logged in, show the WelcomePage (Login/SignUp)
          return WelcomePage();
        }
      },
    );
  }
}
