import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:team_hurricane_hockey/providers/my_provider.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';

final bgMusic = AudioPlayer();
final sfx = AudioPlayer();

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

  Future<void> initSfx() async {
    await sfx.setSource(AssetSource('sounds/menu_select.mp3'));
    await sfx.setVolume(1.0);
    p.updateSfxState(true, Icons.music_note_sharp, 1.0);
  }

  double? volume;

  Future<void> playSfx() async {
    await sfx.play(AssetSource('sounds/menu_select.mp3'), volume: volume);
  }

  Future<void> toggleSfx() async {
    if (!p.isSfxOn) {
      await sfx.setVolume(1.0);
      volume = 1.0;
      p.updateSfxState(true, Icons.music_note_sharp, volume!);
    } else {
      await sfx.setVolume(0.0);
      volume = 0.0;
      p.updateSfxState(false, Icons.music_off_sharp, volume!);
    }
  }
}
