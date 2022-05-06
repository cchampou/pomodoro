import 'package:flutter/material.dart';

const initialDuration = Duration(minutes: 10);

class Settings extends ChangeNotifier {
  Duration sessionTime = initialDuration;

  addSessionTime() {
    sessionTime += const Duration(minutes: 1);
    notifyListeners();
  }

  removeSessionTime() {
    sessionTime -= const Duration(minutes: 1);
    notifyListeners();
  }
}
