import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'login.dart';
import 'like_post_screen.dart';
import 'settings.dart';
import 'Privacy.dart';
import 'FollowListScreen.dart';
import '../ThemeNotifier/ProfileRefreshNotifier.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String email = '';
  String petName = '';
  String createdAt = '';
  bool isLoading = true;
  String errorMessage = '';
  int likedPostsCount = 0;
  int userPostsCount = 0;
  int followersCount = 0;
  int followingCount = 0;
  String? avatarUrl;
  File? _imageFile;
  List<dynamic> userPosts = [];
  bool isLoadingPosts = false;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchLikedPostsCount();
    fetchUserPosts();
    fetchFollowStats();
  }

  Future<void> fetchUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || widget.userId.isEmpty) {
      setState(() {
        errorMessage = 'Không có thông tin đăng nhập hoặc userId';
        isLoading = false;
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.7:8000/api/users/${widget.userId}'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          name = data['name'] ?? '';
          email = data['email'] ?? '';
          petName = data['pet_name'] ?? '';
          createdAt = data['created_at']?.substring(0, 10) ?? '';
          avatarUrl = data['avatar_url'];
          _imageFile = null;
          isLoading = false;
        });
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        setState(() {
          errorMessage = 'Phiên đăng nhập đã hết hạn';
          isLoading = false;
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      } else {
        setState(() {
          errorMessage = 'Lỗi không xác định (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi kết nối đến máy chủ: $e';
        isLoading = false;
      });
    }
  }

  Future<void> fetchUserPosts() async {
    setState(() {
      isLoadingPosts = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.7:8000/api/posts'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final allPosts = data['data'] as List;
        
        // Lọc chỉ lấy bài viết của user hiện tại
        final filteredPosts = allPosts.where((post) {
          return post['user_id'].toString() == widget.userId;
        }).toList();

        setState(() {
          userPosts = filteredPosts;
          userPostsCount = filteredPosts.length;
          isLoadingPosts = false;
        });
      } else {
        setState(() {
          isLoadingPosts = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingPosts = false;
      });
    }
  }

  Future<void> fetchLikedPostsCount() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

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
          likedPostsCount = data['total'] ?? 0;
        });
      }
    } catch (e) {
      // Không hiển thị lỗi
    }
  }

  Future<void> fetchFollowStats() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.7:8000/api/users/${widget.userId}/follow-stats'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          followersCount = data['followers_count'] ?? 0;
          followingCount = data['following_count'] ?? 0;
        });
      }
    } catch (e) {
      // Không hiển thị lỗi
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        await _uploadAvatar();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chọn ảnh: $e')),
      );
    }
  }

  Future<void> _uploadAvatar() async {
    if (_imageFile == null) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa đăng nhập')),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.7:8000/api/users/${widget.userId}/avatar'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      
      request.files.add(
        await http.MultipartFile.fromPath(
          'avatar',
          _imageFile!.path,
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      Navigator.pop(context);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật ảnh đại diện thành công')),
        );
        await fetchUserInfo();
      } else {
        try {
          final errorData = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${errorData['error'] ?? errorData['message'] ?? 'Không thể upload ảnh'}')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi kết nối: $e')),
      );
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn ảnh đại diện'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Thư viện ảnh'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Chụp ảnh'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Cài đặt'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Quyền riêng tư'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PrivacyScreen(userId: widget.userId),
                  ),
                );
                if (result == true) {
                  fetchUserInfo();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _deletePost(String postId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    try {
      final response = await http.delete(
        Uri.parse('http://192.168.1.7:8000/api/posts/$postId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xóa bài viết')),
        );
        fetchUserPosts();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi khi xóa bài viết')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  void _showDeleteConfirmation(String postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa bài viết này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePost(postId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ người dùng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: _showOptionsMenu,
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
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(errorMessage, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            errorMessage = '';
                          });
                          fetchUserInfo();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await fetchUserInfo();
                    await fetchLikedPostsCount();
                    await fetchUserPosts();
                    await fetchFollowStats();
                  },
                  child: CustomScrollView(
                    slivers: [
                      // Header với thông tin user
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Avatar
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage: _imageFile != null
                                        ? FileImage(_imageFile!)
                                        : (avatarUrl != null && avatarUrl!.isNotEmpty
                                            ? NetworkImage(avatarUrl!)
                                            : null) as ImageProvider?,
                                    child: (avatarUrl == null || avatarUrl!.isEmpty) && _imageFile == null
                                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                                        : null,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: _showImageSourceDialog,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2),
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                name,
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '@${widget.userId}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Yêu thú cưng và chia sẻ những khoảnh khắc đáng yêu của các bé 🐾',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 16),
                              // Stats
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStat(userPostsCount.toString(), 'Bài viết'),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => FollowListScreen(
                                            userId: widget.userId,
                                            isFollowers: true,
                                            title: 'Người theo dõi',
                                          ),
                                        ),
                                      ).then((_) => fetchFollowStats());
                                    },
                                    child: _buildStat(followersCount.toString(), 'Theo dõi'),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => FollowListScreen(
                                            userId: widget.userId,
                                            isFollowers: false,
                                            title: 'Đang theo dõi',
                                          ),
                                        ),
                                      ).then((_) => fetchFollowStats());
                                    },
                                    child: _buildStat(followingCount.toString(), 'Đang theo dõi'),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const LikedPostsScreen()),
                                      );
                                      fetchLikedPostsCount();
                                    },
                                    child: _buildStat(likedPostsCount.toString(), 'Đã thích'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                            ],
                          ),
                        ),
                      ),
                      // Grid bài viết
                      SliverPadding(
                        padding: const EdgeInsets.all(2),
                        sliver: isLoadingPosts
                            ? const SliverFillRemaining(
                                child: Center(child: CircularProgressIndicator()),
                              )
                            : userPosts.isEmpty
                                ? const SliverFillRemaining(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.photo_library_outlined, size: 64, color: Colors.grey),
                                          SizedBox(height: 16),
                                          Text(
                                            'Chưa có bài viết nào',
                                            style: TextStyle(fontSize: 16, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SliverGrid(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 2,
                                      mainAxisSpacing: 2,
                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final post = userPosts[index];
                                        final imageUrl = post['image'] != null
                                            ? 'http://192.168.1.7:8000/storage/${post['image']}'
                                            : null;

                                        return GestureDetector(
                                          onTap: () {
                                            // Hiển thị chi tiết bài viết
                                            _showPostDetail(post);
                                          },
                                          onLongPress: () {
                                            // Xóa bài viết
                                            _showDeleteConfirmation(post['id'].toString());
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              image: imageUrl != null
                                                  ? DecorationImage(
                                                      image: NetworkImage(imageUrl),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : null,
                                            ),
                                            child: imageUrl == null
                                                ? const Icon(Icons.image, color: Colors.grey)
                                                : null,
                                          ),
                                        );
                                      },
                                      childCount: userPosts.length,
                                    ),
                                  ),
                      ),
                    ],
                  ),
                ),
    );
  }

  void _showPostDetail(dynamic post) {
    final imageUrl = post['image'] != null
        ? 'http://192.168.1.7:8000/storage/${post['image']}'
        : null;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['pet_name'] ?? '',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (post['breed'] != null) ...[
                    const SizedBox(height: 4),
                    Text('Giống: ${post['breed']}'),
                  ],
                  if (post['description'] != null) ...[
                    const SizedBox(height: 8),
                    Text(post['description']),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    'Đăng lúc: ${post['created_at']}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showDeleteConfirmation(post['id'].toString());
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Xóa', style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Đóng'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildStat(String value, String label) {
  return Column(
    children: [
      Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    ],
  );
}