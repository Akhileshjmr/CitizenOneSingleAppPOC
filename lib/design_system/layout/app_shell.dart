import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import '../theme/app_theme.dart';
import '../spacing/app_spacing.dart';
import '../typography/app_typography.dart';
import '../../generated/enabled_modules.dart';

/// AppShell provides a unified, production-ready layout shell for the entire app.
/// It dynamically injects module-specific themes or the central design system theme
/// based on the [AppTheme.useCentralTheme] configuration flag.
class AppShell extends StatelessWidget {
  final Widget child;
  final String location;

  const AppShell({
    super.key,
    required this.child,
    required this.location,
  });

  /// Resolves current active module ID based on current URI path
  String _resolveActiveModuleId(String path) {
    if (path.startsWith('/agency-banking')) return 'agency_banking';
    if (path.startsWith('/kyc')) return 'kyc';
    if (path.startsWith('/loans')) return 'loans';
    if (path.startsWith('/insurance')) return 'insurance';
    if (path.startsWith('/common') ||
        path.startsWith('/login') ||
        path.startsWith('/forgot-') ||
        path.startsWith('/citizen-one')) {
      return 'common';
    }
    return 'root';
  }

  /// Resolves display title for current app header
  String _resolveHeaderTitle(String path) {
    if (path == '/') return 'CitizenOne SuperApp';
    if (path.startsWith('/agency-banking/cash-deposit')) return 'Cash Deposit';
    if (path.startsWith('/agency-banking')) return 'Agency Banking';
    if (path.startsWith('/kyc')) return 'KYC Verification';
    if (path.startsWith('/loans')) return 'Micro Loans';
    if (path.startsWith('/insurance')) return 'Insurance & Coverage';
    if (path.startsWith('/login')) return 'Sign In';
    if (path.startsWith('/forgot-password')) return 'Password Reset';
    if (path.startsWith('/forgot-username')) return 'Username Recovery';
    if (path.startsWith('/common') || path.startsWith('/citizen-one')) {
      return 'Common Services';
    }
    return 'CitizenOne App';
  }

  IconData _getModuleIcon(String id) {
    switch (id) {
      case 'common':
      case 'citizen_one':
        return Icons.account_balance;
      case 'agency_banking':
        return Icons.point_of_sale;
      case 'kyc':
        return Icons.verified_user;
      case 'loans':
        return Icons.monetization_on;
      case 'insurance':
        return Icons.security;
      default:
        return Icons.apps;
    }
  }

  void _handleBack(BuildContext context, String currentPath) {
    if (currentPath.startsWith('/agency-banking/cash-deposit')) {
      context.go('/agency-banking');
      return;
    }
    if (currentPath.startsWith('/forgot-')) {
      context.go('/login');
      return;
    }
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final activeModuleId = _resolveActiveModuleId(location);
    final title = _resolveHeaderTitle(location);
    final isRoot = location == '/';

    return ValueListenableBuilder<bool>(
      valueListenable: AppTheme.useCentralThemeNotifier,
      builder: (context, isCentralTheme, _) {
        AppModule? activeModule;
        for (final m in enabledModules) {
          if (m.id == activeModuleId ||
              (m.id == 'common' && activeModuleId == 'citizen_one')) {
            activeModule = m;
            break;
          }
        }
        final activeTheme =
            AppTheme.getThemeForModule(activeModuleId, module: activeModule);

        return Theme(
          data: activeTheme,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: activeTheme.colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: Colors.black26,
              surfaceTintColor: Colors.transparent,
              title: Row(
                children: [
                  if (activeModuleId != 'root') ...[
                    Icon(_getModuleIcon(activeModuleId), size: 22, color: Colors.white),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.title.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              leading: !isRoot
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      tooltip: 'Back',
                      onPressed: () => _handleBack(context, location),
                    )
                  : IconButton(
                      icon: const Icon(Icons.apps, color: Colors.white),
                      tooltip: 'Dashboard Hub',
                      onPressed: () => context.go('/'),
                    ),
              actions: [
                // Theme Mode Switcher Flag Toggle Button
                IconButton(
                  icon: Icon(
                    isCentralTheme ? Icons.palette_outlined : Icons.color_lens_outlined,
                    color: Colors.white,
                  ),
                  tooltip: isCentralTheme
                      ? 'Using Central Theme (Tap for Module Themes)'
                      : 'Using Module Theme (Tap for Central Theme)',
                  onPressed: () {
                    AppTheme.useCentralTheme = !isCentralTheme;
                  },
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthAuthenticated) {
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: PopupMenuButton<String>(
                          icon: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white24,
                            child: Text(
                              state.user.username.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          tooltip: 'User Profile',
                          onSelected: (val) {
                            if (val == 'logout') {
                              context.read<AuthCubit>().logout();
                              context.go('/');
                            } else if (val == 'toggle_theme') {
                              AppTheme.useCentralTheme = !AppTheme.useCentralTheme;
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              enabled: false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.user.username,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    state.user.email,
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem(
                              value: 'toggle_theme',
                              child: Row(
                                children: [
                                  Icon(
                                    isCentralTheme
                                        ? Icons.color_lens_outlined
                                        : Icons.palette_outlined,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isCentralTheme
                                        ? 'Switch to Module Theme'
                                        : 'Switch to Central Theme',
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'logout',
                              child: Row(
                                children: [
                                  Icon(Icons.logout, size: 18, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Sign Out', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return TextButton.icon(
                      onPressed: () => context.go('/login'),
                      icon: const Icon(Icons.login, color: Colors.white, size: 18),
                      label: const Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                // Unified Module Navigation Bar (Pill design)
                if (enabledModules.isNotEmpty &&
                    !location.startsWith('/login') &&
                    !location.startsWith('/forgot-'))
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs,
                      horizontal: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.6),
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor.withValues(alpha: 0.15),
                        ),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Hub Pill
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: InkWell(
                              onTap: () => context.go('/'),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isRoot
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isRoot
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .dividerColor
                                            .withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.home,
                                      size: 14,
                                      color: isRoot
                                          ? Colors.white
                                          : Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Hub',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isRoot
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isRoot
                                            ? Colors.white
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Module Pills
                          ...enabledModules.map((module) {
                            final isSelected = module.id == activeModuleId;
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: InkWell(
                                onTap: () {
                                  if (!isSelected) {
                                    context.go(module.initialRoute);
                                  }
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? Theme.of(context).colorScheme.primary
                                          : Theme.of(context)
                                              .dividerColor
                                              .withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _getModuleIcon(module.id),
                                        size: 14,
                                        color: isSelected
                                            ? Colors.white
                                            : Theme.of(context).colorScheme.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        module.title,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? Colors.white
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                Expanded(child: child),
              ],
            ),
          ),
        );
      },
    );
  }
}
