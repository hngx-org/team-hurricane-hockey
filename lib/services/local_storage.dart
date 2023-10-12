import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_hurricane_hockey/models/user.dart';

class AppKeys {
  static const String profile = "profile";
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

  void clearUser() async {
    await _sharedPreferences.remove(AppKeys.profile);
  }

  saveUser(Map<String, dynamic> data) async {
    await _sharedPreferences.setString(
      AppKeys.profile,
      json.encode(data),
    );
  }

  UserData? getUserData() {
    final q = _sharedPreferences.getString(AppKeys.profile);
    if (q == null) {
      return null;
    }
    UserData userData = UserData.fromJson(
      json.decode(_sharedPreferences.getString(AppKeys.profile) ?? ""),
    );
    return userData;
  }
}
