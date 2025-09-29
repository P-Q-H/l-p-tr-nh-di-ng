import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CommentButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.comment),
      onPressed: onPressed,
    );
  }
}
