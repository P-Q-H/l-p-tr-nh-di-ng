import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ThemeNotifier/theme_notifier.dart';
import '../LanguageNotifier/language_notifier.dart'; // ✅ import thêm

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedTheme = 'system';
  String selectedLanguage = 'vi';

  @override
  void initState() {
    super.initState();
    final languageNotifier = Provider.of<LanguageNotifier>(context, listen: false);
    selectedLanguage = languageNotifier.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    final languageNotifier = Provider.of<LanguageNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt'), backgroundColor: Colors.orange),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('🎨 Giao diện', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          RadioListTile(
            title: const Text('Sáng'),
            value: 'light',
            groupValue: selectedTheme,
            onChanged: (value) {
              setState(() => selectedTheme = value!);
              themeNotifier.setTheme(value!);
            },
          ),
          RadioListTile(
            title: const Text('Tối'),
            value: 'dark',
            groupValue: selectedTheme,
            onChanged: (value) {
              setState(() => selectedTheme = value!);
              themeNotifier.setTheme(value!);
            },
          ),
          RadioListTile(
            title: const Text('Theo hệ thống'),
            value: 'system',
            groupValue: selectedTheme,
            onChanged: (value) {
              setState(() => selectedTheme = value!);
              themeNotifier.setTheme(value!);
            },
          ),

          const Divider(height: 32),
          const Text('🌐 Ngôn ngữ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
       
          DropdownButton<String>(
            value: selectedLanguage,
            items: const [
              DropdownMenuItem(value: 'vi', child: Text('Tiếng Việt')),
              DropdownMenuItem(value: 'en', child: Text('English')),
            ],
            onChanged: (value) {
              setState(() => selectedLanguage = value!);
              // Truyền context vào để đổi ngôn ngữ toàn app
              languageNotifier.setLanguage(value!, context: context);
            },
          ),
        ],
      ),
    );
  }
}
