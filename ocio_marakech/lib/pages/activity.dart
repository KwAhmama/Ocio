import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Activity {
  final String nombre;
  final String descripcion;
  final String imagen;

  Activity({
    required this.nombre,
    required this.descripcion,
    required this.imagen,
  });

  factory Activity.fromJson(dynamic json) {
    return Activity(
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      imagen: json['imagen'] as String,
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
    final response = await http.get(Uri.parse('https://hotelmarrakech-kwh-default-rtdb.firebaseio.com/actividades.json'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Activity> activities = [];
      data.forEach((value) {
        activities.add(Activity.fromJson(value));
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
          return ListTile(
            title: Text(activity.nombre),
            subtitle: Text(activity.descripcion),
            leading: Image.network(activity.imagen),
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
