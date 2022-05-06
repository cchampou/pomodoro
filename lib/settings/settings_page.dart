import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings_provider.dart';
import '../settings/duration_control_bar.dart';
import '../main.dart';

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
        builder: (context, settings, child) => Column(
          children: [
            DurationControlBar(
                settings: settings,
                type: timerType.sessionType,
                label: 'Session duration in minutes'),
            DurationControlBar(
                settings: settings,
                type: timerType.breakType,
                label: 'Break duration in minutes'),
          ],
        ),
      ),
    );
  }
}
