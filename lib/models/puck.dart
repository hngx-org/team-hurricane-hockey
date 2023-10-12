import 'package:flutter/material.dart';
import 'package:team_hurricane_hockey/constants.dart';

class Puck {
  double left = 0;
  double top = 0;
  double right = 0;
  double bottom = 0;
  double centerX = 0;
  double centerY = 0;
  double mass = 15;
  double velocityX = 0;
  double velocityY = 0;
  double maxSpeed = 10;
  double frictionX = 0.997;
  double frictionY = 0.997;
  double acceleration = 1;
  final double size = ballSize;
  final double radius = ballRadius;
  final Color color;

  Puck({
    required this.color,
  });
}
