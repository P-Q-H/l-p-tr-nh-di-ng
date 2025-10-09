// Widget hiển thị thông tin người dùng trong danh sách và bài viết
import 'package:flutter/material.dart';
import '../screens/OtherUserProfile.dart';

class UserItemWidget extends StatelessWidget {
  final String userId;
  final String userName;
  final String? petName;
  final String? avatarUrl;
  final VoidCallback? onTap;
  final bool showFollowButton;
  final bool isFollowing;
  final Function(bool)? onFollowChanged;

  const UserItemWidget({
    super.key,
    required this.userId,
    required this.userName,
    this.petName,
    this.avatarUrl,
    this.onTap,
    this.showFollowButton = false,
    this.isFollowing = false,
    this.onFollowChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
            ? NetworkImage(avatarUrl!)
            : null,
        child: avatarUrl == null || avatarUrl!.isEmpty
            ? const Icon(Icons.person, color: Colors.grey)
            : null,
      ),
      title: Text(
        userName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: petName != null && petName!.isNotEmpty
          ? Text('🐾 $petName')
          : null,
      trailing: showFollowButton
          ? TextButton(
              onPressed: () {
                if (onFollowChanged != null) {
                  onFollowChanged!(!isFollowing);
                }
              },
              child: Text(
                isFollowing ? 'Đang theo dõi' : 'Theo dõi',
                style: TextStyle(
                  color: isFollowing ? Colors.grey : Colors.blue,
                ),
              ),
            )
          : const Icon(Icons.chevron_right),
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OtherUserProfileScreen(
                  userId: userId,
                  userName: userName,
                ),
              ),
            );
          },
    );
  }
}

// Widget hiển thị trong bài viết
class PostUserInfo extends StatelessWidget {
  final String userId;
  final String userName;
  final String? avatarUrl;
  final String? timeAgo;

  const PostUserInfo({
    super.key,
    required this.userId,
    required this.userName,
    this.avatarUrl,
    this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtherUserProfileScreen(
              userId: userId,
              userName: userName,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                  ? NetworkImage(avatarUrl!)
                  : null,
              child: avatarUrl == null || avatarUrl!.isEmpty
                  ? const Icon(Icons.person, size: 20, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  if (timeAgo != null)
                    Text(
                      timeAgo!,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}