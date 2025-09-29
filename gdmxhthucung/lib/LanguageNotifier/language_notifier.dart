import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';

class LanguageNotifier extends ChangeNotifier {
  String _languageCode = 'vi';

  String get languageCode => _languageCode;

  Future<void> setLanguage(String code, {bool syncToServer = true, BuildContext? context}) async {
    _languageCode = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', code);

    // Gửi API lên server nếu cần
    if (syncToServer) {
      final token = prefs.getString('token') ?? '';
      if (token.isNotEmpty) {
        await http.post(
          Uri.parse('http://192.168.1.7:8000/api/settings/update'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          body: {'language': code},
        );
      }
    }

    // Đổi ngôn ngữ giao diện
    if (context != null) {
      await context.setLocale(Locale(code));
    }

    notifyListeners();
  }

  Future<void> loadLanguageFromPrefs(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('language') ?? 'vi';
    await setLanguage(saved, syncToServer: false, context: context);
  }
}