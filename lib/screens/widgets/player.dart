import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: player.name == "blue" ? Colors.blue : Colors.red,
        border: Border.all(
          color: player.name == "blue" ? Colors.blue : Colors.red,
          width: 3.w,
        ),
      ),
      width: player.size.w,
      height: player.size.w,
      child: Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: player.name == "blue"
              ? Colors.blue.shade900
              : Colors.red.shade900,
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
