import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/features/auth/presentation/state/auth_cubit.dart';

class ContextToggle extends StatelessWidget {
  const ContextToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final activeContext = context.watch<AuthCubit>().state.workContext;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOption(
            'CitizenOne',
            LucideIcons.users,
            activeContext == 'CitizenOne',
            () => context.read<AuthCubit>().setWorkContext('CitizenOne'),
          ),
          _buildOption(
            'Partner',
            LucideIcons.briefcase,
            activeContext == 'Partner',
            () => context.read<AuthCubit>().setWorkContext('Partner'),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String label, IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0F172A) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive
              ? [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]
              : [],
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: isActive ? Colors.white : Colors.grey[600]),
            const SizedBox(width: 6),
            AppText(
              label,
              style: AppTextStyle.labelSmall,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : Colors.grey[600]!,
            ),
          ],
        ),
      ),
    );
  }
}
