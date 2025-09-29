import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart'; // ✅ import màn hình đăng nhập

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final petNameController = TextEditingController(); // ✅ controller cho tên thú cưng
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';
  bool isLoading = false;

  Future<void> register() async {
    setState(() {
      isLoading = true;
      message = '';
    });

    final response = await http.post(
      Uri.parse('http://192.168.1.7:8000/api/register'),
      headers: {'Accept': 'application/json'},
      body: {
        'name': nameController.text,
        'pet_name': petNameController.text, // ✅ gửi tên thú cưng
        'email': emailController.text,
        'password': passwordController.text,
        'password_confirmation': passwordController.text,
      },
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pop(context, 'registered');
    } else {
      final error = json.decode(response.body);
      String errorMessage = '❌ Đăng ký thất bại';
      if (error['errors'] != null) {
        errorMessage += '\n' +
            error['errors'].entries
                .map((e) => '${e.key}: ${e.value.join(', ')}')
                .join('\n');
      } else if (error['error'] != null) {
        errorMessage += '\n${error['error']}';
      }
      setState(() => message = errorMessage);
    }
  }

  void goBackToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                'Tạo tài khoản PetSocial',
                style: TextStyle(
                  fontSize: 24,
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
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Tên người dùng',
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
                                onPressed: register,
                                icon: const Icon(Icons.person_add),
                                label: const Text('Đăng ký'),
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
                        onPressed: goBackToLogin,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Quay lại đăng nhập'),
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