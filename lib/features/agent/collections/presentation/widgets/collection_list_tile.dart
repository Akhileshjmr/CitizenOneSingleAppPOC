import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/features/agent/collections/domain/entities/agent_collection_entity.dart';
import 'package:citizenone_app/features/agent/collections/presentation/state/agent_collections_cubit.dart';

class CollectionListTile extends StatelessWidget {
  final AgentCollectionEntity collection;

  const CollectionListTile({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final isCollected = collection.status == CollectionStatus.collected;
    final isOverdue = collection.status == CollectionStatus.overdue;

    final (statusLabel, statusBg, statusFg) = switch (collection.status) {
      CollectionStatus.pending => ('Due Today', const Color(0xFFFEF3C7), const Color(0xFFD97706)),
      CollectionStatus.overdue => ('Overdue', const Color(0xFFFEE2E2), const Color(0xFFDC2626)),
      CollectionStatus.collected => ('Collected', const Color(0xFFDCFCE7), const Color(0xFF059669)),
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOverdue ? const Color(0xFFDC2626).withValues(alpha: 0.2) : tokens.outline,
          width: isOverdue ? 1.5 : 1,
        ),
        boxShadow: tokens.shadowSm,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isOverdue ? const Color(0xFFFEE2E2) : const Color(0xFFE0E7FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    LucideIcons.wallet,
                    size: 20,
                    color: isOverdue ? const Color(0xFFDC2626) : const Color(0xFF4F46E5),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppText(
                              collection.merchantName,
                              style: AppTextStyle.bodyMedium,
                              fontWeight: FontWeight.w700,
                              color: tokens.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: AppText(
                              statusLabel,
                              style: AppTextStyle.labelSmall,
                              fontWeight: FontWeight.w700,
                              color: statusFg,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        collection.amountDue,
                        style: AppTextStyle.displaySmall,
                        fontWeight: FontWeight.w800,
                        color: isOverdue ? const Color(0xFFDC2626) : tokens.textPrimary,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(LucideIcons.map_pin, size: 12, color: tokens.textMuted),
                          const SizedBox(width: 4),
                          Expanded(
                            child: AppText(
                              collection.location,
                              style: AppTextStyle.caption,
                              color: tokens.textMuted,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (collection.lastCollectedDate != null) ...[
                            const SizedBox(width: 8),
                            Icon(LucideIcons.clock, size: 12, color: tokens.textMuted),
                            const SizedBox(width: 4),
                            AppText(
                              'Last: ${collection.lastCollectedDate}',
                              style: AppTextStyle.caption,
                              color: tokens.textMuted,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isCollected)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: AppButton(
                text: 'Mark as Collected',
                onPressed: () => context.read<AgentCollectionsCubit>().markCollected(collection.id),
                backgroundColor: isOverdue ? const Color(0xFFDC2626) : const Color(0xFF4F46E5),
                icon: LucideIcons.check,
                height: 42,
              ),
            ),
        ],
      ),
    );
  }
}
