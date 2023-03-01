import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get current user
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle, size: 50 ,color: Colors.white),
            const SizedBox(height: 30),
            Text(
              user?.email ?? 'No user logged in',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
