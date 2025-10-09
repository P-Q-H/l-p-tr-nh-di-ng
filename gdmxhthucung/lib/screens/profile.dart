import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'login.dart';
import 'like_post_screen.dart';
import 'settings.dart';
import 'privacy.dart';

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
  String? avatarUrl;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchLikedPostsCount();
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
      } else if (response.statusCode == 404) {
        setState(() {
          errorMessage = 'Không tìm thấy người dùng';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Lỗi không xác định (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi kết nối đến máy chủ';
        isLoading = false;
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
      // Không hiển thị lỗi, chỉ giữ giá trị mặc định
    }
  }

  // Chọn ảnh từ thư viện hoặc camera
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadAvatar();
    }
  }

  // Upload ảnh đại diện lên server
  Future<void> _uploadAvatar() async {
    if (_imageFile == null) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.7:8000/api/users/${widget.userId}/avatar'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath('avatar', _imageFile!.path),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật ảnh đại diện thành công')),
        );
        fetchUserInfo();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi khi upload ảnh')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi kết nối')),
      );
    }
  }

  // Hiển thị dialog chọn nguồn ảnh
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

  // Hiển thị menu tùy chọn
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
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Quyền riêng tư'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PrivacyScreen(userId: widget.userId),
                  ),
                );
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
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar với nút thay đổi
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!)
                                : (avatarUrl != null
                                    ? NetworkImage(avatarUrl!)
                                    : const AssetImage('assets/avatar.png')) as ImageProvider,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStat('127', 'Bài viết'),
                          _buildStat('1248', 'Theo dõi'),
                          _buildStat('89', 'Đang theo dõi'),

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
                      const SizedBox(height: 24),                      
                      const Divider(),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Thông tin cá nhân',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('📧 Email', email),
                      _buildInfoRow('🐾 Thú cưng', petName),
                      _buildInfoRow('🗓️ Ngày tham gia', createdAt),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: logout,
                        icon: const Icon(Icons.logout),
                        label: const Text('Đăng xuất'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                        ),
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


Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
  );
}