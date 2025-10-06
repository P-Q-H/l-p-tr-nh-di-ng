// hiển thị các bài đã thích
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../action/like.dart';

class LikedPostsScreen extends StatefulWidget {
  const LikedPostsScreen({super.key});

  @override
  State<LikedPostsScreen> createState() => _LikedPostsScreenState();
}

class _LikedPostsScreenState extends State<LikedPostsScreen> {
  List<Map<String, dynamic>> likedPosts = [];
  bool isLoading = true;
  String errorMessage = '';
  late LikeAction likeAction;

  @override
  void initState() {
    super.initState();
    likeAction = LikeAction(posts: likedPosts, setState: setState);
    fetchLikedPosts();
  }

  Future<void> fetchLikedPosts() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      setState(() {
        errorMessage = 'Vui lòng đăng nhập';
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.7:8000/api/posts/liked'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          likedPosts = List<Map<String, dynamic>>.from(
            (data['posts'] as List).map((post) => {
              'id': post['id'],
              'content': post['content'] ?? '',
              'image_url': post['image_url'],
              'pet_type': post['pet_type'] ?? '',
              'like_count': post['likes_count'] ?? 0,
              'user': post['user'] ?? {},
              'created_at': post['created_at'] ?? '',
            })
          );
          isLoading = false;
        });

        // Refresh trạng thái like cho tất cả bài viết
        await likeAction.refreshAllLikeStatus();
      } else {
        setState(() {
          errorMessage = 'Không thể tải bài viết đã thích';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi kết nối: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('❤️ Bài viết đã thích'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchLikedPosts,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: fetchLikedPosts,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : likedPosts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Chưa có bài viết nào được thích',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: fetchLikedPosts,
                      child: ListView.builder(
                        itemCount: likedPosts.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final post = likedPosts[index];
                          final postId = post['id'].toString();
                          final likeStatus = likeAction.likedPosts[postId];
                          final isLiked = likeStatus?['liked'] ?? true;
                          final likeCount = likeStatus?['count'] ?? post['like_count'];

                          return _buildPostCard(post, postId, isLiked, likeCount);
                        },
                      ),
                    ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post, String postId, bool isLiked, int likeCount) {
    final user = post['user'] as Map<String, dynamic>?;
    final userName = user?['name'] ?? 'Unknown';
    final petName = user?['pet_name'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar + Tên
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Text(userName[0].toUpperCase()),
            ),
            title: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: petName.isNotEmpty ? Text('🐾 $petName') : null,
            trailing: Chip(
              label: Text(post['pet_type'] ?? 'Khác'),
              backgroundColor: _getPetTypeColor(post['pet_type']),
            ),
          ),

          // Nội dung bài viết
          if (post['content']?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(post['content'], style: const TextStyle(fontSize: 15)),
            ),

          // Hình ảnh
          if (post['image_url'] != null && post['image_url'].isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                post['image_url'],
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 50),
                ),
              ),
            ),

          // Like button
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                  onPressed: () async {
                    await likeAction.toggleLike(postId);
                    // Nếu unlike thì xóa khỏi danh sách
                    final newStatus = likeAction.likedPosts[postId];
                    if (newStatus != null && !newStatus['liked']) {
                      setState(() {
                        likedPosts.removeWhere((p) => p['id'].toString() == postId);
                      });
                    }
                  },
                ),
                Text('$likeCount', style: const TextStyle(fontSize: 16)),
                const Spacer(),
                Text(
                  _formatDate(post['created_at']),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
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
}