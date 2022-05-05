import 'package:flutter/material.dart';
import 'package:pomodoro/digit.dart';
import 'package:pomodoro/utils.dart';

class Counter extends StatelessWidget {
  Counter({Key? key, required this.count}) : super(key: key);

  Duration count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Digit(value: twoDigits(count.inHours), label: 'Hours'),
        Digit(
            value: twoDigits(count.inMinutes.remainder(60)), label: 'Minutes'),
        Digit(value: twoDigits(count.inSeconds.remainder(60)), label: 'Seconds')
      ],
    );
  }
}
