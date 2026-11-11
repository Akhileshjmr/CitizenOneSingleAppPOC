// =============================================================================
// DesktopStepper — desktop-only 7-step header for the Buy Policy journey.
// -----------------------------------------------------------------------------
// Independent of the mobile `CustomStepper` (custom_stepper.dart), which is
// left completely untouched. This widget mirrors the desktop SVG reference:
// a back chevron followed by 7 numbered/connected steps (Coverage, Customer
// Details, Vehicle Info, Policy Details, Quote Comparison,
// Insurance Details & Purchase, Success).
//
// `currentStep` is 1-indexed (1..7) to match the SVG's on-screen numbering.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';

class DesktopStepper extends StatelessWidget {
  const DesktopStepper({
    super.key,
    required this.currentStep,
    this.onBack,
  });

  final int currentStep;
  final VoidCallback? onBack;

  static const List<String> steps = [
    'Coverage',
    'Customer Details',
    'Vehicle Info',
    'Policy Details',
    'Quote Comparison',
    'Insurance Details & Purchase',
    'Success',
  ];

  @override
  Widget build(BuildContext context) {
    // The 7 full-text labels only fit unscrolled on wide desktop viewports.
    // On tablet, fall back to a horizontally-scrollable row with fixed-width
    // connectors (same shape as the mobile CustomStepper) instead of
    // Expanded connectors, which would overflow the viewport.
    final isDesktop = AdaptiveLayout.isDesktop(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onBack ?? () => context.pop(),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.chevron_left, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: isDesktop
                ? _StepRow(currentStep: currentStep, scrollable: false)
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _StepRow(currentStep: currentStep, scrollable: true),
                  ),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.currentStep, required this.scrollable});

  final int currentStep;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    const steps = DesktopStepper.steps;
    return Row(
      mainAxisSize: scrollable ? MainAxisSize.min : MainAxisSize.max,
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          final segmentStep = index ~/ 2;
          final isCompletedConnector = segmentStep < currentStep - 1;
          final connector = Container(
            height: 2,
            width: scrollable ? 32 : null,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: isCompletedConnector ? AppColors.primary : AppColors.outline,
          );
          return scrollable ? connector : Expanded(child: connector);
        }

        final stepIndex = index ~/ 2;
        final stepNumber = stepIndex + 1;
        final isActive = stepNumber == currentStep;
        final isCompleted = stepNumber < currentStep;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.k3C9718
                    : isActive
                        ? AppColors.primary
                        : AppColors.surfaceLight,
              ),
              child: AppText(
                '$stepNumber',
                style: AppTextStyle.labelSmall,
                color: (isActive || isCompleted)
                    ? Colors.white
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: scrollable ? 84 : null,
              child: AppText(
                steps[stepIndex],
                style: AppTextStyle.caption,
                color: isActive || isCompleted
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight:
                    isActive || isCompleted ? FontWeight.w700 : FontWeight.w500,
                textAlign: scrollable ? TextAlign.center : null,
                maxLines: scrollable ? 2 : 1,
                overflow: scrollable ? TextOverflow.ellipsis : null,
              ),
            ),
          ],
        );
      }),
    );
  }
}
