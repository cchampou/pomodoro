import 'package:flutter/material.dart';

class Digit extends StatelessWidget {
  Digit({Key? key, required this.value, required this.label}) : super(key: key);

  final String label;
  String value = '00';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 50),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
