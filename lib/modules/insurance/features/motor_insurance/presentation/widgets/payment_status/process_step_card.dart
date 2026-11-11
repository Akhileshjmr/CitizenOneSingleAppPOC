// =============================================================================
// ProcessStepCard — reusable "Payment Processing" / "Policy Issuance" step
// used by:
//   - TransactionProcessingPage (filled=true): a standalone colored/bordered
//     card per step, with a bulleted description and — while active — an
//     inline loader strip.
//   - MotorInsuranceErrorPage / PolicyIssuanceFailedPage (filled=false): a
//     plain row (no border/background of its own) meant to be placed inside
//     a single shared neutral "Process Status" card, with a single-line
//     description instead of bullets.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/process_step_status.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/status_badge.dart';

import '../../../../../core/config/app_config.dart';
import '../../../../../core/theme/tokens/assets.dart';

class ProcessStepCard extends StatelessWidget {
  const ProcessStepCard({
    super.key,
    required this.stepNumber,
    required this.iconName,
    required this.title,
    required this.status,
    this.bulletLines,
    this.description,
    this.loadingLabel,
    this.filled = true,
  });

  final int stepNumber;
  final String iconName;
  final String title;
  final ProcessStepStatus status;

  /// Bulleted description lines (Transaction/Policy Processing screen).
  final List<String>? bulletLines;

  /// Single-line description (result screens). Ignored when [bulletLines]
  /// is provided.
  final String? description;

  /// Inline "Processing Payment……" strip label — shown only while
  /// [status] is [ProcessStepStatus.inProgress].
  final String? loadingLabel;

  /// Whether this card draws its own colored/bordered container. Set to
  /// false when embedding inside a shared neutral wrapper card.
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _IconCircle(iconName: iconName, status: status),
            const SizedBox(width: 14),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppText(
                      '$stepNumber. $title',
                      style: AppTextStyle.bodyLarge,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  StatusBadge(status: status),
                ],
              ),
            ),
          ],
        ),
        if (bulletLines != null) ...[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 54),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final line in bulletLines!)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: AppText(
                      '•  $line',
                      style: AppTextStyle.bodySmall,
                      color: AppColors.serviceHeaderTitle,
                    ),
                  ),
              ],
            ),
          ),
        ] else if (description != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 54),
            child: AppText(
              description!,
              style: AppTextStyle.bodySmall,
              color: AppColors.serviceHeaderTitle,
            ),
          ),
        ],
        if (status.isActive && loadingLabel != null) ...[
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.only(left: 54),
            child: _LoaderStrip(label: loadingLabel!, status: status),
          ),
        ],
      ],
    );

    if (!filled) return content;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: status.background,
        border: Border.all(color: status.border, width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: content,
    );
  }
}

class _IconCircle extends StatelessWidget {
  const _IconCircle({required this.iconName, required this.status});

  final String iconName;
  final ProcessStepStatus status;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: status.iconCircle,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(package: AppConfig.packageName, iconName),
    );
  }
}

class _LoaderStrip extends StatefulWidget {
  const _LoaderStrip({required this.label, required this.status});

  final String label;
  final ProcessStepStatus status;

  @override
  State<_LoaderStrip> createState() => _LoaderStripState();
}

class _LoaderStripState extends State<_LoaderStrip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: widget.status.badgeBackground,
        border: Border.all(color: widget.status.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          RotationTransition(
            turns: _controller,
            child: SvgPicture.asset(
                package: AppConfig.packageName, AppAssets.iconLoader),
          ),
          const SizedBox(width: 10),
          AppText(
            widget.label,
            style: AppTextStyle.bodySmall,
            fontWeight: FontWeight.w600,
            color: widget.status.text,
          ),
        ],
      ),
    );
  }
}
