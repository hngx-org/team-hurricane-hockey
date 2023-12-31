import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_hurricane_hockey/constants.dart';
import 'package:team_hurricane_hockey/models/puck.dart';

class PuckChip extends StatelessWidget {
  const PuckChip({super.key, required this.puck});
  final Puck puck;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(playerRadius),
      child: Container(
        width: puck.size.w,
        height: puck.size.w,
        color: puck.color,
      ),
    );
  }
}
