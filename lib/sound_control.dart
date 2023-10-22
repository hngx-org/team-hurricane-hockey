import 'package:flame_audio/flame_audio.dart';
import 'package:provider/provider.dart';
import 'package:team_hurricane_hockey/providers/my_provider.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';

const bgMusic = 'bg_music.mp3';
const sfx = 'menu_select.mp3';
const paddleSfx = 'paddle.mp3';
const wallSfx = 'wall.mp3';
const goalSfx = 'goal.mp3';

const finalWhistle = 'final_whistle.mp3';

class SoundControl {
  final p = Provider.of<MyProvider>(BaseNavigator.currentContext);
  void initialPlayBgMusic() {
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play(bgMusic);
    if (!p.isMusicPlaying) {
      FlameAudio.bgm.pause();
    }
  }

  Future<void> toggleBgMusic() async {
    if (!p.isMusicPlaying) {
      FlameAudio.bgm.play(bgMusic);
      p.updateBgMusicState(true);
    } else {
      FlameAudio.bgm.stop();
      p.updateBgMusicState(false);
    }
  }

  Future<void> loadSfx() async {
    await FlameAudio.audioCache.loadAll([sfx, paddleSfx, wallSfx, goalSfx]);
  }

  void onButtonPressed() {
    FlameAudio.play(sfx, volume: p.sfxVolume);
  }

  void onPaddleCollision() {
    FlameAudio.play(paddleSfx, volume: p.sfxVolume);
  }

  void onWallCollision() {
    FlameAudio.play(wallSfx, volume: p.sfxVolume);
  }

  void onGoal() {
    FlameAudio.play(goalSfx, volume: p.sfxVolume);
  }

  void onGameComplete() {
    FlameAudio.play(finalWhistle, volume: p.sfxVolume);
  }

  void stopBgm() {
    if (p.isMusicPlaying) FlameAudio.bgm.stop();
  }

  void startBgm() {
    if (p.isMusicPlaying) FlameAudio.bgm.play(bgMusic);
  }

  Future<void> toggleSfx() async {
    if (!p.isSfxOn) {
      p.updateSfxState(true);
    } else {
      p.updateSfxState(false);
    }
  }
}
