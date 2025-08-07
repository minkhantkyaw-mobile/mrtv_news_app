import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mrtv_new_app_sl/constants/translations.dart';
import 'package:mrtv_new_app_sl/models/bookMarkRecords.dart';
import 'package:mrtv_new_app_sl/stackwidgettest/stackwidget.dart';
import 'package:mrtv_new_app_sl/viewModels/download/download_controller.dart';
import 'package:mrtv_new_app_sl/viewModels/theme/theme_controller/theme_controller.dart';
import 'package:mrtv_new_app_sl/views/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = Get.put(ThemeController());
  final prefs = await SharedPreferences.getInstance();
  final langCode = prefs.getString('lang_code') ?? 'en';
  final countryCode = prefs.getString('country_code') ?? 'US';
  await Hive.initFlutter();
  Hive.registerAdapter(
    BookmarkrecordsAdapter(),
  ); // Register the adapter for Bookmarkrecords

  await Hive.openBox<Bookmarkrecords>('bookmarks');
  Get.put(DownloadController());

  runApp(MyApp(Locale(langCode, countryCode)));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;
  const MyApp(this.initialLocale, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: AppTranslations(),
      locale: initialLocale,
      fallbackLocale: Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode:
          Get.find<ThemeController>().isDark.value
              ? ThemeMode.dark
              : ThemeMode.light,
      home: HomeScreen(),
    );
  }
}

final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFFDFDFD),
  primaryColor: Colors.deepPurple,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
  ),
  iconTheme: const IconThemeData(color: Colors.black87),
);
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),
  primaryColor: Colors.deepPurple,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
  ),
  iconTheme: const IconThemeData(color: Colors.white70),
);
