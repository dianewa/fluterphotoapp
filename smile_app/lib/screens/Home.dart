import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smile_app/screens/PostItem.dart';
import '../data/exportdata.dart'; 

class HomeScreen extends StatefulWidget {
  final String user_id;

  const HomeScreen({required this.user_id});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isCommentVisible = false;
  int selectedPostId = -1;
  TextEditingController commentController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  ScrollController _postsScrollController = ScrollController();
  bool loading = false; // Define the loading variable

  @override
  void dispose() {
    _postsScrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // fetchAndRefreshPosts();
  }

  // Future<void> fetchAndRefreshPosts() async {
  //   await fetchPosts();
  //   Timer.periodic(Duration(seconds: 5), (Timer timer) async {
  //     if (!mounted) {
  //       timer.cancel();
  //       return;
  //     }
  //     await fetchPosts();
  //   });
  // }

  void toggleCommentVisibility(String postId) {
    setState(() {
      isCommentVisible = !isCommentVisible;
      selectedPostId = isCommentVisible ? int.parse(postId) : -1;
    });
  }

  void clearSearch() {
    setState(() {
      searchController.clear();
    });
  }

  // Future<void> refreshPosts() async {
  //   await fetchAndRefreshPosts();
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Available post'),

            SizedBox(height: 20),
            TextField(
              controller: searchController,
              // onChanged: searchPosts,
              decoration: InputDecoration(
                hintText: 'Search...',
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: clearSearch,
                      )
                    : null,
              ),
            ),

            loading
                ? CircularProgressIndicator()
                : PostList(), // This widget will fetch and display posts

          ],
        ),
      ),
    );
  }
}
