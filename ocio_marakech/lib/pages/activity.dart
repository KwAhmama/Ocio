import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ocio_marakech/pages/activity_details.dart';

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
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: _activities.isNotEmpty
          ? ListView.builder(
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
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      margin: EdgeInsets.all(15),
                      elevation: 10,

                      // Dentro de esta propiedad usamos ClipRRect
                      child: ClipRRect(
                        // Los bordes del contenido del card se cortan usando BorderRadius
                        borderRadius: BorderRadius.circular(30),

                        // EL widget hijo que será recortado segun la propiedad anterior
                        child: Column(
                          children: <Widget>[
                            // Usamos el widget Image para mostrar una imagen
                            CachedNetworkImage(
                              imageUrl: activity.imagen,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),

                            // Usamos Container para el contenedor de la descripción
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(activity.nombre),
                            ),
                          ],
                        ),
                      )),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

