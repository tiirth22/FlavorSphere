import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Variables to store user details
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String userBio = '';
  String profileImage = 'assets/images/user.png'; // Default profile image

  @override
  void initState() {
    super.initState();
    fetchUserProfile(); // Fetch the user's profile details on page load
  }

  // Method to fetch user details from Firebase Firestore
  void fetchUserProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          userName = userDoc['name'] ?? 'No Name';
          userEmail = userDoc['email'] ?? 'No Email';
          userPhone = userDoc['phone'] ?? 'No Phone';
          userBio = userDoc['bio'] ?? 'No Bio available';
          profileImage = userDoc['profileImage'] ?? profileImage;
        });
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              CircleAvatar(
                backgroundImage: profileImage.startsWith('http')
                    ? NetworkImage(profileImage) as ImageProvider
                    : AssetImage(profileImage),
                radius: 60,
              ),
              const SizedBox(height: 20),

              // User's Name
              Text(
                userName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // User's Email
              Text(
                userEmail,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // User's Phone Number
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.blue),
                title: Text(userPhone),
              ),

              // User's Bio
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.green),
                title: Text(userBio),
              ),

              const SizedBox(height: 30),

              // Edit Profile Button
              ElevatedButton(
                onPressed: () {
                  // Placeholder for edit profile functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Edit Profile feature coming soon!')),
                  );
                },
                child: const Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),

              const SizedBox(height: 20),

              // Log Out Button
              ElevatedButton(
                onPressed: () {
                  // Log out the user and navigate to the welcome page
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/welcome',
                          (Route<dynamic> route) => false,
                    );
                  });
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
      ),
    );
  }
}
