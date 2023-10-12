import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:team_hurricane_hockey/models/player.dart';
import 'package:team_hurricane_hockey/models/puck.dart';
import 'package:team_hurricane_hockey/providers/my_provider.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';
import 'package:team_hurricane_hockey/screens/widgets/player.dart';
import 'package:team_hurricane_hockey/screens/widgets/puck.dart';

class PaddlesAndPuckScreen extends StatefulWidget {
  static const routeName = "paddles_and_puck";
  const PaddlesAndPuckScreen({super.key});

  @override
  State<PaddlesAndPuckScreen> createState() => _PaddlesAndPuckScreenState();
}

class _PaddlesAndPuckScreenState extends State<PaddlesAndPuckScreen> {
  final colors = [
    Colors.red,
    Colors.yellow,
    Colors.blue,
    Colors.green,
  ];

  Color? player1ColorSelected;
  Color? puckColorSelected;
  Color? player2ColorSelected;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final paddleColorProvider = Provider.of<PaddleColorProvider>(context);
    player1ColorSelected = paddleColorProvider.player1Color;
    player2ColorSelected = paddleColorProvider.player2Color;
    puckColorSelected = paddleColorProvider.puckColor;
  }

  @override
  Widget build(BuildContext context) {
    final paddleColorProvider = Provider.of<PaddleColorProvider>(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Colors.black,
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/retro_BG.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.all(8.w),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100.h,
                  ),
                  FittedBox(
                    child: Text(
                      'PADDLES AND PUCKS',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  PaddleAndPuckPicker(
                    colors: colors,
                    title: "Player 2",
                    colorSelected: player2ColorSelected,
                    onTap: (value) {
                      setState(() {
                        player2ColorSelected = value;
                      });
                      paddleColorProvider.setPlayer2Color(value);
                    },
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  PaddleAndPuckPicker(
                    colors: colors,
                    title: "Puck",
                    isPuck: true,
                    colorSelected: puckColorSelected,
                    onTap: (value) {
                      setState(() {
                        puckColorSelected = value;
                      });
                      paddleColorProvider.setPuckColor(value);
                    },
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  PaddleAndPuckPicker(
                    colors: colors,
                    title: "Player 1",
                    colorSelected: player1ColorSelected,
                    onTap: (value) {
                      setState(() {
                        player1ColorSelected = value;
                      });
                      paddleColorProvider.setPlayer1Color(value);
                    },
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        BaseNavigator.pop();
                      },
                      child: Material(
                        color: Colors.transparent,
                        shape: const BeveledRectangleBorder(
                          side: BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 30.w,
                              ),
                              Text(
                                "BACK",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PaddleAndPuckPicker extends StatelessWidget {
  const PaddleAndPuckPicker({
    super.key,
    required this.colors,
    required this.title,
    this.isPuck = false,
    required this.colorSelected,
    required this.onTap,
  });

  final List<MaterialColor> colors;
  final String title;
  final bool isPuck;
  final Color? colorSelected;
  final ValueChanged<Color> onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const BeveledRectangleBorder(
        side: BorderSide(
          color: Colors.white,
          width: 1.0,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          bottomRight: Radius.circular(12.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
        child: Column(
          children: [
            Text(
              title.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(fontSize: 24.sp),
            ),
            SizedBox(
              height: 8.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => InkWell(
                  onTap: () => onTap(colors[index]),
                  child: Container(
                    decoration: colorSelected == colors[index]
                        ? BoxDecoration(
                            border: Border.all(color: Colors.white, width: 3.w))
                        : null,
                    padding: const EdgeInsets.all(4),
                    child: isPuck
                        ? PuckChip(
                            puck: Puck(
                            name: colors[index].toString(),
                            color: colors[index],
                          ))
                        : PlayerChip(
                            player: Player(
                              name: colors[index].toString(),
                              color: colors[index],
                            ),
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
