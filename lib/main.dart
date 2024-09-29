import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'firebase_options.dart';
import 'home_page.dart'; // HomePage import
import 'welcome.dart'; // Welcome page import (Login or Sign Up)
import 'user_profile_page.dart'; // User profile import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlavorSphere',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: AuthCheck(), // Home will be determined based on Auth state
      routes: {
        '/welcome': (context) => WelcomePage(),
        '/home': (context) => HomePage(),
        '/userProfile': (context) => UserProfilePage(),
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
          return CircularProgressIndicator(); // Show loading spinner while waiting
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
