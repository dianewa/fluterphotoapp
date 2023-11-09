import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smile_app/connectiostring/api_connection.dart';
import 'package:smile_app/screens/CommentSection.dart';
import 'package:smile_app/screens/ImageDetailDialog%20.dart';
import 'package:smile_app/screens/likeandcomment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> posts = [];
  bool loading = true;
  String selectedFilter = "All";
  int selectedHours = 0; // Selected hours for filtering
  int selectedDayOfWeek = -1; // Selected day of the week for filtering
  String user_id = "";
  var apiAllUserUrl = Connection_String.get_all_post;

  @override
  void initState() {
    super.initState();
    // Load user_id when the widget initializes
    fetchPosts();
    getCred();
    // startAutoRefresh();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      user_id = pref.getString("user_id")!;
    });
  }

// Future<void> fetchAndRefreshPosts() async {
//   print('Fetching and refreshing posts...');
//   await fetchPosts();
//   Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
//     if (!mounted) {
//       timer.cancel();
//       return;
//     }
//     await fetchPosts();
//     print('Posts refreshed...');
//   });
// }


  Future<void> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse(apiAllUserUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          posts = List<Map<String, dynamic>>.from(jsonData['data']);
          loading = false;
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (error) {
      print('Error fetching posts: $error');
      setState(() {
        loading = false;
      });
    }
  }

  void _showImageDetail(BuildContext context, String imageUrl,
      String user_id, Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageDetailDialog(
          imageUrl: imageUrl,
          userId: user_id,
          post: post,
        );
      },
    );
  }

  int calculateDayOfWeek(int hours) {
    final now = DateTime.now();
    final currentTime = now.subtract(Duration(hours: hours));
    return currentTime.weekday;
  }

  void filterPosts(int hours, int dayOfWeek) {
    setState(() {
      selectedHours = hours;
      selectedDayOfWeek = dayOfWeek;
    });
    posts = posts.where((post) {
      final int postHours = int.tryParse(post['time_difference_hours']) ?? 0;
      final int postDayOfWeek = calculateDayOfWeek(postHours);
      return postHours <= hours &&
          (dayOfWeek == -1 || postDayOfWeek == dayOfWeek);
    }).toList();
  }
void refreshComments(Map<String, dynamic> updatedPost) {
  // Find the post in the 'posts' list by its 'post_id'
  final index = posts.indexWhere((post) => post['post_id'] == updatedPost['post_id']);

  if (index != -1) {
    // Update the comments for the specific post in the 'posts' list
    setState(() {
      posts[index]['comments'] = updatedPost['comments'];
    });
  }
}
  // void startAutoRefresh() {
  //   Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
  //     if (!mounted) {
  //       timer.cancel();
  //       return;
  //     }
  //     await fetchPosts();
  //     print('Posts refreshed...');
  //   });
  // }
void refreshPosts() {
  fetchPosts();
  print('Posts refreshed  wa kibwa we '); // Print a message after refreshing posts
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text("All"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (filter) {
              if (filter == "All") {
                filterPosts(0, -1); // Show all posts
              } else if (filter == "Day") {
                filterPosts(24, selectedDayOfWeek); // Show posts from the last 24 hours
              } else if (filter == "Week") {
                filterPosts(168, selectedDayOfWeek); // Show posts from the last week (7 days)
              } else if (filter == "Month") {
                filterPosts(720, selectedDayOfWeek); // Show posts from the last month (30 days)
              } else {
                // Handle custom time filter here
                // 'filter' will contain the selected hours as a string
                // You can parse it to an int and use it for filtering.
                final selectedHours = int.tryParse(filter) ?? 0;
                filterPosts(selectedHours, selectedDayOfWeek);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: "Day",
                  child: Text("Day"),
                ),
                const PopupMenuItem(
                  value: "Week",
                  child: Text("Week"),
                ),
                const PopupMenuItem(
                  value: "Month",
                  child: Text("Month"),
                ),
                // Add more options as needed
              ];
            },
          ),
        ],
      ),
body: loading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 images per row
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final postImageUrl = post['post_image_url'];
                final commentCount = post['comment_count'] ?? 0; // Handle null
                final likeCount = post['like_count'] ?? 0;
                // final user_id = post['user_id'];// Handle null

                return GestureDetector(
                  onTap: () {
                    _showImageDetail(context, postImageUrl, user_id, post);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            postImageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // CommentAndLikeCounts(
                        //   commentCount: commentCount,
                        //   likeCount: likeCount,
                        // ),
                      CommentSection(
                            post: post,
                            userId: user_id,
                            refreshPosts: refreshPosts, comments: [],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  
  }
}
