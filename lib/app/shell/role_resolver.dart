import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';
import 'package:citizenone_app/features/auth/presentation/state/auth_cubit.dart';

class RoleResolver extends StatelessWidget {
  const RoleResolver({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.watch<AuthCubit>().state.selectedRole;
    
    // Redirect based on role
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (role == UserRole.agent) {
        context.go('/agent');
      } else if (role == UserRole.farmer) {
        context.go('/farmer');
      } else {
        context.go('/customer');
      }
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
