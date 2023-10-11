import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_hurricane_hockey/providers/my_provider.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';

final bgMusic = AudioPlayer();

class SoundControl {
  final p = Provider.of<MyProvider>(BaseNavigator.currentContext);

  Future<void> startBgMusic() async {
    await bgMusic.play(AssetSource('sounds/bg_music.mp3'));
    bgMusic.setReleaseMode(ReleaseMode.loop);

    p.updateBgMusicState(true, Icons.volume_up_sharp);
  }

  Future<void> resumeBgMusic() async {
    await bgMusic.resume();

    p.updateBgMusicState(true, Icons.volume_up_sharp);
  }

  Future<void> stopBgMusic() async {
    await bgMusic.stop();

    p.updateBgMusicState(false, Icons.volume_off_sharp);
  }

  Future<void> toggleBgMusic() async {
    if (p.isMusicPlaying) {
      stopBgMusic();
    } else {
      resumeBgMusic();
    }
  }
}
