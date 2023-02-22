import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actividades'),
      ),
      body: _activities.isNotEmpty
          ? ListView.builder(
        itemCount: _activities.length,
        itemBuilder: (BuildContext context, int index) {
          final activity = _activities[index];
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(activity.imagen),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.nombre,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(activity.descripcion),
                      SizedBox(height: 5),
                      Text(
                        '\$${activity.precio.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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