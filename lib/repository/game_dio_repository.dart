import 'package:team_hurricane_hockey/data/api/api_implementation.dart';

class GameDioRepo extends ApiImplementation {
  GameDioRepo._init();
  static final GameDioRepo instance = GameDioRepo._init();

  Future<String?> createGame() async {
    try {
      final s = await gameDioService().createGame();
      if (s.data != null) {
        final result = s.data["game_id"];
        return result.toString();
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
