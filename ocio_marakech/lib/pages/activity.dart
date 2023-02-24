import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class Activity {
  String nombre;
  String descripcion;
  String imagen;
  double precio;

  Activity({
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    required this.precio,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      imagen: json['imagen'] ?? '',
      precio: (json['precio'] ?? 0).toDouble(),
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
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
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
                return Card(
                  child: ListTile(
                    title: Text(activity.nombre),
                    subtitle: Text(activity.descripcion),
                    leading: Image.network(
                      "https://drive.google.com/uc?export=view&id=" +
                          activity.imagen,
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.cover,
                    ),
                    trailing: Text(
                      '${activity.precio}' + '€',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
