// dùng để thông báo khi cần làm mới dữ liệu profile người dùng
 import 'package:flutter/material.dart';

class ProfileRefreshNotifier extends ChangeNotifier {
  bool _needsRefresh = false;

  bool get needsRefresh => _needsRefresh;

  void requestRefresh() {
    _needsRefresh = true;
    notifyListeners();
  }

  void resetRefresh() {
    _needsRefresh = false;
  }
}

// Singleton để dễ sử dụng
class ProfileRefreshService {
  static final ProfileRefreshService _instance = ProfileRefreshService._internal();
  factory ProfileRefreshService() => _instance;
  ProfileRefreshService._internal();

  final ProfileRefreshNotifier _notifier = ProfileRefreshNotifier();
  ProfileRefreshNotifier get notifier => _notifier;

  // Request refresh từ bất kỳ đâu
  void refreshProfile() {
    _notifier.requestRefresh();
  }
}