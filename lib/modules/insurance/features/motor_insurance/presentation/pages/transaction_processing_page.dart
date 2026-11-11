// =============================================================================
// TransactionProcessingPage — full-screen replacement for the old
// AppLoadingDialog spinner. Renders both the "Transaction Processing" and
// "Policy Processing" design states from a single screen: the two process
// cards (Payment Processing / Policy Issuance) update in place as
// MotorInsuranceBloc moves through ProcessInsurancePayment ->
// IssuePolicyBuQuoteIDEvent. No bloc/business-logic changes — this page only
// derives UI state from existing fields (instantIssueStatus,
// paymentSuccessEntity, isProcessing) and reacts to the same terminal states
// the old dialog-based flow did.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/responsive_widgets.dart';
import 'package:citizenone_app/modules/insurance/core/constants/routes_constants.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_bar.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/process_step_card.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/process_step_status.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/progress_ring_loader.dart';

import '../../../../core/theme/tokens/assets.dart';

class _StepStatuses {
  const _StepStatuses(this.payment, this.policy);
  final ProcessStepStatus payment;
  final ProcessStepStatus policy;
}

_StepStatuses _deriveStatuses(MotorInsuranceState state) {
  if (state.instantIssueStatus == InstantIssueStatus.loaded) {
    return const _StepStatuses(
        ProcessStepStatus.successful, ProcessStepStatus.successful);
  }
  if (state.instantIssueStatus == InstantIssueStatus.error) {
    return state.paymentSuccessEntity == null
        ? const _StepStatuses(
            ProcessStepStatus.failed, ProcessStepStatus.notStarted)
        : const _StepStatuses(
            ProcessStepStatus.successful, ProcessStepStatus.failed);
  }
  return state.paymentSuccessEntity == null
      ? const _StepStatuses(
          ProcessStepStatus.inProgress, ProcessStepStatus.pending)
      : const _StepStatuses(
          ProcessStepStatus.successful, ProcessStepStatus.inProgress);
}

class TransactionProcessingPage extends StatelessWidget {
  const TransactionProcessingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocConsumer<MotorInsuranceBloc, MotorInsuranceState>(
        listenWhen: (previous, current) =>
            previous.instantIssueStatus != current.instantIssueStatus,
        listener: (context, state) {
          if (state.instantIssueStatus == InstantIssueStatus.loaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                context.pushReplacement(AppRoutes.policyConfirmedPage);
              }
            });
          } else if (state.instantIssueStatus == InstantIssueStatus.error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              context.pushReplacement(state.paymentSuccessEntity == null
                  ? AppRoutes.motorInsuranceErrorPage
                  : AppRoutes.policyIssuanceFailedPage);
            });
          }
        },
        builder: (context, state) {
          final statuses = _deriveStatuses(state);
          return context.isMobile
              ? _buildMobile(context, statuses)
              : _buildDesktop(context, statuses);
        },
      ),
    );
  }

  Widget _buildMobile(BuildContext context, _StepStatuses statuses) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppStatusBar(
        title: 'Transaction Processing',
        showBack: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _ProcessingBody(statuses: statuses),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context, _StepStatuses statuses) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 48, 32, 48),
        child: ResponsiveContainer(
          maxWidth: 760,
          child: _ProcessingBody(statuses: statuses),
        ),
      ),
    );
  }
}

class _ProcessingBody extends StatelessWidget {
  const _ProcessingBody({required this.statuses});

  final _StepStatuses statuses;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ProgressRingLoader(),
        const SizedBox(height: 24),
        const AppText(
          'Please wait while we process your request',
          style: AppTextStyle.headlineLarge,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: 8),
        const AppText(
          'We are securely processing your payment and issuing your insurance policy.',
          style: AppTextStyle.bodyLarge,
          textAlign: TextAlign.center,
          color: AppColors.serviceHeaderTitle,
        ),
        const SizedBox(height: 32),
        ProcessStepCard(
          stepNumber: 1,
          iconName: AppAssets.iconReviewCreditCard,
          title: 'Payment Processing',
          status: statuses.payment,
          bulletLines: const [
            'Contacting payment gateway',
            'Validating transaction',
            'Awaiting payment confirmation',
          ],
          loadingLabel: 'Processing Payment......',
        ),
        SizedBox(
          height: 24,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 39),
              child: Container(
                width: 2,
                height: 24,
                color: AppColors.textBorder,
              ),
            ),
          ),
        ),
        ProcessStepCard(
          stepNumber: 2,
          iconName: AppAssets.iconPrivacyPolicy,
          title: 'Policy Issuance',
          status: statuses.policy,
          bulletLines: const [
            'Creating policy with insurer',
            'Generating policy number',
            'Preparing policy documents',
          ],
          loadingLabel: 'Policy Issuance......',
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child:
                    const Icon(LucideIcons.info, size: 13, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: AppText(
                  'This process usually takes less than two minutes.',
                  style: AppTextStyle.bodySmall,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
