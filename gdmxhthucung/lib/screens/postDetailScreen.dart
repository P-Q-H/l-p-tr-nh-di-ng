import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/comment_service.dart';
import '../action/like.dart';

class PostDetailScreen extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  List<Map<String, dynamic>> comments = [];
  bool isLoadingComments = true;
  final TextEditingController _commentController = TextEditingController();
  String? currentUserId;
  late LikeAction likeAction;

  @override
  void initState() {
    super.initState();
    likeAction = LikeAction(posts: [widget.post], setState: setState);
    loadComments();
    getCurrentUserId();
    loadLikeStatus(); // ✅ Load trạng thái like khi mở màn hình
  }

  Future<void> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('user_id');
    });
  }

  // ✅ Load trạng thái like từ server
  Future<void> loadLikeStatus() async {
    final postId = widget.post['id'].toString();
    await likeAction.fetchLikeStatus(postId);
  }

  Future<void> loadComments() async {
    setState(() => isLoadingComments = true);
    final postId = widget.post['id'].toString();
    final fetchedComments = await CommentService.getComments(postId);
    setState(() {
      comments = fetchedComments;
      isLoadingComments = false;
    });
  }

  Future<void> addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final postId = widget.post['id'].toString();
    final content = _commentController.text.trim();

    final newComment = await CommentService.addComment(postId, content);

    if (newComment != null) {
      setState(() {
        comments.insert(0, newComment);
        _commentController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã thêm bình luận')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể thêm bình luận')),
      );
    }
  }

  Future<void> deleteComment(String commentId) async {
    final success = await CommentService.deleteComment(commentId);
    if (success) {
      setState(() {
        comments.removeWhere((c) => c['id'].toString() == commentId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xóa bình luận')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final postId = widget.post['id'].toString();
    final likeStatus = likeAction.likedPosts[postId];
    final isLiked = likeStatus?['liked'] ?? false;
    final likeCount = likeStatus?['count'] ?? widget.post['like_count'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết bài viết'),
      ),
      body: Column(
        children: [
          // Bài viết
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Avatar + Tên
                  _buildPostHeader(),

                  // Nội dung
                  if (widget.post['content']?.isNotEmpty ?? false)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        widget.post['content'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),

                  // Hình ảnh
                  if (widget.post['image_url'] != null &&
                      widget.post['image_url'].isNotEmpty)
                    Image.network(
                      widget.post['image_url'],
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 300,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 50),
                      ),
                    ),

                  // Like & Comment count
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                          ),
                          onPressed: () => likeAction.toggleLike(postId),
                        ),
                        Text('$likeCount'),
                        const SizedBox(width: 16),
                        const Icon(Icons.comment, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('${comments.length}'),
                      ],
                    ),
                  ),

                  const Divider(thickness: 8),

                  // Danh sách bình luận
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Bình luận (${comments.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  isLoadingComments
                      ? const Center(child: CircularProgressIndicator())
                      : comments.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(32),
                              child: Center(
                                child: Text(
                                  'Chưa có bình luận nào.\nHãy là người đầu tiên bình luận!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                return _buildCommentItem(comments[index]);
                              },
                            ),
                ],
              ),
            ),
          ),

          // Input bình luận
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildPostHeader() {
    final user = widget.post['user'] as Map<String, dynamic>?;
    final userName = user?['name'] ?? 'Unknown';
    final petName = user?['pet_name'] ?? '';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(userName[0].toUpperCase()),
      ),
      title: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: petName.isNotEmpty ? Text('🐾 $petName') : null,
      trailing: widget.post['pet_type'] != null
          ? Chip(
              label: Text(widget.post['pet_type']),
              backgroundColor: _getPetTypeColor(widget.post['pet_type']),
            )
          : null,
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    final user = comment['user'] as Map<String, dynamic>?;
    final userName = user?['name'] ?? 'Unknown';
    final userId = user?['id']?.toString();
    final isMyComment = userId == currentUserId;

    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.purple[100],
        child: Text(userName[0].toUpperCase()),
      ),
      title: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(comment['content']),
          const SizedBox(height: 4),
          Text(
            _formatDate(comment['created_at']),
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
      trailing: isMyComment
          ? IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: () => _confirmDelete(comment['id'].toString()),
            )
          : null,
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Viết bình luận...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: addComment,
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String commentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa bình luận'),
        content: const Text('Bạn có chắc muốn xóa bình luận này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteComment(commentId);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _getPetTypeColor(String? petType) {
    switch (petType?.toLowerCase()) {
      case 'dog':
        return Colors.orange[100]!;
      case 'cat':
        return Colors.purple[100]!;
      case 'bird':
        return Colors.blue[100]!;
      default:
        return Colors.grey[200]!;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays > 7) {
        return '${date.day}/${date.month}/${date.year}';
      } else if (diff.inDays > 0) {
        return '${diff.inDays} ngày trước';
      } else if (diff.inHours > 0) {
        return '${diff.inHours} giờ trước';
      } else if (diff.inMinutes > 0) {
        return '${diff.inMinutes} phút trước';
      } else {
        return 'Vừa xong';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}