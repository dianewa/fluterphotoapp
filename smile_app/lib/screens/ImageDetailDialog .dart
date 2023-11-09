import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:smile_app/screens/CommentSection.dart';
import 'package:smile_app/screens/LikeButton.dart';

class ImageDetailDialog extends StatefulWidget {
  final String imageUrl;
  final String userId;
  final Map<String, dynamic> post;

  ImageDetailDialog({required this.imageUrl, required this.userId, required this.post});

  @override
  _ImageDetailDialogState createState() => _ImageDetailDialogState();
}

class _ImageDetailDialogState extends State<ImageDetailDialog> {
  late Future<List<dynamic>> comments;

  @override
  void initState() {
    super.initState();
    comments = fetchComments();
  }

  Future<List<dynamic>> fetchComments() async {
    final response = await http.get(
        Uri.parse('YOUR_ENDPOINT_URL_HERE')); // Replace with your endpoint URL

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to load comments');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: double.maxFinite,
        height: 300,
        child: FutureBuilder<List<dynamic>>(
          future: comments,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final List<dynamic> comments = snapshot.data!;
              return Column(
                children: [
                  Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      LikeButton(
                        userId: widget.userId,
                        post: widget.post,
                      ),
                      Text('Likes: ${widget.post['like_count'].toString()}'),
                    ],
                  ),
                  SizedBox(height: 16),
                  CommentSection(
                    post: widget.post,
                    userId: widget.userId,
                    comments: comments, refreshPosts: () {  }, // Pass the comments to CommentSection
                  ),
                ],
              );
            }
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
