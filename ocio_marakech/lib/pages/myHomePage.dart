import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MyHomePage extends StatelessWidget {


  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }



  Future  <http.Response> getActivities() async {
    final response = await http.get(

      Uri.parse('https://hotelmarrakech-kwh-default-rtdb.firebaseio.com/actividades.json')
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  @override
  Widget build(BuildContext context) {
    getActivities();
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
      body: Center(


      ),
    );

  }
}