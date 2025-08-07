import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  void changeLanguage(String langCode, String countryCode) async {
    final locale = Locale(langCode, countryCode);
    Get.updateLocale(locale);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lang_code', langCode);
    prefs.setString('country_code', countryCode);
  }
}
