import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'PetProfile.dart';
import '../Service/post_service.dart';
import 'create_post_screen.dart';
// import 'postDetailScreen.dart';
import 'profile.dart';
//thêm like, comment, share
import 'package:gdmxhthucung/action/like.dart';
import 'package:gdmxhthucung/action/comment.dart';
import 'package:gdmxhthucung/action/share.dart';
// service like (gọi api like)
import 'package:gdmxhthucung/service/like_service.dart';


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

  List<dynamic> posts = [];
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
  setState(() => posts = data);

  // ✅ Gọi trạng thái like sau khi có danh sách bài viết
  for (var post in data) {
    final postId = post['id'].toString();
    fetchLikeStatus(postId);
  }
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
  //Like bài viết 
Future<void> toggleLike(String postId) async {
  print('Toggling like for postId: $postId');
  final liked = await LikeService.toggleLike(postId);
  print('Liked result: $liked');

  if (liked != null) {
    setState(() {
      final index = posts.indexWhere((p) => p['id'].toString() == postId);
      if (index != -1) {
        int currentCount = (posts[index]['like_count'] ?? 0) as int;

        // ✅ Cập nhật số like
        int newCount = liked
            ? currentCount + 1
            : currentCount > 0 ? currentCount - 1 : 0;

        posts[index]['like_count'] = newCount;

        // ✅ Cập nhật trạng thái vào likedPosts
       likedPosts[postId] = {
        'liked': liked,
        'count': posts[index]['like_count'],
      };
      }
    });
  }
}



// Lấy trạng thái like ban đầu cho mỗi bài viết
Future<void> fetchLikeStatus(String postId) async {
  final result = await LikeService.fetchLikeStatus(postId);
  if (result != null) {
    setState(() {
      likedPosts[postId] = {
        'liked': result['liked'] == true,
        'count': result['count'] ?? 0,
      };
    });
  } else {
    print('Không lấy được trạng thái like cho postId: $postId');
  }
}



void logout() {
  setState(() {
    likedPosts.clear(); // ✅ xóa trạng thái like
  });

  // Thêm các bước đăng xuất khác nếu có
  Navigator.pushReplacementNamed(context, '/login');
}

 Map<String, Map<String, dynamic>> likedPosts = {}; // ✅ lưu cả trạng thái và số like
// ✅ lưu trạng thái tim theo postId


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
                leading: const Icon(Icons.search),
                title: const Text('Tìm kiếm'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.pets),
                title: const Text('Dịch vụ'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Thông báo'),
                onTap: () => Navigator.pop(context),
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
                leading: const Icon(Icons.settings),
                title: const Text('Cài đặt'),
                onTap: () => Navigator.pop(context),
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
        // chuyển qua trang profile.dart
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async{
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
              final isOwner = post['user_id'].toString() == currentUserId;// kiểm tra chủ bài viết
               final postId = post['id'].toString(); // ✅ đặt ở đây để sử dụng trong LikeButton
              return Card(
                margin: const EdgeInsets.all(8),
                color: Colors.orange[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(post['username']),
                      subtitle: Text('${post['pet_name']} - ${post['breed']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(post['created_at']),
                          if (isOwner)
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => confirmDelete(post['id'].toString()),
                            ),
                        ],
                      ),
                    ),
                    if (post['image'] != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'http://192.168.1.7:8000/storage/${post['image']}',
                          height: 200,
                          width: double.infinity, // ✅ chiếm toàn bộ chiều ngang
                          fit: BoxFit.cover,      // ✅ giữ tỷ lệ ảnh đẹp
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(child: Text('Không tải được ảnh')),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(post['description']),
                    ),
                    
                    // Thêm nút like, comment, share
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        LikeButton(
                          liked: likedPosts[postId]?['liked'] == true,
                          likeCount: likedPosts[postId]?['count'] ?? post['like_count'] ?? 0,
                          onPressed: () => toggleLike(postId),
                        ),
                        CommentButton(
                          onPressed: () {
                            // xử lý bình luận
                          },
                        ),
                        ShareButton(
                          onPressed: () {
                            // xử lý chia sẻ
                          },
                        ),
                      ],
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
