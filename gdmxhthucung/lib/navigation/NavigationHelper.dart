// dùng để điều hướng giữa các màn hình liên quan đến profile người dùng 
import 'package:flutter/material.dart';
import '../screens/OtherUserProfile.dart';
import '../screens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationHelper {
  // Navigate to other user profile and return if need refresh
  static Future<bool> navigateToUserProfile(
    BuildContext context,
    String userId,
    String? userName,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtherUserProfileScreen(
          userId: userId,
          userName: userName,
        ),
      ),
    );
    return result == true;
  }

  // Navigate to current user profile
  static Future<void> navigateToMyProfile(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    
    if (userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileScreen(userId: userId),
        ),
      );
    }
  }

  // Kiểm tra xem có phải profile của mình không
  static Future<bool> isMyProfile(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final myUserId = prefs.getString('user_id');
    return myUserId == userId;
  }
}

// Extension để dễ sử dụng
extension UserProfileNavigation on BuildContext {
  Future<bool> navigateToUserProfile(String userId, String? userName) {
    return NavigationHelper.navigateToUserProfile(this, userId, userName);
  }
}