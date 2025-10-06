import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'like_post_screen.dart'; // ✅ Import màn hình đã thích

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
  int likedPostsCount = 0; // ✅ Thêm biến đếm số bài đã thích

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchLikedPostsCount(); // ✅ Lấy số bài đã thích
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

  // ✅ Lấy số lượng bài viết đã thích
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
            icon: const Icon(Icons.logout),
            onPressed: logout,
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
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/avatar.png'),
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
                          // ✅ Stat có thể ấn được
                          GestureDetector(
                            onTap: () async {
                              // Mở màn hình liked posts
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const LikedPostsScreen()),
                              );
                              // Refresh lại số lượng sau khi quay về
                              fetchLikedPostsCount();
                            },
                            child: _buildStat(likedPostsCount.toString(), 'Đã thích'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ✅ XÓA nút "Bài viết đã thích" cũ
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

// Widget hiển thị số liệu thống kê
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

// Widget hiển thị thông tin cá nhân
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