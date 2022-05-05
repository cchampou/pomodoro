import 'package:flutter/material.dart';
import 'package:pomodoro/settings/increment_buttons.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage(
      {Key? key,
      required this.sessionTime,
      required this.addSessionTime,
      required this.removeSessionTime})
      : super(key: key);

  String sessionTime;
  void Function() addSessionTime;
  void Function() removeSessionTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IncrementButton(onPressed: removeSessionTime, text: '-1'),
          Text(sessionTime),
          IncrementButton(onPressed: addSessionTime, text: '+1'),
        ],
      )),
    );
  }
}
