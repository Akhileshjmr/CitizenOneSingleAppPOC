// =============================================================================
// ProcessStepStatus — shared status vocabulary for the payment-flow process
// cards (Payment Processing / Policy Issuance) used across the Transaction/
// Policy Processing screen and the Payment Failed / Policy Issuance Failed
// result screens.
// -----------------------------------------------------------------------------
// `pending` and `notStarted` share the same gray visual style but carry
// different badge copy: `pending` is used mid-flow ("this step will run
// shortly"), `notStarted` is used on the terminal Payment Failed screen for
// the policy card ("this step will never run because payment failed").
// =============================================================================

import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';

enum ProcessStepStatus { pending, inProgress, successful, failed, notStarted }

extension ProcessStepStatusStyle on ProcessStepStatus {
  String get badgeLabel => switch (this) {
        ProcessStepStatus.pending => 'Pending',
        ProcessStepStatus.inProgress => 'In progress',
        ProcessStepStatus.successful => 'Successful',
        ProcessStepStatus.failed => 'Failed',
        ProcessStepStatus.notStarted => 'Not Started',
      };

  Color get background => switch (this) {
        ProcessStepStatus.pending ||
        ProcessStepStatus.notStarted =>
          AppColors.pendingFlowBg,
        ProcessStepStatus.inProgress => AppColors.processingBg,
        ProcessStepStatus.successful => AppColors.successFlowBg,
        ProcessStepStatus.failed => AppColors.failureFlowBg,
      };

  Color get border => switch (this) {
        ProcessStepStatus.pending ||
        ProcessStepStatus.notStarted =>
          AppColors.pendingFlowBorder,
        ProcessStepStatus.inProgress => AppColors.processingBorder,
        ProcessStepStatus.successful => AppColors.successFlowBorder,
        ProcessStepStatus.failed => AppColors.failureFlowBorder,
      };

  Color get primary => switch (this) {
        ProcessStepStatus.pending ||
        ProcessStepStatus.notStarted =>
          AppColors.pendingFlowPrimary,
        ProcessStepStatus.inProgress => AppColors.processingText,
        ProcessStepStatus.successful => AppColors.successFlowPrimary,
        ProcessStepStatus.failed => AppColors.failureFlowPrimary,
      };

  Color get text => switch (this) {
        ProcessStepStatus.pending ||
        ProcessStepStatus.notStarted =>
          AppColors.textPrimary,
        ProcessStepStatus.inProgress => AppColors.processingText,
        ProcessStepStatus.successful => AppColors.successFlowText,
        ProcessStepStatus.failed => AppColors.failureFlowText,
      };

  Color get badgeBackground => switch (this) {
        ProcessStepStatus.pending ||
        ProcessStepStatus.notStarted =>
          AppColors.pendingFlowBg,
        ProcessStepStatus.inProgress => AppColors.processingBadgeBg,
        ProcessStepStatus.successful => AppColors.successFlowBadgeBg,
        ProcessStepStatus.failed => AppColors.failureFlowBadgeBg,
      };

  bool get isActive => this == ProcessStepStatus.inProgress;

  /// Solid fill for the round step-icon avatar — sampled from the design
  /// reference; deliberately darker/richer than [background]/[border].
  Color get iconCircle => switch (this) {
        ProcessStepStatus.pending ||
        ProcessStepStatus.notStarted =>
          AppColors.pendingFlowPrimary,
        ProcessStepStatus.inProgress => AppColors.iconCircleProcessing,
        ProcessStepStatus.successful => AppColors.iconCircleSuccess,
        ProcessStepStatus.failed => AppColors.iconCircleFailed,
      };
}

/// Tone used by [ResultHero] for the top hero section of a result screen.
enum ResultTone { success, failure, warning }

extension ResultToneStyle on ResultTone {
  Color get bg => switch (this) {
        ResultTone.success => AppColors.successFlowBg,
        ResultTone.failure => AppColors.failureFlowBg,
        ResultTone.warning => AppColors.warningFlowBg,
      };

  Color get primary => switch (this) {
        ResultTone.success => AppColors.successFlowPrimary,
        ResultTone.failure => AppColors.failureFlowPrimary,
        ResultTone.warning => AppColors.warningFlowPrimary,
      };
}
