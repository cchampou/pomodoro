import 'package:flutter/material.dart';

const Duration defaultSessionTime = Duration(seconds: 30);
const Duration defaultBreakTime = Duration(seconds: 10);

class Settings extends ChangeNotifier {
  Duration sessionDuration = defaultSessionTime;
  Duration breakDuration = defaultBreakTime;

  addSessionDuration() {
    sessionDuration += const Duration(minutes: 1);
    notifyListeners();
  }

  removeSessionDuration() {
    sessionDuration -= const Duration(minutes: 1);
    notifyListeners();
  }
}
