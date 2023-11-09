import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smile_app/connectiostring/api_connection.dart';
import 'package:http/http.dart' as http;
import 'exportdata.dart';

Future<void> deletePost(BuildContext context, int postId, String userId) async {
  try {
    final deleteUrl =
        Connection_String.delete_post + '?post_id=$postId&user_id=$userId';
    final response = await http.delete(Uri.parse(deleteUrl));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      String dialogTitle;
      String dialogContent;

      if (responseData['success'] == true) {
        dialogTitle = 'Success';
        dialogContent = responseData['message'];
        fetchPosts(); // Refresh posts
      } else {
        dialogTitle = 'Error';
        dialogContent = responseData['message'];
      }
      showDialog(
        context: context,
        builder: (context) {
          final dialog = AlertDialog(
            title: Text(dialogTitle),
            content: Text(dialogContent),
          );

          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pop(context);
          });

          return dialog;
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Error while deleting post'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      fetchPosts();
    }
  } catch (error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Error while deleting post: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    fetchPosts();
  }
}
