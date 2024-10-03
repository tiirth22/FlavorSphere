import 'package:flutter/material.dart'; // Import the Material package
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'firebase_options.dart'; // Import Firebase options for initialization
import 'home_page.dart'; // Import HomePage
import 'welcome.dart'; // Import Welcome page (Login or Sign Up)
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
      home: AuthCheck(), // Check authentication state to determine home screen
      routes: {
        '/welcome': (context) => WelcomePage(), // Define routes for navigation
        '/home': (context) => HomePage(),
        '/userProfile': (context) => UserProfilePage(),
        '/savedRecipes': (context) => SavedPage(), // Add route for SavedPage
      },
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
          // If the user is logged in (has data), navigate to HomePage
          return HomePage();
        } else {
          // If the user is not logged in, show the WelcomePage (Login/SignUp screen)
          return WelcomePage();
        }
      },
    );
  }
}
