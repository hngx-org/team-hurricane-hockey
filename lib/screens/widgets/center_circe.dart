import 'package:flutter/material.dart';
import 'package:team_hurricane_hockey/screens/widgets/dotted_line.dart';

class CenterLine extends StatelessWidget {
  const CenterLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width / 2 - 45, 1),
            painter: DottedLinePainter(),
          ),
        ),
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(.8),
            border: Border.all(
              color: Colors.blue.shade800,
              width: 4,
            ),
          ),
          child: Center(
            child: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: Colors.red.shade800,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Expanded(
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width / 2 - 45, 1),
            painter: DottedLinePainter(),
          ),
        ),
      ],
    );
  }
}
