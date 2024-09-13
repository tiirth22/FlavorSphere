import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'login_screen.dart';
import 'welcome.dart' show WelcomePage;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDb34TUTUBu7K_upjZk20zTlUwb3_I_0D8",
        authDomain: "your-web-auth-domain",
        projectId: "flavorsphere-897b3",
        storageBucket: "flavorsphere-897b3.appspot.com",
        messagingSenderId: "your-messaging-sender-id",
        appId: "1:274732030102:android:799f4a2271fc7427d1cab7",
        measurementId: "your-measurement-id",
      ),
    );
  }else {
    await Firebase.initializeApp();
  }
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
      home: WelcomePage(),
    );
  }
}
