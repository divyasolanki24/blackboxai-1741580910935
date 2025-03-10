import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences.dart';

class ThemeService {
  final _box = Get.find<SharedPreferences>();
  final _key = 'isDarkMode';

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFromBox() => _box.getBool(_key) ?? false;
  
  _saveThemeToBox(bool isDarkMode) => _box.setBool(_key, isDarkMode);

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}
