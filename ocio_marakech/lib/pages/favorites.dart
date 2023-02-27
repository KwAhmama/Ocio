import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ocio_marakech/models/activities.dart';
import 'package:ocio_marakech/pages/activity_details.dart';
import 'package:ocio_marakech/pages/home_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Favoritos {
  String idActividad;
  String idUsuario;

  Favoritos({
    required this.idActividad,
    required this.idUsuario,
  });

  factory Favoritos.fromJson(Map<String, dynamic> json) {
    return Favoritos(
      idActividad: json['idActividad'],
      idUsuario: json['idUsuario'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'idActividad': idActividad,
      'idUsuario': idUsuario,
    };
  }
}

class FavoriteScrren extends StatefulWidget {
  @override
  _FavoriteScrrenState createState() => _FavoriteScrrenState();
}

class _FavoriteScrrenState extends State<FavoriteScrren> {
  List<Activity> _activities = [];
  User? user;
  bool isLoading = true;
  String error = '';
  List<Favoritos> _favAct = [];
  List<Activity> _actividadesFav = [];

  @override
  void initState() {
    super.initState();
    _getActivities();
    _getFavorites();
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

  Future<void> _getFavorites() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      setState(() {
        user = currentUser;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }

    final response = await http.get(Uri.parse(
        'https://hotelmarrakech-kwh-default-rtdb.firebaseio.com/favoritos.json'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Favoritos> favAct = [];
      int i = 0;
      data.forEach((value) {
        final favoritosData = value as Map<String, dynamic>;
        favAct.add(Favoritos.fromJson(favoritosData));
      });

      setState(() {
        _favAct = favAct;

        // Agregar habitaciones favoritas a la lista _actividadesFav
        for (var i = 0; i < _favAct.length; i++) {
          var fav = _favAct[i];
          if (fav.idUsuario == user?.email) {

           _actividadesFav.add(_activities[int.parse(fav.idActividad)]);

          }
        }
      });
    } else {
      throw Exception('Error en la solicitud HTTP: ${response.statusCode}');
    }
  }

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: _actividadesFav.isNotEmpty
          ? ListView.builder(
              itemCount: _actividadesFav.length,
              itemBuilder: (BuildContext context, int index) {
                final activity = _actividadesFav[index];
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
