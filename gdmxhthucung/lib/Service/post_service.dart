import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PostService {
  static Future<String?> submitPost({
  required String petName,
  required String breed,
  required String description,
  required String petType,
  required File imageFile,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final uri = Uri.parse('http://192.168.1.7:8000/api/posts');

  final request = http.MultipartRequest('POST', uri)
    ..headers['Authorization'] = 'Bearer $token'
    ..headers['Accept'] = 'application/json'
    ..fields['pet_name'] = petName
    ..fields['breed'] = breed
    ..fields['description'] = description
    ..fields['pet_type'] = petType
    ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  final response = await request.send();
  final body = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    return null; // ✅ thành công
  } else {
    return 'Lỗi: ${response.statusCode}\n$body'; // ❌ hiển thị lỗi thật
  }
}


  static Future<List<dynamic>> fetchPostsByType(String petType) async {
    final uri = Uri.parse('http://192.168.1.7:8000/api/posts/type/$petType');
    final response = await http.get(uri, headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data'];
    }
    return [];
  }
  
// lấy tất cả bài viết
static Future<List<dynamic>> fetchAllPosts() async {
  final uri = Uri.parse('http://192.168.1.7:8000/api/posts');
  final response = await http.get(uri, headers: {'Accept': 'application/json'});
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return json['data'];
  }
  return [];
}


  static Future<List<dynamic>> fetchPostsByUserAndType(String userId, String petType) async {
    final uri = Uri.parse('http://192.168.1.7:8000/api/posts/user/$userId/$petType');
    final response = await http.get(uri, headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data'];
    }
    return [];
  }

  static Future<bool> deletePost(String postId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final uri = Uri.parse('http://192.168.1.7:8000/api/posts/$postId');

  final response = await http.delete(uri, headers: {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  });

  return response.statusCode == 200;
}

}
