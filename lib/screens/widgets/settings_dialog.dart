import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:team_hurricane_hockey/router/base_navigator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  AudioPlayer bgMusic = AudioPlayer();
  IconData bgMusicIcon = Icons.volume_up_sharp;
  IconData? sfxIcon = Icons.music_note_sharp;
  Function setIconState({
    required bool soundState,
    required IconData iconOn,
    required IconData iconOff,
  }) {
    return () {
      soundState = !soundState;
      return soundState ? iconOn : iconOff;
    };
  }

  bool isBgMusicOn = true;
  bool isSoundOn = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF150337),
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
        ),
      ),
      content: Column(
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
            onPressed: () {
              setState(() {
                final toggleState = setIconState(
                    soundState: isBgMusicOn,
                    iconOn: Icons.volume_up_sharp,
                    iconOff: Icons.volume_off_sharp);
                isBgMusicOn = !isBgMusicOn;
                final newIconData = toggleState();
                bgMusicIcon = newIconData;
              });
            },
            label: Text(
              'BG MUSIC',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            icon: Icon(
              bgMusicIcon,
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
              setState(() {
                isSoundOn = !isSoundOn;
                sfxIcon = isSoundOn ? Icons.music_note_sharp : Icons.music_off;
              });
            },
            label: Text(
              'SFX',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            icon: Icon(
              sfxIcon,
              color: Colors.white,
            ),
          ),
          // const SizedBox(height: 15.0),
          Divider(
            color: Colors.grey[200],
            height: 30.0,
            thickness: 0.3,
          ),
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
            onPressed: () {},
            label: Text(
              'SYNC WITH GOOGLE',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(fontSize: 15.0),
            ),
            icon: const Icon(
              FontAwesomeIcons.google,
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
              BaseNavigator.pop();
            },
            label: Text(
              'CLOSE',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(fontSize: 15.0),
            ),
            icon: const Icon(
              Icons.close_sharp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
