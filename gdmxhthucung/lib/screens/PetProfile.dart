import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';


class PetProfile extends StatelessWidget {
  final String petId;
  const PetProfile({super.key, required this.petId});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu — ép kiểu rõ ràng bằng .toString()
    final pet = {
      'name': 'Mimi',
      'breed': 'Mèo Persian',
      'age': '2 tuổi',
      'weight': '3.5 kg',
      'owner': 'Nguyễn Thị Lan',
      'description':
          'Mình là Mimi, một cô bé mèo Persian xinh đẹp và rất thích nựng. Sở thích của mình là chạy nhảy trong vườn và chơi với bóng len.',
      'location': 'Thành phố Hồ Chí Minh',
      'joined': 'Tháng 3, 2024',
      'posts': 127,
      'followers': 1248,
      'following': 89,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ sơ của ${pet['name'].toString()}'),
        backgroundColor: Colors.orange[100],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset('assets/cover.jpg', height: 180, width: double.infinity, fit: BoxFit.cover),
                Positioned(
                  bottom: 0,
                  left: 16,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/avatar.jpg'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(pet['name'].toString(), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(pet['breed'].toString(), style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 20,
              children: [
                _StatItem(label: 'Bài viết', value: pet['posts'].toString()),
                _StatItem(label: 'Người theo dõi', value: pet['followers'].toString()),
                _StatItem(label: 'Đang theo dõi', value: pet['following'].toString()),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.message), label: const Text('Nhắn tin')),
                ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.person_add), label: const Text('Theo dõi')),
                ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.share), label: const Text('Chia sẻ')),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Giới thiệu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(pet['description'].toString()),
                  const SizedBox(height: 12),
                  Text('👤 Chủ nuôi: ${pet['owner'].toString()}'),
                  Text('📍 Vị trí: ${pet['location'].toString()}'),
                  Text('🎂 Tuổi: ${pet['age'].toString()}'),
                  Text('⚖️ Cân nặng: ${pet['weight'].toString()}'),
                  Text('📅 Tham gia: ${pet['joined'].toString()}'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Ảnh của Mimi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _PhotoThumb('assets/mimi1.jpg'),
                  _PhotoThumb('assets/mimi2.jpg'),
                  _PhotoThumb('assets/mimi3.jpg'),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _PhotoThumb extends StatelessWidget {
  final String path;
  const _PhotoThumb(this.path);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(path, width: 100, height: 100, fit: BoxFit.cover),
      ),
    );
  }
}
