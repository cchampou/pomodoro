import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

const Duration defaultSessionTime = Duration(minutes: 35);
const Duration defaultBreakTime = Duration(minutes: 10);

class Settings extends ChangeNotifier {
  Duration sessionDuration = defaultSessionTime;
  Duration breakDuration = defaultBreakTime;
  bool settingsChanged = false;
  bool keepAwake = false;

  Duration getDurationByType(TimerType type) =>
      type == TimerType.sessionType ? sessionDuration : breakDuration;

  void settingsApplied() {
    settingsChanged = false;
  }

  Future<void> getFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    sessionDuration = Duration(
        minutes:
            prefs.getInt('sessionDuration') ?? defaultSessionTime.inMinutes);
    breakDuration = Duration(
        minutes: prefs.getInt('breakDuration') ?? defaultBreakTime.inMinutes);
    keepAwake = prefs.getBool('keepAwake') ?? false;
    notifyListeners();
  }

  void toggleKeepAwake(bool value) async {
    keepAwake = value;
    final prefs = await SharedPreferences.getInstance();
    if (keepAwake) {
      WakelockPlus.enable();
      prefs.setBool('keepAwake', true);
    } else {
      WakelockPlus.disable();
      prefs.setBool('keepAwake', false);
    }
    notifyListeners();
  }

  alterDurationSettings(TimerType type, Duration duration) async {
    settingsChanged = true;
    final prefs = await SharedPreferences.getInstance();
    if (type == TimerType.sessionType &&
        sessionDuration + duration > const Duration(minutes: 0)) {
      sessionDuration += duration;
      prefs.setInt('sessionDuration', sessionDuration.inMinutes);
    } else if (type == TimerType.breakType &&
        breakDuration + duration > const Duration(minutes: 0)) {
      breakDuration += duration;
      prefs.setInt('breakDuration', breakDuration.inMinutes);
    }
    notifyListeners();
  }
}
