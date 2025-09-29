import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LikeService {
  static const String baseUrl = 'http://192.168.1.7:8000';

  static Future<bool?> toggleLike(String postId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/api/posts/$postId/like'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final liked = data['liked'];
      if (liked is bool) return liked;
      if (liked is String) return liked == 'true';
    }

    return null;
  }

  static Future<Map<String, dynamic>?> fetchLikeStatus(String postId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/api/posts/$postId/likes'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'liked': data['liked'] == true || data['liked'] == 'true',
        'count': data['count'] ?? 0,
      };
    }

    return null;
  }
}
