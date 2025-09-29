import 'package:flutter/material.dart';

class PostDetailScreen extends StatelessWidget {
  final Map<String, dynamic> post;
  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết bài viết')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post['image'] != null)
              Image.network('http://192.168.1.7:8000/storage/${post['image']}', width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post['pet_name'] ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(post['breed'] ?? '', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 12),
                  Text(post['description'] ?? '', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  Text('🐾 Loại thú: ${post['pet_type'] ?? ''}'),
                  Text('👤 Người đăng: ${post['username'] ?? 'Ẩn danh'}'),
                  Text('🕒 Ngày đăng: ${post['created_at'] ?? ''}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
