import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String currentTheme = 'light';
  String currentLanguage = 'vi';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentTheme = prefs.getString('theme') ?? 'light';
      currentLanguage = prefs.getString('language') ?? 'vi';
    });
  }

  Future<void> _saveTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
    setState(() {
      currentTheme = theme;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(currentLanguage == 'vi' 
        ? 'Đã đổi sang chế độ ${theme == 'light' ? 'sáng' : 'tối'}' 
        : 'Changed to ${theme == 'light' ? 'light' : 'dark'} mode')),
    );
  }

  Future<void> _saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    setState(() {
      currentLanguage = language;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(language == 'vi' 
        ? 'Đã đổi sang tiếng Việt' 
        : 'Changed to English')),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(currentLanguage == 'vi' ? 'Chọn giao diện' : 'Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(currentLanguage == 'vi' ? 'Sáng' : 'Light'),
              value: 'light',
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  _saveTheme(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: Text(currentLanguage == 'vi' ? 'Tối' : 'Dark'),
              value: 'dark',
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  _saveTheme(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: Text(currentLanguage == 'vi' ? 'Hệ thống' : 'System'),
              value: 'system',
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  _saveTheme(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(currentLanguage == 'vi' ? 'Chọn ngôn ngữ' : 'Choose Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Tiếng Việt'),
              value: 'vi',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  _saveLanguage(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  _saveLanguage(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeName() {
    if (currentLanguage == 'vi') {
      switch (currentTheme) {
        case 'light':
          return 'Sáng';
        case 'dark':
          return 'Tối';
        case 'system':
          return 'Hệ thống';
        default:
          return 'Sáng';
      }
    } else {
      switch (currentTheme) {
        case 'light':
          return 'Light';
        case 'dark':
          return 'Dark';
        case 'system':
          return 'System';
        default:
          return 'Light';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentLanguage == 'vi' ? 'Cài đặt' : 'Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(currentLanguage == 'vi' ? 'Giao diện' : 'Theme'),
            subtitle: Text(_getThemeName()),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showThemeDialog,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(currentLanguage == 'vi' ? 'Ngôn ngữ' : 'Language'),
            subtitle: Text(currentLanguage == 'vi' ? 'Tiếng Việt' : 'English'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showLanguageDialog,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(currentLanguage == 'vi' ? 'Thông báo' : 'Notifications'),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // Xử lý bật/tắt thông báo
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(currentLanguage == 'vi' ? 'Về ứng dụng' : 'About App'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: currentLanguage == 'vi' ? 'Quản lý thú cưng' : 'Pet Management',
                applicationVersion: '1.0.0',
                children: [
                  Text(currentLanguage == 'vi' 
                    ? 'Ứng dụng quản lý và chia sẻ khoảnh khắc về thú cưng của bạn.'
                    : 'An app to manage and share moments of your pets.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}