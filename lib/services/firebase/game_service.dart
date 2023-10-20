import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_hurricane_hockey/models/game.dart';

class GameService {
  GameService._();
  static final GameService instance = GameService._();
  final firestore = FirebaseFirestore.instance;

  Future<Game?> getGame(
    String gameId,
  ) async {
    try {
      final result = await firestore.collection("playing").doc(gameId).get();
      if (result.exists) {
        final game = Game.fromJson(result.data()!);
        return game;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future updatePaddleMovement(
    String gameId,
    String playerId,
    double dx,
    double dy,
  ) async {
    final gameRoomRef = firestore.collection('playing').doc(gameId);
    final gameRoomData = (await gameRoomRef.get()).data();

    if (gameRoomData != null) {
      final game = Game.fromJson(gameRoomData);
      if (game.players?.playerId1?.id == playerId) {
        //If player is player 1
        final playerPosition = {
          "x": dx,
          "y": dy,
        };
        await gameRoomRef.update({
          "player1_position": playerPosition,
        });
      } else {
        //If player is player 2
        final playerPosition = {
          "x": dx,
          "y": dy,
        };
        await gameRoomRef.update({
          "player2_position": playerPosition,
        });
      }
    }
  }

  Future<bool> createGame(
    String gameId,
    String opponentId,
    String opponentName,
    String userId,
    String userName,
  ) async {
    try {
      final result = await firestore.collection("playing").doc(gameId).get();
      if (!result.exists) {
        await firestore.collection("playing").doc(gameId).set({
          "players": {
            "player_id_1": {
              "id": userId,
              "name": userName,
              "score": 0,
            },
            "player_id_2": {
              "id": opponentId,
              "name": opponentName,
              "score": 0,
            },
          },
          "created_at": DateTime.now().toIso8601String(),
        });

        final get = await firestore.collection("playing").doc(gameId).get();
        if (get.exists) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
