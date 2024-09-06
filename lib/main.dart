import 'package:flutter/material.dart';
import 'login.dart';
import 'welcome.dart' show WelcomePage;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // This removes the debug banner
      title: 'FlavorSphere',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: WelcomePage(),
    );
  }
}
