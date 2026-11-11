import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/responsive_widgets.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_spacing.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_bar.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_button.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/payment_flow_details.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/process_step_card.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/process_step_status.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/result_hero.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/summary_card.dart';

import '../../../../core/theme/tokens/assets.dart';

/// Shown when payment succeeded but the follow-up policy-issuance call
/// failed (`state.paymentSuccessEntity != null` while
/// `instantIssueStatus == error`). Payment is never retried from here — the
/// amount has already been charged — the only action is "Back to Home".
class PolicyIssuanceFailedPage extends StatelessWidget {
  const PolicyIssuanceFailedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.go('/');
      },
      child: BlocBuilder<MotorInsuranceBloc, MotorInsuranceState>(
        buildWhen: (previous, current) => false,
        builder: (context, state) {
          PaymentFlowDetails details;
          try {
            details = PaymentFlowDetails.from(state);
          } catch (_) {
            details = const PaymentFlowDetails.empty();
          }
          return context.isMobile
              ? _buildMobile(context, details)
              : _buildDesktop(context, details);
        },
      ),
    );
  }

  Widget _buildMobile(BuildContext context, PaymentFlowDetails details) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar:
          const AppStatusBar(title: 'Policy Issuance Failed', showBack: false),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: AppButton(
            height: 48,
            text: 'Back to Home',
            onPressed: () => context.go('/'),
            variant: AppButtonVariant.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const ResultHero(
              tone: ResultTone.warning,
              icon: Icons.priority_high,
              heading: 'Policy Issuance Failed',
              subtitle:
                  "Your payment was successful but we couldn't issue your policy at this time.",
            ),
            const SizedBox(height: 20),
            _safetyBanner(),
            const SizedBox(height: 20),
            _processStatusCard(details),
            const SizedBox(height: 20),
            _transactionDetails(details,
                useMobileLabels: true, decorated: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context, PaymentFlowDetails details) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
        child: ResponsiveContainer(
          maxWidth: 760,
          child: Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const ResultHero(
                  tone: ResultTone.warning,
                  icon: Icons.priority_high,
                  heading: 'Policy Issuance Failed',
                  subtitle:
                      "We couldn't complete your payment.  Please try again.",
                  banner: true,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
                  child: Column(
                    children: [
                      _safetyBanner(),
                      const SizedBox(height: 20),
                      _processStatusCard(details),
                      const SizedBox(height: 20),
                      _transactionDetails(details,
                          useMobileLabels: false, decorated: false),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 220,
                          child: AppButton(
                            text: 'Back to Home',
                            variant: AppButtonVariant.primary,
                            onPressed: () => context.go('/'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _safetyBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warningFlowBg,
        border: Border.all(color: AppColors.warningFlowBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.shield_check,
              size: 20, color: AppColors.warningFlowPrimary),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Your payment is safe.',
                  style: AppTextStyle.bodyMedium,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                SizedBox(height: 4),
                AppText(
                  'Our team is automatically retrying policy issuance. You will '
                  'receive your policy shortly once completed.',
                  style: AppTextStyle.bodySmall,
                  color: AppColors.warningFlowText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _processStatusCard(PaymentFlowDetails details) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Process Status',
            style: AppTextStyle.bodyLarge,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          SizedBox(height: 16),
          ProcessStepCard(
            stepNumber: 1,
            iconName: AppAssets.iconReviewCreditCard,
            title: 'Payment Processing',
            status: ProcessStepStatus.successful,
            filled: false,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, thickness: 1, color: AppColors.border),
          ),
          ProcessStepCard(
            stepNumber: 2,
            iconName: AppAssets.iconPrivacyPolicy,
            title: 'Policy Issuance',
            status: ProcessStepStatus.failed,
            description: 'Unable to issue policy due to a technical issue.',
            filled: false,
          ),
        ],
      ),
    );
  }

  Widget _transactionDetails(
    PaymentFlowDetails details, {
    required bool useMobileLabels,
    required bool decorated,
  }) {
    final rows = <SummaryRow>[];
    if (details.referenceNumber != null) {
      rows.add(SummaryRow('Reference Number', details.referenceNumber!));
    }
    if (details.hostRefNumber != null) {
      rows.add(SummaryRow('Host Reference Number', details.hostRefNumber!));
    }
    if (details.selectedPaymentMethod != null) {
      rows.add(SummaryRow('Payment Method', details.selectedPaymentMethod!));
    }
    if (details.premiumAmount != null) {
      rows.add(SummaryRow(useMobileLabels ? 'Premium Amount' : 'Payment Amount',
          details.premiumAmount!));
    }
    if (details.convenienceFee != null) {
      rows.add(SummaryRow('Transaction Fee', details.convenienceFee!));
    }

    return SummaryCard(
      title: 'Transaction details',
      rows: rows,
      totalValue: details.totalAmount,
      decorated: decorated,
    );
  }
}
