import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Service/post_service.dart';

class CreatePostScreen extends StatefulWidget {
  final String petType;
  const CreatePostScreen({super.key, required this.petType});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final nameController = TextEditingController();
  final breedController = TextEditingController();
  final descriptionController = TextEditingController();
  File? imageFile;
  bool isLoading = false;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => imageFile = File(picked.path));
  }

  Future<void> submitPost() async {
    // ✅ Kiểm tra đầu vào
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
      petType: widget.petType,
      imageFile: imageFile!,
    );

    setState(() => isLoading = false);

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Bài viết đã được đăng')),
      );
      Navigator.pop(context, 'posted');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng bài mới')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Tên thú cưng'),
            ),
            TextField(
              controller: breedController,
              decoration: const InputDecoration(labelText: 'Giống loài'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Mô tả'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            imageFile != null
                ? Image.file(imageFile!, height: 150)
                : OutlinedButton.icon(
                    onPressed: pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Chọn ảnh'),
                  ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: isLoading ? null : submitPost,
              icon: const Icon(Icons.send),
              label: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Đăng bài viết'),
            ),
          ],
        ),
      ),
    );
  }
}
