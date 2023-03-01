import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ocio_marakech/components/my_textfield.dart';
import 'package:ocio_marakech/components/mybuttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  // sign user in method
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // WRONG EMAIL
      if (e.code == 'user-not-found') {
        // show error to user
        wrongEmailMessage();
      }

      // WRONG PASSWORD
      else if (e.code == 'wrong-password') {
        // show error to user
        wrongPasswordMessage();
      }
    }
  }

  // wrong email message popup
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.red,
          title: Center(
            child: Text(
              'Usuario inexistente',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // wrong password message popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.red,
          title: Center(
            child: Text(
              'Contraseña o email incorrecto',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  /* void signUserIn() {
 var connectSql = ConnectSql(user_name: emailController.text, user_pass: passwordController.text);
 Future<http.Response>? _futureAlbum;
 _futureAlbum = createAlbum("");

  }

  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              //
              // logo

              Image.asset(
                'lib/images/logo.png',
                height: 100,
                width: 100,
              ),

              const SizedBox(height: 50),

              Text(
                'Bienvenid@!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              // username textfield
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Contraseña',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // sign in button
              MyButton(
                onTap: signUserIn,
              ),


              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Continuar con',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // google + apple sign in buttons
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                // google button

                GestureDetector(
                  onTap: () {
                    signInWithGoogle();},
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: Image.asset(
                      'lib/images/google.png',
                      height: 40,
                    ),
                  ),
                )
              ]),

              // not a member? register now
            ],
          ),
        ),
      ),
    );
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void signInWithGoogle() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // sign in with Google
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      // authenticate with Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      // pop the loading circle
      Navigator.pop(context);
    } catch (e) {
      // pop the loading circle
      Navigator.pop(context);

      // show error to user
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Colors.red,
            title: Center(
              child: Text(
                'Error al iniciar sesión con Google',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      );
    }
  }
}
