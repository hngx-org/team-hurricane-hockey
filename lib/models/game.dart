class Game {
  Players? players;
  DateTime? createdAt;

  Game({
    this.players,
    this.createdAt,
  });

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        players: json["players"] == null ? null : Players.fromJson(json["players"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "players": players?.toJson(),
        "created_at": createdAt?.toIso8601String(),
      };
}

class Position {
  num? x;
  num? y;

  Position({
    this.x,
    this.y,
  });

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        x: json["x"],
        y: json["y"],
      );

  Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
      };
}

class Players {
  PlayerId? playerId1;
  PlayerId? playerId2;

  Players({
    this.playerId1,
    this.playerId2,
  });

  factory Players.fromJson(Map<String, dynamic> json) => Players(
        playerId1: json["player_id_1"] == null ? null : PlayerId.fromJson(json["player_id_1"]),
        playerId2: json["player_id_2"] == null ? null : PlayerId.fromJson(json["player_id_2"]),
      );

  Map<String, dynamic> toJson() => {
        "player_id_1": playerId1?.toJson(),
        "player_id_2": playerId2?.toJson(),
      };
}

class PlayerId {
  String? id;
  String? name;
  int? score;

  PlayerId({
    this.id,
    this.name,
    this.score,
  });

  factory PlayerId.fromJson(Map<String, dynamic> json) => PlayerId(
        id: json["id"],
        name: json["name"],
        score: json["score"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "score": score,
      };
}
