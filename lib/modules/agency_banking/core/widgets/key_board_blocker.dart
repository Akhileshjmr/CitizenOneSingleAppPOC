import 'package:flutter/material.dart';

class KeyboardBlocker extends StatelessWidget {
  final Widget child;
  const KeyboardBlocker({required this.child});

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      canRequestFocus: true, // allows widgets to request focus normally when interacted with
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: child,
      ),
    );
  }
}

