import 'package:flutter/material.dart';
import 'package:team_hurricane_hockey/constants.dart';
import 'package:team_hurricane_hockey/models/player.dart';

class PlayerChip extends StatelessWidget {
  const PlayerChip({super.key, required this.player});
  final Player player;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(playerRadius),
      child: Container(
        width: player.size,
        height: player.size,
        color: player.color,
      ),
    );
  }
}
