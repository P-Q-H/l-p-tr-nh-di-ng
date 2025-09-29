import 'package:flutter/material.dart';
import '../Service/post_service.dart';
import 'create_post_screen.dart';
import 'postDetailScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<dynamic> posts = [];
  String selectedType = 'dog';
  String? currentUserId;
  final List<String> petTypes = ['dog', 'cat', 'rabbit', 'hamster'];

  @override
  void initState() {
    super.initState();
    loadUserId();
    fetchPostsByType(selectedType);
  }

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => currentUserId = prefs.getString('user_id'));
  }

  Future<void> fetchPostsByType(String type) async {
    final data = await PostService.fetchPostsByType(type);
    setState(() => posts = data);
  }

  Future<void> goToCreatePost() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreatePostScreen(petType: selectedType)),
    );
    if (result == 'posted') {
      await fetchPostsByType(selectedType);
    }
  }

  Future<void> confirmDelete(String postId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa bài viết này?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa')),
        ],
      ),
    );

    if (confirm == true) {
      final success = await PostService.deletePost(postId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Đã xóa bài viết')));
        await fetchPostsByType(selectedType);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Xóa thất bại')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PetSocial'),
        backgroundColor: Colors.orange[100],
        actions: [
          IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: goToCreatePost),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            color: Colors.yellow[100],
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: petTypes.length,
              itemBuilder: (context, index) {
                final type = petTypes[index];
                final isSelected = type == selectedType;
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedType = type);
                    fetchPostsByType(type);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.yellow[300] : Colors.yellow[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(type.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: posts.isEmpty
                ? const Center(child: Text('Không có bài viết nào'))
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      final isOwner = post['user_id'].toString() == currentUserId;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(post['pet_name']),
                                subtitle: Text(post['breed']),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(post['username']),
                                    if (isOwner)
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => confirmDelete(post['id'].toString()),
                                      ),
                                  ],
                                ),
                              ),
                              if (post['image'] != null)
                                Image.network('http://192.168.1.7:8000/storage/${post['image']}'),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(post['description']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
