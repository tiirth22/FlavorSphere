import 'package:flutter/material.dart';

class ProfileDetailsPage extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String profileImage;

  const ProfileDetailsPage({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: profileImage.startsWith('http')
                  ? NetworkImage(profileImage) as ImageProvider
                  : AssetImage(profileImage),
              radius: 60,
            ),
            const SizedBox(height: 20),
            Text(
              'Name: $userName',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: $userEmail',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
