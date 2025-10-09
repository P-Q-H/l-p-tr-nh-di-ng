import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PrivacyScreen extends StatefulWidget {
  final String userId;
  const PrivacyScreen({super.key, required this.userId});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  String name = '';
  String email = '';
  String petName = '';
  String phone = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

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
          phone = data['phone'] ?? '';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showEditAccountDialog() {
    final nameController = TextEditingController(text: name);
    final petNameController = TextEditingController(text: petName);
    final phoneController = TextEditingController(text: phone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chỉnh sửa tài khoản'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: petNameController,
                decoration: const InputDecoration(
                  labelText: 'Tên thú cưng',
                  prefixIcon: Icon(Icons.pets),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _updateAccount(
                nameController.text,
                petNameController.text,
                phoneController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateAccount(String newName, String newPetName, String newPhone) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.7:8000/api/users/${widget.userId}'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'name': newName,
          'pet_name': newPetName,
          'phone': newPhone,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật thông tin thành công')),
        );
        _loadUserInfo();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi khi cập nhật thông tin')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi kết nối')),
      );
    }
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đổi mật khẩu'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu hiện tại',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu mới',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Xác nhận mật khẩu mới',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mật khẩu xác nhận không khớp')),
                );
                return;
              }
              if (newPasswordController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mật khẩu phải có ít nhất 6 ký tự')),
                );
                return;
              }
              await _changePassword(
                currentPasswordController.text,
                newPasswordController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Đổi mật khẩu'),
          ),
        ],
      ),
    );
  }

  Future<void> _changePassword(String currentPassword, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.7:8000/api/users/change-password'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đổi mật khẩu thành công')),
        );
      } else {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Lỗi khi đổi mật khẩu')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi kết nối')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quyền riêng tư'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Thông tin tài khoản',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Tên'),
                  subtitle: Text(name),
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email'),
                  subtitle: Text(email),
                ),
                ListTile(
                  leading: const Icon(Icons.pets),
                  title: const Text('Tên thú cưng'),
                  subtitle: Text(petName.isEmpty ? 'Chưa cập nhật' : petName),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: const Text('Số điện thoại'),
                  subtitle: Text(phone.isEmpty ? 'Chưa cập nhật' : phone),
                ),
                const Divider(thickness: 8),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Bảo mật',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Chỉnh sửa tài khoản'),
                  subtitle: const Text('Cập nhật thông tin cá nhân'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showEditAccountDialog,
                ),
                ListTile(
                  leading: const Icon(Icons.lock_reset),
                  title: const Text('Đổi mật khẩu'),
                  subtitle: const Text('Thay đổi mật khẩu của bạn'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _showChangePasswordDialog,
                ),
                const Divider(thickness: 8),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Quyền riêng tư',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.visibility),
                  title: const Text('Tài khoản công khai'),
                  subtitle: const Text('Cho phép người khác xem hồ sơ của bạn'),
                  value: true,
                  onChanged: (value) {
                    // Xử lý thay đổi quyền riêng tư
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.message),
                  title: const Text('Cho phép nhắn tin'),
                  subtitle: const Text('Ai cũng có thể gửi tin nhắn cho bạn'),
                  value: true,
                  onChanged: (value) {
                    // Xử lý thay đổi quyền nhắn tin
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.comment),
                  title: const Text('Cho phép bình luận'),
                  subtitle: const Text('Người khác có thể bình luận bài viết của bạn'),
                  value: true,
                  onChanged: (value) {
                    // Xử lý thay đổi quyền bình luận
                  },
                ),
                const Divider(thickness: 8),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text(
                    'Xóa tài khoản',
                    style: TextStyle(color: Colors.red),
                  ),
                  subtitle: const Text('Xóa vĩnh viễn tài khoản của bạn'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Xác nhận xóa tài khoản'),
                        content: const Text(
                          'Bạn có chắc chắn muốn xóa tài khoản? Hành động này không thể hoàn tác.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Hủy'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Xử lý xóa tài khoản
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Chức năng đang phát triển'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Xóa tài khoản'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }
}