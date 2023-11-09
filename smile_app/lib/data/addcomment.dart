import 'package:smile_app/connectiostring/api_connection.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> postComment(String comment, String userId, int selectedPostId) async {
  if (selectedPostId != -1) {
    try {
      const url = Connection_String.create_cmment;
      final response = await http.post(
        Uri.parse(url),
        body: {
          'user_id': userId,
          'post_id': selectedPostId.toString(),
          'comment': comment,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          print("Comment posted successfully");
        } else {
          print("Failed to post comment");
        }
      } else {
        print("Error while posting comment");
      }
    } catch (error) {
      print('Error posting comment: $error');
    }
  }
}
