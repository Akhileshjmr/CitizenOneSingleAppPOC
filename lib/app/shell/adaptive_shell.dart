import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/app/shell/mobile_shell.dart';
import 'package:citizenone_app/app/shell/tablet_shell.dart';
import 'package:citizenone_app/app/shell/web_shell.dart';
import 'package:citizenone_app/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/features/auth/presentation/state/auth_cubit.dart';

class AdaptiveShell extends StatelessWidget {
  final Widget child;

  const AdaptiveShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final location = GoRouterState.of(context).uri.toString();
    final role = authState.selectedRole;

    return AdaptiveLayout(
      mobile: MobileShell(location: location, role: role, child: child),
      tablet: TabletShell(location: location, role: role, child: child),
      desktop: WebShell(location: location, role: role, child: child),
    );
  }
}
