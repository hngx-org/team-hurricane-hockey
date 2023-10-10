import 'package:flutter/material.dart';
import 'package:team_hurricane_hockey/screens/widgets/goal_post.dart';
import 'dart:math' as math;

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
            top: -60,
            left: MediaQuery.of(context).size.width / 2 - (50),
            child: Center(
              child: CustomPaint(
                size: const Size(100, 100), // Adjust size as needed
                painter: SemiCirclePainter(
                  color: Colors.blue.shade800,
                  isTop: true,
                ),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 100),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .1),
                child: Row(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(.8),
                        border: Border.all(
                          color: Colors.red.shade800,
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: Colors.red.shade800,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(.8),
                        border: Border.all(
                          color: Colors.red.shade800,
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          height: 10,
                          width: 10,
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
            bottom: -60,
            left: MediaQuery.of(context).size.width / 2 - (50),
            child: Center(
              child: Transform.rotate(
                angle: math.pi,
                child: CustomPaint(
                  size: const Size(100, 100), // Adjust size as needed
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
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(.8),
                        border: Border.all(
                          color: Colors.red.shade800,
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Colors.red.shade800,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(.8),
                        border: Border.all(
                          color: Colors.red.shade800,
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          height: 10,
                          width: 10,
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
              const SizedBox(height: 100),
            ],
          ),
        ],
      ),
    );
  }
}
