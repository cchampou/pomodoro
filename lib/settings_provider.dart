import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'main.dart';

const Duration defaultSessionTime = Duration(minutes: 35);
const Duration defaultBreakTime = Duration(minutes: 10);

class Settings extends ChangeNotifier {
  Duration sessionDuration = defaultSessionTime;
  Duration breakDuration = defaultBreakTime;
  bool settingsChanged = false;
  bool keepAwake = false;

  Duration getDurationByType(timerType type) =>
      type == timerType.sessionType ? sessionDuration : breakDuration;

  void settingsApplied() {
    settingsChanged = false;
  }

  void toggleKeepAwake(bool value) {
    keepAwake = value;
    if (keepAwake) {
      Wakelock.enable();
    } else {
      Wakelock.disable();
    }
    notifyListeners();
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
