import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ThemeNotifier/theme_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String currentLanguage = 'vi';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentLanguage = prefs.getString('language') ?? 'vi';
    });
  }

  Future<void> _saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    setState(() {
      currentLanguage = language;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(language == 'vi' 
          ? 'Đã đổi sang tiếng Việt. Vui lòng khởi động lại ứng dụng để áp dụng.' 
          : 'Changed to English. Please restart the app to apply.'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, ThemeNotifier themeNotifier) {
    String currentThemeString = 'system';
    if (themeNotifier.themeMode == ThemeMode.light) {
      currentThemeString = 'light';
    } else if (themeNotifier.themeMode == ThemeMode.dark) {
      currentThemeString = 'dark';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(currentLanguage == 'vi' ? 'Chọn giao diện' : 'Choose Theme'),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: Text(currentLanguage == 'vi' ? 'Sáng' : 'Light'),
                  value: 'light',
                  groupValue: currentThemeString,
                  onChanged: (value) async {
                    if (value != null) {
                      await themeNotifier.setTheme(value);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(currentLanguage == 'vi' 
                          ? 'Đã đổi sang chế độ sáng' 
                          : 'Changed to light mode')),
                      );
                    }
                  },
                ),
                RadioListTile<String>(
                  title: Text(currentLanguage == 'vi' ? 'Tối' : 'Dark'),
                  value: 'dark',
                  groupValue: currentThemeString,
                  onChanged: (value) async {
                    if (value != null) {
                      await themeNotifier.setTheme(value);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(currentLanguage == 'vi' 
                          ? 'Đã đổi sang chế độ tối' 
                          : 'Changed to dark mode')),
                      );
                    }
                  },
                ),
                RadioListTile<String>(
                  title: Text(currentLanguage == 'vi' ? 'Hệ thống' : 'System'),
                  value: 'system',
                  groupValue: currentThemeString,
                  onChanged: (value) async {
                    if (value != null) {
                      await themeNotifier.setTheme(value);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(currentLanguage == 'vi' 
                          ? 'Đã đổi sang chế độ hệ thống' 
                          : 'Changed to system mode')),
                      );
                    }
                  },
                ),
              ],
            );
          },
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

  String _getThemeName(ThemeMode themeMode) {
    if (currentLanguage == 'vi') {
      switch (themeMode) {
        case ThemeMode.light:
          return 'Sáng';
        case ThemeMode.dark:
          return 'Tối';
        case ThemeMode.system:
          return 'Hệ thống';
      }
    } else {
      switch (themeMode) {
        case ThemeMode.light:
          return 'Light';
        case ThemeMode.dark:
          return 'Dark';
        case ThemeMode.system:
          return 'System';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

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
            subtitle: Text(_getThemeName(themeNotifier.themeMode)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showThemeDialog(context, themeNotifier),
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