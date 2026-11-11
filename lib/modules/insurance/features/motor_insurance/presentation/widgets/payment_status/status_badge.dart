// =============================================================================
// StatusBadge — small pill used inside ProcessStepCard to show a step's
// current ProcessStepStatus. Animates color/label changes so a card that
// flips from "In progress" -> "Successful" (or "Failed") reads as a state
// transition rather than an abrupt UI swap.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/process_step_status.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final ProcessStepStatus status;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.badgeBackground,
        borderRadius: BorderRadius.circular(999),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: AppText(
          status.badgeLabel,
          key: ValueKey(status),
          style: AppTextStyle.labelSmall,
          fontWeight: FontWeight.w600,
          color: status.text,
        ),
      ),
    );
  }
}
