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

class PaddleColorProvider extends ChangeNotifier {
  Color player1Color = Colors.red;
  Color puckColor = Colors.blue;
  Color player2Color = Colors.blue;

  setPlayer1Color(Color color) {
    player1Color = color;
    notifyListeners();
  }

  setPuckColor(Color color) {
    puckColor = color;
    notifyListeners();
  }

  setPlayer2Color(Color color) {
    player2Color = color;
    notifyListeners();
  }
}
