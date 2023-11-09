import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smile_app/connectiostring/api_connection.dart';
import 'package:http/http.dart' as http;
import 'package:smile_app/screens/HomePage.dart';
import 'package:smile_app/screens/LikeButton.dart';

class CommentSection extends StatefulWidget {
  final Map<String, dynamic> post;
  final String userId;
  final void Function() refreshPosts; 
  CommentSection({
    required this.post,
    required this.userId,
    required this.refreshPosts, required List comments,
     // Initialize the callback
  });

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  TextEditingController commentController = TextEditingController();
void postComment() async {
  final response = await http.post(
    Uri.parse(Connection_String.create_cmment),
    body: {
      'user_id': widget.userId,
      'post_id': widget.post['post_id'],
      'comment': commentController.text,
    },
  );

  if (response.statusCode == 200) {
    // Comment posted successfully, handle the response as needed
    final responseData = json.decode(response.body);
    print('Response data: $responseData');

    // Clear the comment input field
    commentController.clear();

    // Trigger the callback to refresh comments
    widget.refreshPosts();
  } else {
    // Failed to post comment, handle the error
    print('Failed to post comment. Status code: ${response.statusCode}');
  }
}
Future<void> fetchComments() async {
  try {
    final response = await http.get(Uri.parse("http://192.168.1.94/flutter_test_project_API/user_account/all_comment.php"+ "?post_id=${widget.post['post_id']}"));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        widget.post['comments'] = List<String>.from(jsonData['data']);
      });
    } else {
      throw Exception('Failed to load comments');
    }
  } catch (error) {
    print('Error fetching comments: $error');
  }
}

void updateLikeCount(int updatedCount) {
  setState(() {
    widget.post['like_count'] = updatedCount;
  });
}
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
           LikeButton(
              userId: widget.userId,
              post: widget.post,
              // onLikeUpdated: updateLikeCount
            ),
            Text('Likes: ${widget.post['like_count'].toString()}'),
           IconButton(
              icon: Icon(Icons.comment),
              onPressed: () {
                // Toggle comment section visibility
                setState(() {
                  widget.post['showComments'] = !(widget.post['showComments'] ?? false);
                });

                // Fetch comments for the post when the comment section is opened
                if (widget.post['showComments'] == true) {
                  fetchComments();
                }
              },
            ),

          ],
        ),
       if (widget.post['showComments'] == true)
  Column(
    children: [
      // Display existing comments here if available
      for (final comment in widget.post['comments'])
        Text(comment),

      // Add a text field for adding comments
      TextFormField(
        controller: commentController,
        decoration: InputDecoration(
          hintText: 'Add a comment...',
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: postComment,
          ),
        ),
      ),
    ],
  ),

      ],
    );
  }
}
