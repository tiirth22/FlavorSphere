import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_detail_page.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String userName = '';
  String userEmail = '';
  String profileImage = 'assets/images/user.png'; // Default profile image

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Fetching email from Firebase Auth
        userEmail = user.email ?? 'No Email';

        // Fetching additional data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          userName = userDoc.exists ? userDoc['name'] ?? 'No Name' : user.displayName ?? 'No Name';
          profileImage = userDoc.exists ? userDoc['profileImage'] ?? 'assets/images/user.png' : 'assets/images/user.png';
        });
      } catch (e) {
        print('Error fetching user profile: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: profileImage.startsWith('http')
                  ? NetworkImage(profileImage) as ImageProvider
                  : AssetImage(profileImage),
              radius: 50,
            ),
            const SizedBox(height: 20),
            Text(
              userName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              userEmail,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Navigate to Profile Details Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileDetailsPage(
                      userName: userName,
                      userEmail: userEmail,
                      profileImage: profileImage,
                    ),
                  ),
                );
              },
              child: const Text('View Full Profile'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/welcome',
                      (Route<dynamic> route) => false,
                );
              },
              child: const Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
