import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ocio_marakech/pages/activity.dart';
import 'package:ocio_marakech/pages/favorites.dart';
import 'package:ocio_marakech/pages/login_page.dart';
import 'package:ocio_marakech/pages/myprofile.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  Color goldColor = Color(0xFFD7A949);

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  int _currentPageIndex = 1;

  final items = const [
    Icon(
      Icons.favorite,
      size: 30,
      color: Colors.teal,
    ),
    Icon(
      Icons.home,
      size: 30,
      color: Colors.teal,
    ),
    Icon(
      Icons.person,
      size: 30,
      color: Colors.teal,
    )
  ];

  final screens = [FavoriteScrren(), ActivitiesScreen(), UserProfileScreen()];

  @override
  Widget build(BuildContext context) {
    print(user.email);
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        backgroundColor: goldColor,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(
              Icons.logout,
              color: Colors.teal,
            ),
          )
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: items,
        index: _currentPageIndex,
        color: goldColor,
        backgroundColor: Colors.teal,
        buttonBackgroundColor: Colors.white,
        onTap: (selectedIndex) {
          setState(() {
            _currentPageIndex = selectedIndex;
          });
        },
      ),
      body: screens[_currentPageIndex],
    );
  }
}
