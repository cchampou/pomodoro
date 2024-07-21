import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Pomodoro/settings_provider.dart';
import 'package:Pomodoro/settings/duration_control_bar.dart';
import 'package:Pomodoro/main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Consumer<Settings>(
        builder: (context, settings, child) => Column(
          children: [
            DurationControlBar(
                settings: settings,
                type: TimerType.sessionType,
                label: 'Session duration in minutes'),
            DurationControlBar(
                settings: settings,
                type: TimerType.breakType,
                label: 'Break duration in minutes'),
            const SizedBox(height: 20),
            Row(
              children: [
                Switch(
                  onChanged: settings.toggleKeepAwake,
                  value: settings.keepAwake,
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                const Text('Keep screen on')
              ],
            )
          ],
        ),
      ),
    );
  }
}
