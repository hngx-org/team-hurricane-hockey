import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  AppSharedPreferences._instance();
  static final instance = AppSharedPreferences._instance();
  late SharedPreferences _sharedPreferences;

  Future initialize() async {
    _sharedPreferences =
        await SharedPreferences.getInstance().then((value) async {
      return value;
    });
  }

  setBGMusicState(bool state) async {
    await _sharedPreferences.setBool("bg_music", state);
  }

  bool getbgMusicState() {
    final value = _sharedPreferences.getBool("bg_music");
    return value ?? true;
  }

   setSFX(bool state) async {
    await _sharedPreferences.setBool("sfx", state);
  }

  bool getSFX() {
    final value = _sharedPreferences.getBool("sfx");
    return value ?? true;
  }

  setColor(String id, Color color) async {
    await _sharedPreferences.setInt(id, color.value);
  }

  Color? getColor(String id) {
    final value = _sharedPreferences.getInt(id);

    if (value != null) {
      return Color(value);
    } else {
      return null;
    }
  }
}
