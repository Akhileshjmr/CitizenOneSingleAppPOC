import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/core.dart';
import '../tokens/app_palette.dart';
import '../spacing/app_spacing.dart';
import '../typography/app_typography.dart';
import '../atoms/app_button.dart';

/// Reusable view presented when an authenticated user attempts to access
/// routes requiring permissions they do not possess (e.g. non-Agent accessing Agent dashboard).
class UnauthorizedAccessView extends StatelessWidget {
  final UserModel? user;
  final String? deniedPath;

  const UnauthorizedAccessView({
    super.key,
    this.user,
    this.deniedPath,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppPalette.danger.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.gpp_bad_outlined,
                size: 64,
                color: AppPalette.danger,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Access Restricted: Agent Role Required',
              style: AppTypography.title,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Your current account (${user?.username ?? "user"}) with assigned roles [${user?.roles.join(", ") ?? "CITIZEN"}] does not have permission to access Agent Civic Operations or Agency Banking${deniedPath != null ? " ($deniedPath)" : ""}.',
              style: AppTypography.body.copyWith(color: AppPalette.neutral500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Go to Citizen Services',
                backgroundColor: AppPalette.citizenOne,
                onPressed: () => context.go('/citizen-one'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Sign In as Authorized Agent',
                backgroundColor: AppPalette.white,
                textColor: AppPalette.citizenOne,
                onPressed: () => context.go('/login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

