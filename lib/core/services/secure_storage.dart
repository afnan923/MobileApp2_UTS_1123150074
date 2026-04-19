import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _keyToken = 'auth_token';

  // Mobile pakai secure storage
  static const _secureStorage = FlutterSecureStorage();

  // 🔥 SAVE
  static Future<void> saveToken(String token) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyToken, token);
    } else {
      await _secureStorage.write(key: _keyToken, value: token);
    }
  }

  // 🔥 GET
  static Future<String?> getToken() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyToken);
    } else {
      return await _secureStorage.read(key: _keyToken);
    }
  }

  // 🔥 CLEAR
  static Future<void> clearAll() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } else {
      await _secureStorage.deleteAll();
    }
  }
}