import 'package:flutter/material.dart';
import '../data/exportdata.dart'; // Import your API function

class PostList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchPosts(), // Call the API function to fetch posts
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while data is being fetched
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No posts available.');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final post = snapshot.data![index];
              return PostItem(post: post); // Pass each post to the PostItem widget
            },
          );
        }
      },
    );
  }
}

class PostItem extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostItem({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ... Rest of your post item UI code goes here ...

          // Example: Display post image
          GestureDetector(
            onTap: () {
              // Handle image tap
            },
            child: Container(
              height: 200,
              color: Colors.yellow,
              child: Center(
                child: Image.network(
                  post['post_image_url'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
