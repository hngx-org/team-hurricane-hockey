import 'package:flutter/material.dart';
import 'package:team_hurricane_hockey/constants.dart';

class Puck {
  double left = 0;
  double right = 0;
  double top = 0;
  double bottom = 0;
  double centerX = 0;
  double centerY = 0;
  double shotX = 0;
  double shotY = 0;
  int score = 0;
  final String name;
  final double size = playerSize;
  final Color color;

  Puck({
    required this.name,
    required this.color,
  });
}
