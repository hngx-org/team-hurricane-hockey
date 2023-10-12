import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  bool isMusicPlaying = true;
  IconData bgMusicIcon = Icons.volume_up_sharp;

  bool isSfxOn = true;
  IconData sfxIcon = Icons.music_note_sharp;
  double sfxVolume = 1.0;

  void updateBgMusicState(bool newPlayState, IconData newIcon) {
    isMusicPlaying = newPlayState;
    bgMusicIcon = newIcon;
    notifyListeners();
  }

  void updateSfxState(bool newSfxState, IconData newIcon, double volume) {
    isSfxOn = newSfxState;
    sfxIcon = newIcon;
    sfxVolume = volume;
    notifyListeners();
  }
}
