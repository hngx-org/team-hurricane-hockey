class Game {
  PlayerId? playerId1;
  PlayerId? playerId2;
  Position? ballPosition;
  Position? player1Position;
  Position? player2Position;
  String? status;
  String? winner;
  String? pausedBy;
  DateTime? createdAt;

  Game({
    this.playerId1,
    this.playerId2,
    this.ballPosition,
    this.player1Position,
    this.player2Position,
    this.status,
    this.winner,
    this.pausedBy,
    this.createdAt,
  });

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        playerId1: json["player_id_1"] == null ? null : PlayerId.fromJson(json["player_id_1"]),
        playerId2: json["player_id_2"] == null ? null : PlayerId.fromJson(json["player_id_2"]),
        ballPosition: json["ball_position"] == null ? null : Position.fromJson(json["ball_position"]),
        player1Position: json["player1_position"] == null ? null : Position.fromJson(json["player1_position"]),
        player2Position: json["player2_position"] == null ? null : Position.fromJson(json["player2_position"]),
        status: json["status"],
        winner: json["winner"],
        pausedBy: json["pausedBy"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "player_id_1": playerId1?.toJson(),
        "player_id_2": playerId2?.toJson(),
        "ball_position": ballPosition?.toJson(),
        "player1_position": player1Position?.toJson(),
        "player2_position": player2Position?.toJson(),
        "status": status,
        "winner": winner,
        "pausedBy": pausedBy,
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

class PlayerId {
  String? id;
  String? name;
  int? score;
  bool? isReady;

  PlayerId({
    this.id,
    this.name,
    this.score,
    this.isReady,
  });

  factory PlayerId.fromJson(Map<String, dynamic> json) => PlayerId(
        id: json["id"],
        name: json["name"],
        score: json["score"],
        isReady: json["is_ready"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "score": score,
        "is_ready": isReady,
      };
}
