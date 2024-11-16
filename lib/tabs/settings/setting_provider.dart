import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider with ChangeNotifier {
  String langCode = 'en';
  String currentTheme = 'light' ;

   ThemeMode? get themeMode  {
    if (currentTheme == 'light') {
      return ThemeMode.light;
    } else if (currentTheme == 'dark') {
      return ThemeMode.dark;
    } return null;
  }
  changeTheme(String theme){
    currentTheme = theme;
    notifyListeners();
  }

  // bool _isDark = false;
  // bool get isDark => _isDark;

  // SettingProvider() {
  //   loadThemePreference();
  // }
  //
  // void loadThemePreference() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   _isDark = prefs.getBool('isDark') ?? false;
  //   notifyListeners();
  // }
  //
  // void changeTheme() async {
  //   _isDark = !_isDark;
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isDark', _isDark);
  //   notifyListeners();
  // }

  changeLang(String selectedLang) {
    if (selectedLang == langCode) return;
    langCode = selectedLang;

    notifyListeners();
  }
}
