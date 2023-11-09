import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smile_app/connectiostring/api_connection.dart';
import 'package:http/http.dart' as http;

class LikeButton extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> post;


  LikeButton({required this.userId, required this.post});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.favorite),
      onPressed: () async {
        try {
          if (post['post_id'] != null) {
            print('Sending like request...');
            final response = await http.post(
              Uri.parse(Connection_String.like),
              body: {
                'user_id': userId,
                'post_id': post['post_id'],
              },
            );

            print('Response status code: ${response.statusCode}');
            print('Response body: ${response.body}');

            if (response.statusCode == 200) {
              final responseData = json.decode(response.body);
              print('Response data: $responseData');
              if (responseData['success'] == true) {
                post['like_count'] = int.tryParse(responseData['like_count']) ?? 0;
              }
            } else {
              print('Failed to send like request. Status code: ${response.statusCode}');
            }
          } else {
            print('Invalid userId or post data.');
          }
        } catch (error) {
          print('Error sending like request: $error');
        }
      },
    );
  }
}


