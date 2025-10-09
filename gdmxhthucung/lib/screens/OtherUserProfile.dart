// dùng để hiển thị hồ sơ của người dùng khác, bao gồm thông tin cá nhân, số liệu thống kê và bài viết của họ
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../ThemeNotifier/ProfileRefreshNotifier.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final String userId;
  final String? userName;

  const OtherUserProfileScreen({
    super.key, 
    required this.userId,
    this.userName,
  });

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  String name = '';
  String email = '';
  String petName = '';
  String createdAt = '';
  String? avatarUrl;
  bool isLoading = true;
  bool isFollowing = false;
  int followersCount = 0;
  int followingCount = 0;
  int postsCount = 0;
  List<dynamic> userPosts = [];

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchFollowStatus();
    fetchFollowStats();
    fetchUserPosts();
  }

  Future<void> fetchUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

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
          createdAt = data['created_at']?.substring(0, 10) ?? '';
          avatarUrl = data['avatar_url'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchFollowStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.7:8000/api/users/${widget.userId}/follow-status'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isFollowing = data['following'] ?? false;
        });
      }
    } catch (e) {
      // Ignore error
    }
  }

  Future<void> fetchFollowStats() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.7:8000/api/users/${widget.userId}/follow-stats'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          followersCount = data['followers_count'] ?? 0;
          followingCount = data['following_count'] ?? 0;
        });
      }
    } catch (e) {
      // Ignore error
    }
  }

  Future<void> fetchUserPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.7:8000/api/posts'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final allPosts = data['data'] as List;
        
        final filteredPosts = allPosts.where((post) {
          return post['user_id'].toString() == widget.userId;
        }).toList();

        setState(() {
          userPosts = filteredPosts;
          postsCount = filteredPosts.length;
        });
      }
    } catch (e) {
      // Ignore error
    }
  }

  Future<void> toggleFollow() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.7:8000/api/users/${widget.userId}/follow'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isFollowing = data['following'] ?? false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Thành công')),
        );

        // Refresh stats
        fetchFollowStats();
        
        // Trả về true để ProfileScreen biết cần refresh
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName ?? 'Hồ sơ'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await fetchUserInfo();
                await fetchFollowStatus();
                await fetchFollowStats();
                await fetchUserPosts();
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                                ? NetworkImage(avatarUrl!)
                                : null,
                            child: (avatarUrl == null || avatarUrl!.isEmpty)
                                ? const Icon(Icons.person, size: 50, color: Colors.grey)
                                : null,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            name,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '@${widget.userId}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          if (petName.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              '🐾 $petName',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                          const SizedBox(height: 16),
                          // Follow button
                          ElevatedButton.icon(
                            onPressed: toggleFollow,
                            icon: Icon(isFollowing ? Icons.person_remove : Icons.person_add),
                            label: Text(isFollowing ? 'Bỏ theo dõi' : 'Theo dõi'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isFollowing ? Colors.grey : Colors.blue,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 42),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Stats
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStat(postsCount.toString(), 'Bài viết'),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to followers list
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FollowListScreen(
                                        userId: widget.userId,
                                        isFollowers: true,
                                        title: 'Người theo dõi',
                                      ),
                                    ),
                                  );
                                },
                                child: _buildStat(followersCount.toString(), 'Theo dõi'),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to following list
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FollowListScreen(
                                        userId: widget.userId,
                                        isFollowers: false,
                                        title: 'Đang theo dõi',
                                      ),
                                    ),
                                  );
                                },
                                child: _buildStat(followingCount.toString(), 'Đang theo dõi'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                  // Posts grid
                  SliverPadding(
                    padding: const EdgeInsets.all(2),
                    sliver: userPosts.isEmpty
                        ? const SliverFillRemaining(
                            child: Center(
                              child: Text('Chưa có bài viết nào'),
                            ),
                          )
                        : SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final post = userPosts[index];
                                final imageUrl = post['image'] != null
                                    ? 'http://192.168.1.7:8000/storage/${post['image']}'
                                    : null;

                                return GestureDetector(
                                  onTap: () {
                                    // Show post detail
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      image: imageUrl != null
                                          ? DecorationImage(
                                              image: NetworkImage(imageUrl),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: imageUrl == null
                                        ? const Icon(Icons.image, color: Colors.grey)
                                        : null,
                                  ),
                                );
                              },
                              childCount: userPosts.length,
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

// Import this at the top of the file
class FollowListScreen extends StatelessWidget {
  final String userId;
  final bool isFollowers;
  final String title;

  const FollowListScreen({
    super.key,
    required this.userId,
    required this.isFollowers,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Container(), // Will be implemented next
    );
  }
}