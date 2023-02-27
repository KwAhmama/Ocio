import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ocio_marakech/pages/activity.dart';
import 'package:ocio_marakech/utilities/sizes.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ActivityDetailScreen extends StatefulWidget {
  final Activity activity;

  ActivityDetailScreen({required this.activity});

  @override
  _ActivityDetailScreenState createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  bool isFavorite = false;
  late User? user;
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
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
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (error.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Color.fromARGB(255, 0, 121, 107),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.blockSizeVertical! * 50,
                child: Stack(
                  children: [
                    FullScreenSlider(
                      image: widget.activity.imagen,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(42),
                            topRight: Radius.circular(42),
                          ),
                          color: Color.fromARGB(255, 0, 121, 107),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 60,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    16.0,
                                  ),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Icon(Icons.arrow_back , color:Color.fromARGB(255, 0, 121, 107),),
                              ),
                            ),
                            InkWell(
                              onTap: toggleFavorite,
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    16,
                                  ),
                                  border: Border.all(
                                    color: Color(0xFFD7A949),
                                  ),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 16,
                ),
                child: Text(
                  widget.activity.nombre,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.blockSizeHorizontal! * 7,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 16,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal! * 2.5,
                ),
                height: 54,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ),
                  border: Border.all(
                    color: Color(0xFFD7A949),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person,     
                    color: Color(0xFFD7A949),     
                           
                    ),
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal! * 2.5,
                    ),
                    Text(
                      'Ver Comentarios',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color:Colors.white,
                        fontSize: SizeConfig.blockSizeHorizontal! * 3,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                ),
                child: Text(
                  widget.activity.descripcion,
                  style: TextStyle(
                    fontFamily:  'Georgia',
                    fontSize: SizeConfig.blockSizeHorizontal! * 4,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical! * 5,
              ),
            ],
          ),
        ),
      );
    }
  }
}

class FullScreenSlider extends StatefulWidget {
  final String image;

  FullScreenSlider({required this.image});

  @override
  _FullScreenSliderState createState() => _FullScreenSliderState();
}

class _FullScreenSliderState extends State<FullScreenSlider> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: SizeConfig.blockSizeVertical! * 50,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            initialPage: 0,
          ),
          items: [
            Center(
              child: Image.network(
                widget.image,
                fit: BoxFit.cover,
                height: SizeConfig.blockSizeVertical! * 50,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
