import 'package:flutter/material.dart'; // ✅ đủ để dùng IconButton, Row, Text, Colors
class LikeButton extends StatelessWidget {
  final bool liked;
  final int likeCount;
  final VoidCallback onPressed;

  const LikeButton({
    super.key,
    required this.liked,
    required this.likeCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            liked ? Icons.favorite : Icons.favorite_border,
            color: liked ? Colors.red : Colors.grey,
          ),
          onPressed: onPressed,
        ),
        Text('$likeCount'),
      ],
    );
  }
}
