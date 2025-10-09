// đùng để hiển thị danh sách người theo dõi hoặc đang theo dõi một người dùng 
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'OtherUserProfile.dart';
import '../ThemeNotifier/ProfileRefreshNotifier.dart';
 
class FollowListScreen extends StatefulWidget {
  final String userId;
  final bool isFollowers; // true = followers, false = following
  final String title;

  const FollowListScreen({
    super.key,
    required this.userId,
    required this.isFollowers,
    required this.title,
  });

  @override
  State<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen> {
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final endpoint = widget.isFollowers ? 'followers' : 'following';
      final response = await http.get(
        Uri.parse('http://192.168.1.7:8000/api/users/${widget.userId}/$endpoint'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          users = widget.isFollowers ? data['followers'] : data['following'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.isFollowers 
                          ? 'Chưa có người theo dõi' 
                          : 'Chưa theo dõi ai',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchUsers,
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          backgroundImage: user['avatar_url'] != null
                              ? NetworkImage(user['avatar_url'])
                              : null,
                          child: user['avatar_url'] == null
                              ? const Icon(Icons.person, color: Colors.grey)
                              : null,
                        ),
                        title: Text(
                          user['name'] ?? 'Unknown',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: user['pet_name'] != null && user['pet_name'].isNotEmpty
                            ? Text('🐾 ${user['pet_name']}')
                            : null,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          // Navigate to user profile
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OtherUserProfileScreen(
                                userId: user['id'].toString(),
                                userName: user['name'],
                              ),
                            ),
                          );
                          
                          // Nếu có thay đổi (follow/unfollow), refresh lại danh sách
                          if (result == true) {
                            fetchUsers();
                          }
                        },
                      );
                    },
                  ),
                ),
    );
  }
}