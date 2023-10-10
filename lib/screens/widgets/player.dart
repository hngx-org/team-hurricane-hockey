import 'package:flutter/material.dart';
import 'package:team_hurricane_hockey/models/player.dart';

class PlayerChip extends StatelessWidget {
  const PlayerChip({
    super.key,
    required this.player,
  });
  final Player player;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: player.name == "blue" ? Colors.blue : Colors.red,
        border: Border.all(
          color: player.name == "blue" ? Colors.blue : Colors.red,
          width: 3,
        ),
      ),
      width: player.size,
      height: player.size,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: player.name == "blue" ? Colors.blue.shade900 : Colors.red.shade900,
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: player.name == "blue" ? Colors.blue : Colors.red,
          ),
        ),
      ),
    );
  }
}
