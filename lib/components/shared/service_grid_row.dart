import 'package:flutter/material.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:flutter_svg/svg.dart';

/// A data model for a single grid item in a [ServiceGridRow].
///
/// Represents a service with an icon, label, and accent color.
/// Set `icon` to null and `label` to empty for filler/empty slots.
class SvcItem {
  final String? icon;
  final String label;
  final Color? color;
  final Color? iconColor;
  final VoidCallback? onTap;

  const SvcItem({
    required this.icon,
    required this.label,
    this.color,
    this.iconColor,
    this.onTap,
  });
}

/// A horizontal row of circular service icons, typically 4 across.
///
/// Used in Banking, Govt, and other catalog-style service screens.
///
/// Usage:
/// ```dart
/// ServiceGridRow(
///   items: [
///     SvcItem(icon: LucideIcons.piggy_bank, label: 'Savings\nAccount', color: Color(0xFF0EA5E9)),
///     SvcItem(icon: LucideIcons.briefcase, label: 'Current\nAccount', color: Color(0xFF6366F1)),
///   ],
/// )
/// ```
class ServiceGridRow extends StatelessWidget {
  final List<SvcItem> items;

  const ServiceGridRow({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        if (item.label.isEmpty) {
          return const Expanded(child: SizedBox()); // Filler
        }
        return Expanded(
          child: GestureDetector(
            onTap: item.onTap ?? () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: item.icon != null
                        ? SvgPicture.asset(
                            item.icon!,
                            colorFilter: item.iconColor != null
                                ? ColorFilter.mode(
                                    item.iconColor!,
                                    BlendMode.srcIn,
                                  )
                                : null,
                          )
                        : const SizedBox(),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
