import 'package:flutter/material.dart';

class CommentAndLikeCounts extends StatelessWidget {
  final String commentCount;
  final String  likeCount;

  CommentAndLikeCounts({
    required this.commentCount,
    required this.likeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                const Icon(
                    Icons.thumb_up,
                    size: 24, // Adjust the size as needed
                    color: Colors.blue, // Adjust the color as needed
                  ),
                  SizedBox(width: 5,),
                Text(likeCount,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(
              children: [
                 const Icon(
                    Icons.comment,
                    size: 24, // Adjust the size as needed
                    color: Colors.white, // Adjust the color as needed
                  ),
                  SizedBox(width: 5,),
                Text(
                  '$commentCount',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
