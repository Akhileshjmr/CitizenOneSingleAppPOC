import 'package:flutter/material.dart';
import 'package:citizenone_app/app/shell/mobile_shell.dart';
import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';

class TabletShell extends StatelessWidget {
  final Widget child;
  final String location;
  final UserRole role;

  const TabletShell({
    super.key,
    required this.child,
    required this.location,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return MobileShell(location: location, role: role, child: child);
  }
}
