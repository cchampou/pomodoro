import 'package:flutter/material.dart';

import '../components/button.dart';
import '../utils.dart';
import '../main.dart';

class DurationControlBar extends StatelessWidget {
  const DurationControlBar(
      {super.key,
      required this.settings,
      required this.label,
      required this.type});

  final TimerType type;
  final settings;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button(
                    onPressed: () {
                      settings.alterDurationSettings(
                          type, const Duration(minutes: -5));
                    },
                    child: const Text('-5')),
                Button(
                    onPressed: () {
                      settings.alterDurationSettings(
                          type, const Duration(minutes: -1));
                    },
                    child: const Text('-1')),
                Text(twoDigits(settings.getDurationByType(type).inMinutes),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Button(
                    onPressed: () {
                      settings.alterDurationSettings(
                          type, const Duration(minutes: 1));
                    },
                    child: const Text('+1')),
                Button(
                    onPressed: () {
                      settings.alterDurationSettings(
                          type, const Duration(minutes: 5));
                    },
                    child: const Text('+5')),
              ],
            ),
          ],
        ));
  }
}
