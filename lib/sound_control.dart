import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:team_hurricane_hockey/providers/my_provider.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';

final bgMusic = AudioPlayer();
final sfx = AudioPlayer();

class SoundControl {
  final p = Provider.of<MyProvider>(BaseNavigator.currentContext);

  Future<void> startBgMusic() async {
    // if (p.isMusicPlaying) {
    await bgMusic.play(AssetSource('sounds/bg_music.mp3'));
    bgMusic.setReleaseMode(ReleaseMode.loop);

    p.updateBgMusicState(true);
    // }
  }

  Future<void> resumeBgMusic() async {
    await bgMusic.resume();

    p.updateBgMusicState(true);
  }

  Future<void> stopBgMusic() async {
    await bgMusic.stop();

    p.updateBgMusicState(false);
  }

  Future<void> toggleBgMusic() async {
    if (p.isMusicPlaying) {
      stopBgMusic();
    } else {
      startBgMusic();
    }
  }

  Future<void> initSfx() async {
    await sfx.setSource(AssetSource('sounds/menu_select.mp3'));
    await sfx.setVolume(1.0);
    p.updateSfxState(true);
  }

  Future<void> playSfx() async {
    await sfx.play(AssetSource('sounds/menu_select.mp3'), volume: p.sfxVolume);
  }

  Future<void> toggleSfx() async {
    if (!p.isSfxOn) {
      await sfx.setVolume(1.0);
      p.updateSfxState(true);
    } else {
      await sfx.setVolume(0.0);

      p.updateSfxState(false);
    }
  }
}
