import 'package:flutter/material.dart';
import '../Service/comment_service.dart';

class CommentAction {
  final List<Map<String, dynamic>> posts;
  final Function setState;
  
  // Lưu trữ số lượng comment của từng post
  Map<String, int> commentCounts = {};

  CommentAction({
    required this.posts,
    required this.setState,
  });

  // Làm mới số lượng comment cho tất cả bài viết
  Future<void> refreshAllCommentCounts() async {
    for (var post in posts) {
      final postId = post['id'].toString();
      await refreshCommentCount(postId);
    }
  }

  // Làm mới số lượng comment của 1 bài viết
  Future<void> refreshCommentCount(String postId) async {
    try {
      final comments = await CommentService.getComments(postId);
      setState(() {
        commentCounts[postId] = comments.length;
      });
    } catch (e) {
      print('❌ Lỗi lấy số comment: $e');
    }
  }

  // Lấy số lượng comment (ưu tiên từ cache, fallback về post data)
  int getCommentCount(String postId, Map<String, dynamic> post) {
    return commentCounts[postId] ?? post['comment_count'] ?? 0;
  }

  // Tăng số lượng comment sau khi thêm comment mới
  void incrementCommentCount(String postId) {
    setState(() {
      commentCounts[postId] = (commentCounts[postId] ?? 0) + 1;
    });
  }

  // Giảm số lượng comment sau khi xóa comment
  void decrementCommentCount(String postId) {
    setState(() {
      final currentCount = commentCounts[postId] ?? 0;
      commentCounts[postId] = currentCount > 0 ? currentCount - 1 : 0;
    });
  }
}