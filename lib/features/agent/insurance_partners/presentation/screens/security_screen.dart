import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/features/agent/insurance_partners/presentation/screens/change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

/// Sidebar → Settings → Security screen. Currently a single
/// "Change Password" entry point — mirrors agency-banking's
/// `SecurityScreen`/`_ChangePasswordTile`.
class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        backgroundColor: tokens.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrow_left, color: tokens.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AppText(
          'Security',
          style: AppTextStyle.headlineSmall,
          fontWeight: FontWeight.w700,
          color: tokens.textPrimary,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _ChangePasswordTile(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChangePasswordTile extends StatelessWidget {
  final VoidCallback onTap;
  const _ChangePasswordTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return Material(
      color: tokens.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: tokens.outline),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: tokens.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(LucideIcons.lock, color: tokens.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: AppText(
                  'Change Password',
                  style: AppTextStyle.bodyLarge,
                  fontWeight: FontWeight.w700,
                  color: tokens.textPrimary,
                ),
              ),
              Icon(LucideIcons.chevron_right, color: tokens.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
