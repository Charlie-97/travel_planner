import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_planner/data/model/auth/user.dart';

class AppKeys {
  static const String profile = "profile";
  static const String cookieToken = "cookieToken";
}

class AppStorage {
  static final AppStorage instance = AppStorage._instance();
  late SharedPreferences _sharedPreferences;
  AppStorage._instance();

  Future initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance().then((value) async {
      return value;
    });
  }

  void clearCache() async {
    await _sharedPreferences.clear();
  }

  void clearToken() async {
    await _sharedPreferences.remove(AppKeys.cookieToken);
  }

  void clearUser() async {
    await _sharedPreferences.remove(AppKeys.profile);
  }

  saveUser(Map<String, dynamic> data) async {
    await _sharedPreferences.setString(
      AppKeys.profile,
      json.encode(data),
    );
  }

  saveUserToken(String token) async {
    await _sharedPreferences.setString(AppKeys.cookieToken, token);
  }

  getToken() {
    return _sharedPreferences.getString(AppKeys.cookieToken);
  }

  User? getUserData() {
    final q = _sharedPreferences.getString(AppKeys.profile);
    if (q == null) {
      return null;
    }
    User userData = User.fromJson(
      json.decode(_sharedPreferences.getString(AppKeys.profile) ?? ""),
    );
    return userData;
  }
}
