import 'package:flutter/material.dart';

class IncrementButton extends StatelessWidget {
  IncrementButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  void Function() onPressed;
  String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(onPressed: onPressed, child: Text(text)),
    );
  }
}
