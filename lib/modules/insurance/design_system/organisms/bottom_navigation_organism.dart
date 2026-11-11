// =============================================================================
// BottomNavigationOrganism  —  ORGANISM
// -----------------------------------------------------------------------------
// Themed bottom navigation. Supports any number of items; the active/
// inactive states use brand colors. Stateless — the parent owns the
// current index.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/extensions/build_context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../atoms/atoms.dart';

class BottomNavItem {
  const BottomNavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class BottomNavigationOrganism extends StatelessWidget {
  const BottomNavigationOrganism({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<BottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.surface,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(items.length, (i) {
              final selected = i == currentIndex;
              final color = selected ? c.primary : c.textSecondary;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(items[i].icon, color: color, size: 22),
                      const SizedBox(height: AppSpacing.xs),
                      AppText(
                        items[i].label,
                        variant: AppTextVariant.label,
                        color: color,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
