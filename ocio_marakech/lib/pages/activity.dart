import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ocio_marakech/pages/activity_details.dart';
import 'package:ocio_marakech/pages/home_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Activity {
  String nombre;
  String descripcion;
  String imagen;
  double precio;
  int rating;
  List<String> comments;

  Activity({
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    required this.precio,
    required this.rating,
    required this.comments,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      imagen: json['imagen'] ?? '',
      precio: (json['precio'] ?? 0).toDouble(),
      rating: 0,
      comments: [],
    );
  }
}

class ActivitiesScreen extends StatefulWidget {
  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  List<Activity> _activities = [];
  int _currentPageIndex = 0;
    int indx = 1;
  final items = const [
    Icon(Icons.home, size: 30, color: Colors.teal,),
    Icon(Icons.favorite, size: 30, color: Colors.teal,),
    Icon(Icons.person, size: 30, color:Colors.teal,)
  ];
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
      data.forEach((value) {
        final activityData = value as Map<String, dynamic>;
        activities.add(Activity.fromJson(activityData));
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
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout, color: Colors.teal,),
          )
        ],
      ), bottomNavigationBar: CurvedNavigationBar(
        items: items,
        index: indx,
        color: Colors.amber,
        buttonBackgroundColor: Colors.white,
        onTap: (selctedIndex){

          setState(() {
            indx = selctedIndex;
          });
        },
        height: 70,
        backgroundColor: Colors.transparent,
        animationDuration: const Duration(milliseconds: 300),
        // animationCurve: ,
      ),
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
                        builder: (context) =>
                            ActivityDetailScreen(activity: activity),
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
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.attach_money,
                                        color: Colors.white, size: 18),
                                    SizedBox(width: 5),
                                    Text(
                                      activity.precio.toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: Colors.white, size: 18),
                                    SizedBox(width: 5),
                                    Text(
                                      activity.rating.toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
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

  Widget getSelectedWidget({required int index}){
    Widget widget;
    switch(index){
      case 0:
      
        widget =  ActivitiesScreen();
        break;
      case 1:
        widget =  HomePage();
        break;
      default:
        widget =  HomePage();
        break;
    }
    return widget;
  }
}
