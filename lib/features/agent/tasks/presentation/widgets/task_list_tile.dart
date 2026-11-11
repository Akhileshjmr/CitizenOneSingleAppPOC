import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/features/agent/tasks/domain/entities/agent_task_detail_entity.dart';

class TaskListTile extends StatelessWidget {
  final AgentTaskDetailEntity task;

  const TaskListTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final typeIcon = _iconForType(task.type);
    final typeColor = _colorForType(task.type);
    final statusChip = _statusChip(task.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.outline),
        boxShadow: tokens.shadowSm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(typeIcon, size: 20, color: typeColor),
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
                        task.title,
                        style: AppTextStyle.bodyMedium,
                        fontWeight: FontWeight.w700,
                        color: tokens.textPrimary,
                      ),
                    ),
                    statusChip,
                  ],
                ),
                const SizedBox(height: 4),
                AppText(
                  task.customerName,
                  style: AppTextStyle.bodySmall,
                  fontWeight: FontWeight.w600,
                  color: typeColor,
                ),
                const SizedBox(height: 4),
                AppText(
                  task.description,
                  style: AppTextStyle.bodySmall,
                  color: tokens.textSecondary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(LucideIcons.clock, size: 12, color: tokens.textMuted),
                    const SizedBox(width: 4),
                    AppText(task.dueDate, style: AppTextStyle.caption, color: tokens.textMuted),
                    if (task.location != null) ...[
                      const SizedBox(width: 12),
                      Icon(LucideIcons.map_pin, size: 12, color: tokens.textMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: AppText(
                          task.location!,
                          style: AppTextStyle.caption,
                          color: tokens.textMuted,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    if (task.amount != null) ...[
                      const SizedBox(width: 12),
                      AppText(
                        task.amount!,
                        style: AppTextStyle.bodySmall,
                        fontWeight: FontWeight.w700,
                        color: tokens.textPrimary,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(AgentTaskType type) {
    switch (type) {
      case AgentTaskType.onboarding:
        return LucideIcons.user_plus;
      case AgentTaskType.collection:
        return LucideIcons.wallet;
      case AgentTaskType.kyc:
        return LucideIcons.badge_check;
      case AgentTaskType.partnerVisit:
        return LucideIcons.building;
    }
  }

  Color _colorForType(AgentTaskType type) {
    switch (type) {
      case AgentTaskType.onboarding:
        return const Color(0xFF4F46E5);
      case AgentTaskType.collection:
        return const Color(0xFF059669);
      case AgentTaskType.kyc:
        return const Color(0xFFD97706);
      case AgentTaskType.partnerVisit:
        return const Color(0xFF2563EB);
    }
  }

  Widget _statusChip(AgentTaskStatus status) {
    final (label, bg, fg) = switch (status) {
      AgentTaskStatus.pending => ('Pending', const Color(0xFFFEF3C7), const Color(0xFFD97706)),
      AgentTaskStatus.inProgress => ('In Progress', const Color(0xFFE0E7FF), const Color(0xFF4F46E5)),
      AgentTaskStatus.completed => ('Done', const Color(0xFFDCFCE7), const Color(0xFF059669)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: AppText(label, style: AppTextStyle.labelSmall, fontWeight: FontWeight.w700, color: fg),
    );
  }
}
