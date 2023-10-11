import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  bool _isMusicPlaying = true;

  bool get isMusicPlaying => _isMusicPlaying;

  void updateBgMusicState(bool newPlayState) {
    _isMusicPlaying = newPlayState;
    notifyListeners();
  }
}
