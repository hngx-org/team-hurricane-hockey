import 'package:flutter/material.dart';

class TopSpace extends StatelessWidget {
  final double playerSize;
  const TopSpace({super.key, required this.playerSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          SizedBox(height: playerSize),
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
                      height: 20,
                      width: 20,
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
      child: Column(
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
                      height: 20,
                      width: 20,
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
          SizedBox(height: playerSize),
        ],
      ),
    );
  }
}
