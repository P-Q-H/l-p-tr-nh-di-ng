import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'PetProfile.dart';
import '../Service/post_service.dart';
import 'create_post_screen.dart';
import 'postDetailScreen.dart';
// import '../Service/comment_service.dart';
import '../action/comment.dart';

import 'profile.dart';

import 'package:gdmxhthucung/action/like.dart';
import 'package:gdmxhthucung/button/like_button.dart';
// import 'package:gdmxhthucung/service/like_service.dart';
import 'OtherUserProfile.dart';
// import 'FollowListScreen.dart';


class PetSocialHome extends StatefulWidget {
  const PetSocialHome({super.key});
  @override
  State<PetSocialHome> createState() => _PetSocialHomeState();
}

class _PetSocialHomeState extends State<PetSocialHome> {
  final nameController = TextEditingController();
  final breedController = TextEditingController();
  final descriptionController = TextEditingController();
  File? imageFile;
  bool isLoading = false;


  List<Map<String, dynamic>> posts = [];
  // posts = List<Map<String, dynamic>>.from(await PostService.fetchAllPosts());

  late LikeAction likeAction;
  late CommentAction commentAction; // ✅ Thêm CommentAction


  String selectedType = 'all';
  String? currentUserId;
  final List<String> petTypes = ['all', 'dog', 'cat', 'rabbit', 'hamster'];

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => currentUserId = prefs.getString('user_id'));
    await fetchPosts();
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => imageFile = File(picked.path));
  }

  Future<void> fetchPosts() async {
    final data = selectedType == 'all'
        ? await PostService.fetchAllPosts()
        : await PostService.fetchPostsByType(selectedType);

    // setState(() => posts = data);
    setState(() => posts = List<Map<String, dynamic>>.from(data)); // ✅ ép kiểu rõ ràng
    //  khởi tạo lại LikeAction và CommentAction với posts mới
    likeAction = LikeAction(posts: posts, setState: setState);
    commentAction = CommentAction(posts: posts, setState: setState);

    await likeAction.refreshAllLikeStatus();
    await commentAction.refreshAllCommentCounts(); // ✅ Làm mới số lượng comment
  }

  Future<void> submitPost() async {
    if (nameController.text.isEmpty || imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên thú cưng và chọn ảnh')),
      );
      return;
    }
    setState(() => isLoading = true);
    final error = await PostService.submitPost(
      petName: nameController.text,
      breed: breedController.text,
      description: descriptionController.text,
      petType: selectedType == 'all' ? 'dog' : selectedType,
      imageFile: imageFile!,
    );

    setState(() => isLoading = false);

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Bài viết đã được đăng')),
      );
      nameController.clear();
      breedController.clear();
      descriptionController.clear();
      setState(() => imageFile = null);
      await fetchPosts();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
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
        await fetchPosts();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('❌ Xóa thất bại')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Row(
                children: [
                  Icon(Icons.pets, color: Colors.white, size: 28),
                  SizedBox(width: 8),
                  Text('PetSocial', style: TextStyle(color: Colors.white, fontSize: 22)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Trang chủ'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Hồ sơ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PetProfile(petId: currentUserId ?? '')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Tạo bài viết'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CreatePostScreen(petType: selectedType)),
                );
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('Gợi ý theo dõi', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ...[
              {'name': 'PetLover123', 'info': 'Có 3 chú chó'},
              {'name': 'CatMom88', 'info': 'Có 2 chú mèo'},
              {'name': 'BunnyDad', 'info': 'Có 1 chú thỏ'},
            ].map((user) => ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(user['name']!),
                  subtitle: Text(user['info']!),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Theo dõi'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  ),
                )),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('PetSocial'),
        backgroundColor: Colors.orange[100],

        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final currentUserId = prefs.getString('user_id');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileScreen(userId: currentUserId ?? '')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _PetStory(name: 'Ban'),
                  _PetStory(name: 'doggy'),
                  _PetStory(name: 'cat_king'),
                  _PetStory(name: 'Golden'),
                  _PetStory(name: 'fluffy_p'),
                  _PetStory(name: 'bunny_'),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.all(12),
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tạo bài viết mới", style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: selectedType,
                      items: petTypes.map((type) {
                        return DropdownMenuItem(value: type, child: Text(type.toUpperCase()));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedType = value);
                          fetchPosts();
                        }
                      },
                    ),
                    TextField(controller: nameController, decoration: const InputDecoration(labelText: "Tên thú cưng")),
                    TextField(controller: breedController, decoration: const InputDecoration(labelText: "Giống loài")),
                    TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Mô tả")),
                    const SizedBox(height: 10),
                    imageFile != null
                        ? Image.file(imageFile!, height: 150)
                        : OutlinedButton.icon(
                            onPressed: pickImage,
                            icon: const Icon(Icons.image),
                            label: const Text("Thêm ảnh"),
                          ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: isLoading ? null : submitPost,
                      icon: const Icon(Icons.send),
                      label: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Đăng bài viết"),
                    ),
                  ],
                              ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                "Bài viết gần đây (${selectedType.toUpperCase()})",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ...posts.map((post) {
              final postId = post['id'].toString();
              final isOwner = post['user_id'].toString() == currentUserId;

              return Card(
                margin: const EdgeInsets.all(8),
                color: Colors.orange[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // xem thông tin người dùng bằng cách nhấn vào tên hoặc ảnh đại diện
                    ListTile(
                      leading: GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtherUserProfileScreen(
          userId: post['user_id'].toString(),
          userName: post['username'],
        ),
      ),
    );
  },
  child: CircleAvatar(
    radius: 20,
    backgroundImage: post['avatar_url'] != null
        ? NetworkImage(post['avatar_url'])
        : null,
    backgroundColor: Colors.grey[200],
    child: post['avatar_url'] == null
        ? const Icon(Icons.person, color: Colors.grey)
        : null,
  ),

                      ),
                      title: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OtherUserProfileScreen(
                                userId: post['user_id'].toString(),
                                userName: post['username'],
                              ),
                            ),
                          );
                        },
                        child: Text(
                          post['username'],
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      subtitle: Text('${post['pet_name']} - ${post['breed']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(post['created_at']),
                          if (isOwner)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => confirmDelete(postId),
                            ),
                        ],
                      ),
                    ),
// hiển thị ảnh nếu có
                    if (post['image'] != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'http://192.168.1.7:8000/storage/${post['image']}',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(child: Text('Không tải được ảnh')),
                        ),
                      ),
                      const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(post['description']),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                    LikeButton(
                      liked: likeAction.likedPosts[postId]?['liked'] == true,
                      likeCount: likeAction.likedPosts[postId]?['count'] ?? post['like_count'] ?? 0,
                      onPressed: () => likeAction.toggleLike(postId),
                    ),

                         IconButton(
                          icon: const Icon(Icons.comment),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PostDetailScreen(post: post),
                              ),
                            );
                          },
                        ),

                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              // xử lý chia sẻ
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _PetStory extends StatelessWidget {
  final String name;
  const _PetStory({required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          const CircleAvatar(radius: 30, child: Icon(Icons.pets)),
          Text(name, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

