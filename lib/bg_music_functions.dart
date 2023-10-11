import 'package:audioplayers/audioplayers.dart';
import 'package:team_hurricane_hockey/providers/my_provider.dart';

class SoundControl {
  final bgMusic = AudioPlayer();

  MyProvider p = MyProvider();
  bool isMusicPlaying = true;

  Future<void> startBgMusic() async {
    await bgMusic.play(AssetSource('sounds/bg_music.mp3'));
    bgMusic.setReleaseMode(ReleaseMode.loop);
    isMusicPlaying = true;
    p.updateBgMusicState(isMusicPlaying);
  }

  Future<void> resumeBgMusic() async {
    await bgMusic.resume();
    isMusicPlaying = true;
    p.updateBgMusicState(isMusicPlaying);
  }

  Future<void> stopBgMusic() async {
    await bgMusic.stop();
    isMusicPlaying = false;
    p.updateBgMusicState(isMusicPlaying);
  }

  Future<void> toggleBgMusic() async {
    if (isMusicPlaying) {
      stopBgMusic();
    } else {
      resumeBgMusic();
    }
  }
}
