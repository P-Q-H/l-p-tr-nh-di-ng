import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool liked;
  final VoidCallback onPressed;
  final int likeCount;

  const LikeButton({
    super.key,
    required this.liked,
    required this.onPressed,
    required this.likeCount,
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
