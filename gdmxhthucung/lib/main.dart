import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'LanguageNotifier/language_notifier.dart';
import 'ThemeNotifier/theme_notifier.dart';
import 'screens/PetSocialHome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final themeNotifier = ThemeNotifier();
  await themeNotifier.loadThemeFromPrefs();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('vi'), Locale('en')],
      path: 'assets/langs',
      fallbackLocale: Locale('vi'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => themeNotifier),
          ChangeNotifierProvider(create: (_) => LanguageNotifier()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final languageNotifier = Provider.of<LanguageNotifier>(context);

    // Load lại ngôn ngữ khi build app
    languageNotifier.loadLanguageFromPrefs(context);

    return MaterialApp(
      title: 'Pet Social',
      debugShowCheckedModeBanner: false,
      themeMode: themeNotifier.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: PetSocialHome(),
    );
  }
}