import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences.dart';
import 'package:shop_management_system/models/user.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;
  
  // Keys for stored data
  static const String keyAuthToken = 'auth_token';
  static const String keyUser = 'user';
  static const String keyThemeMode = 'theme_mode';
  static const String keySettings = 'settings';
  static const String keyLastLogin = 'last_login';

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Auth Token
  Future<void> setAuthToken(String token) async {
    await _prefs.setString(keyAuthToken, token);
  }

  String? getAuthToken() {
    return _prefs.getString(keyAuthToken);
  }

  Future<void> removeAuthToken() async {
    await _prefs.remove(keyAuthToken);
  }

  // User Data
  Future<void> setUser(User user) async {
    await _prefs.setString(keyUser, json.encode(user.toJson()));
  }

  User? getUser() {
    final userStr = _prefs.getString(keyUser);
    if (userStr != null) {
      try {
        return User.fromJson(json.decode(userStr));
      } catch (e) {
        print('Error parsing user data: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> removeUser() async {
    await _prefs.remove(keyUser);
  }

  // Theme Mode
  Future<void> setThemeMode(bool isDarkMode) async {
    await _prefs.setBool(keyThemeMode, isDarkMode);
  }

  bool isDarkMode() {
    return _prefs.getBool(keyThemeMode) ?? false;
  }

  // App Settings
  Future<void> setSettings(Map<String, dynamic> settings) async {
    await _prefs.setString(keySettings, json.encode(settings));
  }

  Map<String, dynamic> getSettings() {
    final settingsStr = _prefs.getString(keySettings);
    if (settingsStr != null) {
      try {
        return json.decode(settingsStr);
      } catch (e) {
        print('Error parsing settings: $e');
        return {};
      }
    }
    return {};
  }

  // Last Login
  Future<void> setLastLogin() async {
    await _prefs.setString(keyLastLogin, DateTime.now().toIso8601String());
  }

  DateTime? getLastLogin() {
    final lastLoginStr = _prefs.getString(keyLastLogin);
    if (lastLoginStr != null) {
      try {
        return DateTime.parse(lastLoginStr);
      } catch (e) {
        print('Error parsing last login date: $e');
        return null;
      }
    }
    return null;
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  // Check if user is logged in
  bool isLoggedIn() {
    final token = getAuthToken();
    final user = getUser();
    return token != null && user != null;
  }

  // Save a generic item
  Future<void> setItem<T>(String key, T value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      await _prefs.setString(key, json.encode(value));
    }
  }

  // Get a generic item
  T? getItem<T>(String key) {
    final value = _prefs.get(key);
    if (value != null) {
      if (T == String || T == int || T == double || T == bool || T == List<String>) {
        return value as T;
      }
      try {
        return json.decode(_prefs.getString(key)!) as T;
      } catch (e) {
        print('Error parsing item $key: $e');
        return null;
      }
    }
    return null;
  }

  // Remove a generic item
  Future<void> removeItem(String key) async {
    await _prefs.remove(key);
  }

  // Check if key exists
  bool hasKey(String key) {
    return _prefs.containsKey(key);
  }
}
