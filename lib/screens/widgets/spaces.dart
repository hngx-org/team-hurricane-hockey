import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:team_hurricane_hockey/screens/widgets/goal_post.dart';

class TopSpace extends StatelessWidget {
  final double playerSize;
  const TopSpace({super.key, required this.playerSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Stack(
        children: [
          Positioned(
            top: -120.h,
            left: MediaQuery.of(context).size.width / 2 - (50),
            child: Center(
              child: CustomPaint(
                size: Size(100, 200.w), // Adjust size as needed
                painter: SemiCirclePainter(
                  color: Colors.blue.shade800,
                  isTop: true,
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 100.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .1),
                child: Row(
                  children: [
                    Container(
                      height: 80.h,
                      width: 80.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(.8),
                        border: Border.all(
                          color: Colors.red.shade800,
                          width: 4.w,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          height: 10.h,
                          width: 10.h,
                          decoration: BoxDecoration(
                            color: Colors.red.shade800,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 80.h,
                      width: 80.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(.8),
                        border: Border.all(
                          color: Colors.red.shade800,
                          width: 4.w,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          height: 10.h,
                          width: 10.h,
                          decoration: BoxDecoration(
                            color: Colors.red.shade800,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BottomSpace extends StatelessWidget {
  final double playerSize;
  const BottomSpace({super.key, required this.playerSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Stack(
        children: [
          Positioned(
            bottom: -120.h,
            left: MediaQuery.of(context).size.width / 2 - (50),
            child: Center(
              child: Transform.rotate(
                angle: math.pi,
                child: CustomPaint(
                  size: Size(100, 200.w), // Adjust size as needed
                  painter: SemiCirclePainter(
                    color: Colors.blue.shade800,
                    isTop: true,
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .1),
                child: Row(
                  children: [
                    Container(
                      height: 80.h,
                      width: 80.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(.8),
                        border: Border.all(
                          color: Colors.red.shade800,
                          width: 4.w,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          height: 10.h,
                          width: 10.h,
                          decoration: BoxDecoration(
                            color: Colors.red.shade800,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 80.h,
                      width: 80.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(.8),
                        border: Border.all(
                          color: Colors.red.shade800,
                          width: 4.w,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          height: 10.h,
                          width: 10.h,
                          decoration: BoxDecoration(
                            color: Colors.red.shade800,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100.h),
            ],
          ),
        ],
      ),
    );
  }
}
