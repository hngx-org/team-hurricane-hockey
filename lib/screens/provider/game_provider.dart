import 'package:flutter/material.dart';
import 'package:team_hurricane_hockey/models/player.dart';

class GameProvider extends ChangeNotifier {
  GameProvider._();
  static final GameProvider instance = GameProvider._();

  Player? _player;

  Player? get player => _player;
}
