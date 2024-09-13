// TODO Implement this library.
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String userName;

  ProfilePage({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'User Name: $userName',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Add more user details here if needed
          ],
        ),
      ),
    );
  }
}
