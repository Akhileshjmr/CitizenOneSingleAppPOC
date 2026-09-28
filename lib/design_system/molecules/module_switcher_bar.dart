import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/generated/enabled_modules.dart';
import '../spacing/app_spacing.dart';
import '../typography/app_typography.dart';

/// Navigation bar widget allowing instant switching between all active business modules.
class ModuleSwitcherBar extends StatelessWidget {
  final String currentModuleId;

  const ModuleSwitcherBar({
    super.key,
    required this.currentModuleId,
  });

  IconData _getModuleIcon(String id) {
    switch (id) {
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

  @override
  Widget build(BuildContext context) {
    if (enabledModules.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MODULE SWITCHER',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              InkWell(
                onTap: () => context.go('/'),
                child: Row(
                  children: [
                    const Icon(Icons.home, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Dashboard Hub',
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: enabledModules.map((module) {
                final isSelected = module.id == currentModuleId;
                final routePath = module.initialRoute;

                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: FilterChip(
                    selected: isSelected,
                    showCheckmark: false,
                    avatar: Icon(
                      _getModuleIcon(module.id),
                      size: 16,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                    ),
                    label: Text(module.title),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                    selectedColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    onSelected: (_) {
                      if (!isSelected) {
                        context.push(routePath);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
