import 'package:flutter/material.dart';
import 'package:citizenone_app/app/shell/adaptive_shell.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AdaptiveShell(child: child);
  }
}
