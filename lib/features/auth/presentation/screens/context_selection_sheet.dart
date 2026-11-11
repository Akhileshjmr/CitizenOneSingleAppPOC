import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/components/foundation/glass_container.dart';
import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';
import 'package:citizenone_app/features/auth/presentation/state/auth_cubit.dart';
import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:go_router/go_router.dart';

class ContextSelectionSheet extends StatelessWidget {
  const ContextSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final currentRole = context.watch<AuthCubit>().state.selectedRole;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    context.l10n.authContextSelect,
                    style: AppTextStyle.headlineSmall,
                    color: tokens.textPrimary,
                  ),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.close, color: tokens.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildRoleOption(
                context,
                role: UserRole.citizen,
                isSelected: currentRole == UserRole.citizen,
                icon: Icons.person_outline,
                title: context.l10n.authRoleCitizen,
                description: context.l10n.authRoleCitizenDesc,
              ),
              const SizedBox(height: 16),
              _buildRoleOption(
                context,
                role: UserRole.agent,
                isSelected: currentRole == UserRole.agent,
                icon: Icons.business_center_outlined,
                title: context.l10n.authRoleAgent,
                description: context.l10n.authRoleAgentDesc,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption(
    BuildContext context, {
    required UserRole role,
    required bool isSelected,
    required IconData icon,
    required String title,
    required String description,
  }) {
    final tokens = context.appTokens;
    return GestureDetector(
      onTap: () {
        context.read<AuthCubit>().setRole(role);
        context.pop(); // Close sheet after selection
      },
      child: GlassContainer(
        color: isSelected
            ? tokens.brandBlue.withValues(alpha: 0.2)
            : tokens.surfaceMuted.withValues(alpha: 0.5),
        border: isSelected
            ? Border.all(color: tokens.brandBlue, width: 2)
            : null,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? tokens.brandBlue : tokens.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : tokens.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    style: AppTextStyle.bodyLarge,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : tokens.textPrimary,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    description,
                    style: AppTextStyle.caption,
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.8)
                        : tokens.textSecondary,
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: tokens.success),
          ],
        ),
      ),
    );
  }
}
