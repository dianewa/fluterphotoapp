import 'package:http/http.dart' as http;
import 'package:smile_app/connectiostring/api_connection.dart';
import 'dart:convert';

Future<List<Map<String, dynamic>>> fetchPosts() async {
  try {
    var apiAllUserUrl = Connection_String.get_all_post;
    final response = await http.get(Uri.parse(apiAllUserUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return List<Map<String, dynamic>>.from(jsonData['data']);
    } else {
      throw Exception('Failed to load posts: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching posts: $error');
    throw Exception('Failed to load posts: $error');
  }
}


