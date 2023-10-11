import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  bool isMusicPlaying = true;
  IconData bgMusicIcon = Icons.volume_up_sharp;



  void updateBgMusicState(bool newPlayState, IconData newIcon) {
    isMusicPlaying = newPlayState;
    bgMusicIcon = newIcon;
    notifyListeners();
  }
}
