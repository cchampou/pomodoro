import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button({Key? key, required this.child, required this.onPressed})
      : super(key: key);

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 3,
            )
          ],
          borderRadius: BorderRadius.circular(100),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(100),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 32, right: 32),
            child: DefaultTextStyle(
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              child: Container(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
