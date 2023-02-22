import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//run this for httpRequestError flutter run -d chrome --web-browser-flag "--disable-web-security"

class ConnectSql extends StatefulWidget {
  String user_name;
  String user_pass;

  ConnectSql({Key? key, required this.user_name, required this.user_pass})
      : super(key: key);

@override
  _ConnectSqlState createState() => _ConnectSqlState();





  }


  Future  <http.Response> createAlbum(String title) async {
    final response = await http.post(

      Uri.parse('http://192.168.202.229/SW-GestionHotelera-master/sw_user.php'),

        headers: {
          "Access-Control-Allow-Origin": "*", // Required for CORS support to work
          "Access-Control-Allow-Credentials":
          'true', // Required for cookies, authorization headers with HTTPS
          "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS"
        },
      body: jsonEncode(<String, String>{
      }),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
}







class _ConnectSqlState extends State<ConnectSql> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
