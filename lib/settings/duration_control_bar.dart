import 'package:flutter/material.dart';

import '../utils.dart';
import '../main.dart';
import 'increment_buttons.dart';

class DurationControlBar extends StatelessWidget {
  DurationControlBar(
      {Key? key,
      required this.settings,
      required this.label,
      required this.type})
      : super(key: key);

  final timerType type;
  final settings;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Text(label),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IncrementButton(
                    onPressed: () {
                      settings.alterDurationSettings(
                          type, const Duration(minutes: -5));
                    },
                    text: '-5'),
                IncrementButton(
                    onPressed: () {
                      settings.alterDurationSettings(
                          type, const Duration(minutes: -1));
                    },
                    text: '-1'),
                Text(twoDigits(settings.getDurationByType(type).inMinutes)),
                IncrementButton(
                    onPressed: () {
                      settings.alterDurationSettings(
                          type, const Duration(minutes: 1));
                    },
                    text: '+1'),
                IncrementButton(
                    onPressed: () {
                      settings.alterDurationSettings(
                          type, const Duration(minutes: 5));
                    },
                    text: '+5'),
              ],
            ),
          ],
        ));
  }
}
