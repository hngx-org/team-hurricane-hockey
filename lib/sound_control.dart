import 'package:flame_audio/flame_audio.dart';
import 'package:provider/provider.dart';
import 'package:team_hurricane_hockey/providers/my_provider.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';

// final bgMusic = AudioPlayer();
// final sfx = AudioPlayer();
// final paddleSfx = AudioPlayer();
// final wallSfx = AudioPlayer();
// final goalSfx = AudioPlayer();
// final goalWhistle = AudioPlayer();
// final finalWhistle = AudioPlayer();

// class SoundControl {
//   final p = Provider.of<MyProvider>(BaseNavigator.currentContext);

//   Future<void> startBgMusic() async {
//     // if (p.isMusicPlaying) {
//     await bgMusic.play(AssetSource('sounds/bg_music.mp3'));
//     bgMusic.setReleaseMode(ReleaseMode.loop);

//     p.updateBgMusicState(true);
//     // }
//   }

//   Future<void> resumeBgMusic() async {
//     await bgMusic.resume();

//     p.updateBgMusicState(true);
//   }

//   Future<void> stopBgMusic() async {
//     await bgMusic.stop();

//     p.updateBgMusicState(false);
//   }

//   Future<void> toggleBgMusic() async {
//     if (p.isMusicPlaying) {
//       stopBgMusic();
//     } else {
//       startBgMusic();
//     }
//   }

//   Future<void> initSfx() async {
//     await sfx.setSource(AssetSource('sounds/menu_select.mp3'));
//     await sfx.setVolume(1.0);
//     p.updateSfxState(true);
//   }

//   Future<void> initPaddleSfx() async {
//     await paddleSfx.setSource(AssetSource('sounds/paddle.mp3'));
//   }

//   Future<void> initWallSfx() async {
//     await wallSfx.setSource(AssetSource('sounds/wall.mp3'));
//   }

//   Future<void> initGoalSfx() async {
//     await goalSfx.setSource(AssetSource('sounds/goal.mp3'));
//     await goalWhistle.setSource(AssetSource('sounds/goal_whistle.mp3'));
//   }

//   Future<void> initFinalWhistle() async {
//     await finalWhistle.setSource(AssetSource('sounds/final_whistle.mp3'));
//   }

//   Future<void> playSfx() async {
//     await sfx.play(AssetSource('sounds/menu_select.mp3'), volume: p.sfxVolume);
//   }

//   Future<void> toggleSfx() async {
//     if (!p.isSfxOn) {
//       await sfx.setVolume(1.0);
//       p.updateSfxState(true);
//     } else {
//       await sfx.setVolume(0.0);

//       p.updateSfxState(false);
//     }
//   }

//   Future<void> onPaddleCollision() async {
//     if (p.isSfxOn) {
//       await paddleSfx.play(AssetSource('sounds/paddle.mp3'),
//           volume: p.sfxVolume);
//     }
//   }

//   Future<void> onWallCollision() async {
//     if (p.isSfxOn) {
//       await wallSfx.play(
//         AssetSource('sounds/wall.mp3'),
//         volume: p.sfxVolume,
//       );
//       wallSfx.setReleaseMode(ReleaseMode.release);
//     }
//   }

//   Future<void> onGoal() async {
//     if (p.isSfxOn) {
//       await goalSfx.play(AssetSource('sounds/goal.mp3'), volume: p.sfxVolume);
//       await goalWhistle.play(AssetSource('sounds/goal_whistle.mp3'));
//     }
//   }

//   Future<void> onGameFinished() async {
//     if (p.isSfxOn) {
//       await finalWhistle.play(AssetSource('sounds/final_whistle.mp3'));
//     }
//   }
// }

const bgMusic = 'bg_music.mp3';
const sfx = 'menu_select.mp3';
const paddleSfx = 'paddle.mp3';
const wallSfx = 'wall.mp3';
const goalSfx = 'goal.mp3';

const finalWhistle = 'final_whistle.mp3';

class SoundControl {
  final p = Provider.of<MyProvider>(BaseNavigator.currentContext);
  void startBgMusic() {
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

  Future<void> toggleSfx() async {
    if (!p.isSfxOn) {
      p.updateSfxState(true);
    } else {
      p.updateSfxState(false);
    }
  }
}
