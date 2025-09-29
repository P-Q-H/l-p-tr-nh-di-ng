import '../service/like_service.dart';

class LikeAction {
  final Map<String, Map<String, dynamic>> likedPosts = {};
  final List<Map<String, dynamic>> posts;
  final Function setState;

  LikeAction({required this.posts, required this.setState});

  Future<void> toggleLike(String postId) async {
    final liked = await LikeService.toggleLike(postId);
    if (liked != null) {
      await fetchLikeStatus(postId); // ✅ Lấy lại trạng thái và số tim thật từ server
    }
  }

  Future<void> fetchLikeStatus(String postId) async {
    final result = await LikeService.fetchLikeStatus(postId);
    if (result != null) {
      setState(() {
        likedPosts[postId] = {
          'liked': result['liked'],
          'count': result['count'],
        };

        // ✅ Cập nhật lại trong danh sách bài viết nếu có
        final index = posts.indexWhere((p) => p['id'].toString() == postId);
        if (index != -1) {
          posts[index]['like_count'] = result['count'];
        }
      });
    }
  }

  Future<void> refreshAllLikeStatus() async {
    for (var post in posts) {
      final postId = post['id'].toString();
      await fetchLikeStatus(postId);
    }
  }

  void clearLikes() {
    setState(() {
      likedPosts.clear();
    });
  }
}
