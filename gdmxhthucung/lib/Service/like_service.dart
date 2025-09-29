import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LikeService {
  static Future<bool?> toggleLike(String postId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('http://192.168.1.7:8000/api/posts/$postId/like'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

print('Toggle like statusCode: ${response.statusCode}');
  print('Toggle like body: ${response.body}');
  
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Toggle like response: $data');
      final liked = data['liked'];
      if (liked is bool) return liked;
      if (liked is String) return liked == 'true';
    }

    return null;
  }

  static Future<bool?> fetchLikeStatus(String postId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://192.168.1.7:8000/api/posts/$postId/likes'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('Fetch like status: $data');
      final liked = data['liked'];
      if (liked is bool) return liked;
      if (liked is String) return liked == 'true';
    }

    return null;
  }
}
