import 'package:flutter/material.dart';
import 'package:pomodoro/settings/increment_buttons.dart';
import 'package:pomodoro/utils.dart';
import 'package:provider/provider.dart';

import '../settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Consumer<Settings>(
          builder: (context, settings, child) => Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IncrementButton(
                      onPressed: settings.removeSessionTime, text: '-1'),
                  Text(twoDigits(settings.sessionTime.inMinutes)),
                  IncrementButton(
                      onPressed: settings.addSessionTime, text: '+1'),
                ],
              ))),
    );
  }
}
