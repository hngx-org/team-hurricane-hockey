class GameEvent {
  Events? events;

  GameEvent({
    this.events,
  });

  factory GameEvent.fromJson(Map<String, dynamic> json) => GameEvent(
        events: json["events"] == null ? null : Events.fromJson(json["events"]),
      );

  Map<String, dynamic> toJson() => {
        "events": events?.toJson(),
      };
}

class Events {
  Position? ballPosition;
  Position? player1Position;
  Position? player2Position;
  String? gameStatus;
  Player? player1;
  Player? player2;
  int? gameRule;

  Events({
    this.ballPosition,
    this.player1Position,
    this.player2Position,
    this.gameStatus,
    this.player1,
    this.player2,
    this.gameRule,
  });

  factory Events.fromJson(Map<String, dynamic> json) => Events(
        ballPosition: json["ball_position"] == null ? null : Position.fromJson(json["ball_position"]),
        player1Position: json["player_1_position"] == null ? null : Position.fromJson(json["player_1_position"]),
        player2Position: json["player_2_position"] == null ? null : Position.fromJson(json["player_2_position"]),
        gameStatus: json["game_status"],
        player1: json["player_1"] == null ? null : Player.fromJson(json["player_1"]),
        player2: json["player_2"] == null ? null : Player.fromJson(json["player_2"]),
        gameRule: json["game_rule"],
      );

  Map<String, dynamic> toJson() => {
        "ball_position": ballPosition?.toJson(),
        "player_1_position": player1Position?.toJson(),
        "player_2_position": player2Position?.toJson(),
        "game_status": gameStatus,
        "player_1": player1?.toJson(),
        "player_2": player2?.toJson(),
        "game_rule": gameRule,
      };
}

class Position {
  int? x;
  int? y;

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

class Player {
  int? id;
  String? name;
  int? score;

  Player({
    this.id,
    this.name,
    this.score,
  });

  factory Player.fromJson(Map<String, dynamic> json) => Player(
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
