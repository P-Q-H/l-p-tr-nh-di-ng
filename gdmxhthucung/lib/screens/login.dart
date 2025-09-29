import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'register.dart';
import 'PetSocialHome.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';
  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
      message = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.7:8000/api/login'),
        headers: {'Accept': 'application/json'},
        body: {
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        final userId = data['user']['id'].toString(); // 👈 nếu API trả về user info

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user_id', userId); // 👈 lưu userId nếu cần

        // Navigator.pop(context, 'logged_in');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PetSocialHome()),
        );

      } else {
        final error = json.decode(response.body);
        setState(() {
          message = '❌ ${error['error'] ?? 'Sai tài khoản hoặc mật khẩu'}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        message = '❌ Lỗi kết nối đến server';
      });
    }
//     Navigator.pushReplacement(
//   context,
//   MaterialPageRoute(builder: (_) => const PetSocialHome()),
// );

  }

  void goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.pets, size: 64, color: Colors.orange),
              const SizedBox(height: 12),
              const Text(
                'PetSocial',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Mật khẩu',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: login,
                                icon: const Icon(Icons.login),
                                label: const Text('Đăng nhập'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 12),
                      if (message.isNotEmpty)
                        Text(
                          message,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: goToRegister,
                        icon: const Icon(Icons.person_add),
                        label: const Text('Chưa có tài khoản? Đăng ký ngay'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}