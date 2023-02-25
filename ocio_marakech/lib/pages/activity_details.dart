import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ocio_marakech/pages/activity.dart';

class ActivityDetailScreen extends StatefulWidget {
  final Activity activity;

  ActivityDetailScreen({required this.activity});

  @override
  _ActivityDetailScreenState createState() => _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends State<ActivityDetailScreen> {
  int _rating = 0;
  TextEditingController _commentController = TextEditingController();
  bool _isFavorite = false;

  void _submitRating() {
    // TODO: send rating to the server
    setState(() {
      widget.activity.rating = _rating;
    });
  }

  void _submitComment() {
    // TODO: send comment to the server
    setState(() {
      widget.activity.comments.add(_commentController.text);
      _commentController.clear();
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activity.nombre),
      ),
      body: Column(
        children: [
          CachedNetworkImage(
            imageUrl: widget.activity.imagen,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Text(widget.activity.descripcion),
          Text('\$${widget.activity.precio.toStringAsFixed(2)}'),
          Row(
            children: [
              Text('Rating: '),
              for (int i = 1; i <= 5; i++)
                IconButton(
                  icon: Icon(
                    i <= _rating ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                  ),
                  onPressed: () => setState(() => _rating = i),
                ),
              ElevatedButton(
                onPressed: _submitRating,
                child: Text('Submit'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.activity.comments.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.comment),
                  title: Text(widget.activity.comments[index]),
                );
              },
            ),
          ),
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: 'Leave a comment',
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: _submitComment,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFavorite,
        child: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
