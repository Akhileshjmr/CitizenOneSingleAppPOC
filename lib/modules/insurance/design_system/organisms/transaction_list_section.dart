// =============================================================================
// TransactionListSection  —  ORGANISM
// -----------------------------------------------------------------------------
// Self-contained list section with header, list, empty state and loading
// state. Accepts a generic list of [TransactionDisplay] view-models so the
// organism stays decoupled from any feature entity.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/extensions/build_context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../atoms/atoms.dart';

/// View-model presented by the section. Feature code is responsible for
/// mapping its domain entity into this shape — this keeps the design
/// system zero-coupled to the bank's transaction model.
class TransactionDisplay {
  const TransactionDisplay({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amountLabel,
    required this.dateLabel,
    required this.icon,
    required this.isCredit,
  });
  final String id;
  final String title;
  final String subtitle;
  final String amountLabel;
  final String dateLabel;
  final IconData icon;
  final bool isCredit;
}

class TransactionListSection extends StatelessWidget {
  const TransactionListSection({
    super.key,
    required this.title,
    required this.transactions,
    this.isLoading = false,
    this.onSeeAll,
    this.onItemTap,
    this.emptyText = 'No transactions yet',
  });

  final String title;
  final List<TransactionDisplay> transactions;
  final bool isLoading;
  final VoidCallback? onSeeAll;
  final ValueChanged<TransactionDisplay>? onItemTap;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: AppText(title, variant: AppTextVariant.subtitle),
            ),
            if (onSeeAll != null)
              AppButton(
                label: 'See all',
                onPressed: onSeeAll,
                variant: AppButtonVariant.text,
                size: AppButtonSize.sm,
              ),
          ],
        ),
        const AppSpacer.sm(),
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: _buildBody(context),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    if (isLoading) return const _SkeletonList();
    if (transactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: Column(
            children: [
              AppIcon(Icons.inbox_outlined,
                  size: AppIconSize.xl,
                  color: context.colors.textDisabled),
              const AppSpacer.sm(),
              AppText.caption(emptyText),
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (_, __) =>
          const AppDivider(indent: AppSpacing.lg, endIndent: AppSpacing.lg),
      itemBuilder: (_, i) => _TransactionRow(
        item: transactions[i],
        onTap: onItemTap == null ? null : () => onItemTap!(transactions[i]),
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.item, this.onTap});
  final TransactionDisplay item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tone = item.isCredit ? c.success : c.textPrimary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: c.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: AppIcon(item.icon, color: c.textSecondary),
            ),
            const AppSpacer.md(axis: Axis.horizontal),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(item.title,
                      variant: AppTextVariant.bodyStrong, maxLines: 1),
                  const AppSpacer.xs(),
                  AppText.caption(item.subtitle, maxLines: 1),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  '${item.isCredit ? '+' : '-'} ${item.amountLabel}',
                  variant: AppTextVariant.bodyStrong,
                  color: tone,
                ),
                const AppSpacer.xs(),
                AppText.caption(item.dateLabel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonList extends StatelessWidget {
  const _SkeletonList();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (_) => const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              _SkeletonBox(width: 40, height: 40, radius: AppSpacing.radiusMd),
              AppSpacer.md(axis: Axis.horizontal),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(
                        width: double.infinity, height: 12, radius: 6),
                    AppSpacer.sm(),
                    _SkeletonBox(width: 120, height: 10, radius: 5),
                  ],
                ),
              ),
              AppSpacer.md(axis: Axis.horizontal),
              _SkeletonBox(width: 60, height: 14, radius: 7),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox(
      {required this.width, required this.height, required this.radius});
  final double width;
  final double height;
  final double radius;
  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: context.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}
