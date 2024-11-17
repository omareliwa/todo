import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider with ChangeNotifier {
  String langCode = 'en';

  bool _isDark = false;

  bool get isDark => _isDark;

  SettingProvider() {
    loadThemePreference();
  }

  void loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDark') ?? false;
    notifyListeners();
  }

  void changeTheme() async {
    _isDark = !_isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', _isDark);
    notifyListeners();
  }

  changeLang(String selectedLang) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('selectedLang', selectedLang);
    if (selectedLang == langCode) return;
    langCode = selectedLang;

    notifyListeners();
  }

  currentLang() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    langCode = preferences.getString('selectedLang') ?? 'en';
    notifyListeners();
  }
}
