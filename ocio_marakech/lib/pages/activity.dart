import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ocio_marakech/models/activities.dart';
import 'package:ocio_marakech/pages/activity_details.dart';
import 'package:ocio_marakech/pages/favorites.dart';
import 'package:ocio_marakech/pages/home_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ocio_marakech/pages/login_page.dart';

class ActivitiesScreen extends StatefulWidget {
  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  Color goldColor = Color(0xFFD7A949);
  List<Activity> _activities = [];
  int _currentPageIndex = 0;


  @override
  void initState() {
    super.initState();
    _getActivities();
  }

  Future<void> _getActivities() async {
    final response = await http.get(Uri.parse(
        'https://hotelmarrakech-kwh-default-rtdb.firebaseio.com/actividades.json'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Activity> activities = [];
      int i = 0;
      data.forEach((value) {
        final activityData = value as Map<String, dynamic>;
        activities.add(Activity.fromJson(activityData, i));
        i++;
      });

      setState(() {
        _activities = activities;
      });
    } else {
      throw Exception('Error en la solicitud HTTP: ${response.statusCode}');
    }
  }

  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
    
      
      body: _activities.isNotEmpty
          ? PageView.builder(
              itemCount: _activities.length,
              itemBuilder: (BuildContext context, int index) {
                final activity = _activities[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityDetailScreen(
                            activity: activity, idActivity: index.toString()),
                      ),
                    );
                  },
                  child: Hero(
                    tag: activity.nombre,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      margin: EdgeInsets.all(15),
                      elevation: 10,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: CachedNetworkImage(
                                imageUrl: activity.imagen,
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity.nombre,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.attach_money,
                                        color: Colors.green, size: 18),
                                    SizedBox(width: 5),
                                    Text(
                                      activity.precio.toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black,
                                            offset: Offset(2.0, 2.0),
                                            blurRadius: 1.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: goldColor, size: 18),
                                    SizedBox(width: 5),
                                    Text(
                                      activity.rating.toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black,
                                            offset: Offset(2.0, 2.0),
                                            blurRadius: 1.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              scrollDirection: Axis.horizontal,
              onPageChanged: (int index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void getSelectedWidget({required int index}) {
    switch (index) {
      case 0:
        FavoriteScrren();
        break;
      case 1:
        HomePage();
        break;
      default:
        LoginPage();
        break;
    }
  }
}
