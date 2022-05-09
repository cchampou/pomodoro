import 'package:flutter/material.dart';

import 'main.dart';

const Duration defaultSessionTime = Duration(minutes: 45);
const Duration defaultBreakTime = Duration(minutes: 10);

class Settings extends ChangeNotifier {
  Duration sessionDuration = defaultSessionTime;
  Duration breakDuration = defaultBreakTime;
  bool settingsChanged = false;

  Duration getDurationByType(timerType type) =>
      type == timerType.sessionType ? sessionDuration : breakDuration;

  void settingsApplied() {
    settingsChanged = false;
  }

  alterDurationSettings(timerType type, Duration duration) {
    settingsChanged = true;
    if (type == timerType.sessionType &&
        sessionDuration + duration > const Duration(minutes: 0)) {
      sessionDuration += duration;
    } else if (type == timerType.breakType &&
        breakDuration + duration > const Duration(minutes: 0)) {
      breakDuration += duration;
    }
    notifyListeners();
  }
}
