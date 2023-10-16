import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:team_hurricane_hockey/providers/my_provider.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';
import 'package:team_hurricane_hockey/screens/paddles_and_puck_screen.dart';
import 'package:team_hurricane_hockey/sound_control.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  SoundControl controller = SoundControl();
  final p = Provider.of<MyProvider>(BaseNavigator.currentContext);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF150337),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                side: const BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
                shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
                ),
              ),
              onPressed: () async {
                controller.playSfx();
                controller.toggleBgMusic();
              },
              label: Text(
                'BG MUSIC',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              icon: Icon(
                p.isMusicPlaying
                    ? Icons.volume_up_sharp
                    : Icons.volume_off_sharp,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15.0),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                side: const BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
                shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
                ),
              ),
              onPressed: () {
                controller.playSfx();
                controller.toggleSfx();
              },
              label: Text(
                'SFX',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              icon: Icon(
                p.isSfxOn ? Icons.music_note : Icons.music_off,
                color: Colors.white,
              ),
            ),
            // const SizedBox(height: 15.0),
            Divider(
              color: Colors.grey[200],
              height: 30.0,
              thickness: 0.3,
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 6.0.w, horizontal: 8.w),
                side: const BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
                shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
                ),
              ),
              onPressed: () {},
              child: FittedBox(
                child: Text(
                  'SYNC WITH GOOGLE',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
            const SizedBox(height: 15.0),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 6.0.w, horizontal: 8.w),
                side: const BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
                shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
                ),
              ),
              onPressed: () {
                BaseNavigator.pushNamed(PaddlesAndPuckScreen.routeName);
              },
              child: FittedBox(
                child: Text(
                  'PADDLES & PUCKS',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
            SizedBox(height: 15.0.h),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                side: const BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
                shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
                ),
              ),
              onPressed: () {
                controller.playSfx();
                BaseNavigator.pop();
              },
              label: Text(
                'CLOSE',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              icon: const Icon(
                Icons.close_sharp,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
