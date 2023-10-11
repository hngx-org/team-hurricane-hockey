import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_hurricane_hockey/screens/widgets/dotted_line.dart';

class CenterLine extends StatelessWidget {
  const CenterLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomPaint(
            size: Size(100.w, 1),
            painter: DottedLinePainter(),
          ),
        ),
        Container(
          height: 80.h,
          width: 80.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(.8),
            border: Border.all(
              color: Colors.blue.shade800,
              width: 3.w,
            ),
          ),
          child: Center(
            child: Container(
              height: 24.w,
              width: 24.w,
              decoration: BoxDecoration(
                color: Colors.red.shade800,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Expanded(
          child: CustomPaint(
            size: Size(100.w, 1),
            painter: DottedLinePainter(),
          ),
        ),
      ],
    );
  }
}
