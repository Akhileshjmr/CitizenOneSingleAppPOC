import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/responsive_widgets.dart';
import 'package:citizenone_app/modules/insurance/core/constants/routes_constants.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_spacing.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_bar.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_button.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/design_system/organisms/app_loading_dialog.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/payment_flow_details.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/process_step_card.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/process_step_status.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/result_hero.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/payment_status/summary_card.dart';

import '../../../../core/theme/tokens/assets.dart';

/// Default customer-facing message for this screen. Kept as a top-level
/// constant (rather than hard-coded in the widget) so other failure flows
/// can pass a different [MotorInsuranceErrorPage.message] while reusing the
/// same screen.
const String kPaymentFailureMessage =
    "We couldn't complete your payment. Please try again.";

/// Shown whenever a payment attempt fails outright — payment API failure,
/// timeout/exception, server error, or a "failed" status from the backend,
/// with `state.paymentSuccessEntity == null` (nothing was ever charged).
/// Policy issuance is never assumed complete on this screen, and it never
/// leads to the success screen on its own; it only leaves via retrying
/// payment or "Back to Home".
class MotorInsuranceErrorPage extends StatefulWidget {
  const MotorInsuranceErrorPage({
    super.key,
    this.message = kPaymentFailureMessage,
  });

  final String message;

  @override
  State<MotorInsuranceErrorPage> createState() =>
      _MotorInsuranceErrorPageState();
}

class _MotorInsuranceErrorPageState extends State<MotorInsuranceErrorPage> {
  bool _isLoaderShowing = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.go('/');
      },
      child: BlocConsumer<MotorInsuranceBloc, MotorInsuranceState>(
        listenWhen: (previous, current) =>
            previous.instantIssueStatus != current.instantIssueStatus ||
            previous.isProcessing != current.isProcessing,
        listener: (context, state) {
          if (state.isProcessing && !_isLoaderShowing) {
            _isLoaderShowing = true;
            AppLoadingDialog.show(context);
          } else if (!state.isProcessing && _isLoaderShowing) {
            _isLoaderShowing = false;
            AppLoadingDialog.hide(context);
          }
          // A retry ("Pay Now") that succeeds moves the flow forward to the
          // success screen — this page never marks the policy as issued
          // itself, it only reacts once the bloc says issuance is done.
          if (state.instantIssueStatus == InstantIssueStatus.loaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                context.pushReplacement(AppRoutes.policyConfirmedPage);
              }
            });
          }
        },
        builder: (context, state) {
          PaymentFlowDetails details;
          try {
            details = PaymentFlowDetails.from(state);
          } catch (_) {
            // Defensive fallback: never let a malformed/partial API response
            // (missing fields on createQuotationResponse) take down the
            // whole error screen — degrade to blank rows instead.
            details = const PaymentFlowDetails.empty();
          }
          return isMobile
              ? _buildMobile(context, details)
              : _buildDesktop(context, state, details);
        },
      ),
    );
  }

  // ── Mobile ────────────────────────────────────────────────────────────
  Widget _buildMobile(BuildContext context, PaymentFlowDetails details) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppStatusBar(
        title: 'Payment Failed',
        showBack: false,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (details.canRetryPayment) ...[
                AppButton(
                  height: 48,
                  text: 'Retry Payment',
                  onPressed: () => context.pop(),
                  variant: AppButtonVariant.primary,
                ),
                const SizedBox(height: 12),
              ],
              AppButton(
                height: 48,
                text: 'Back to Home',
                onPressed: () => context.go('/'),
                variant: AppButtonVariant.outline,
                borderColor: AppColors.primary,
                textColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ResultHero(
              tone: ResultTone.failure,
              icon: LucideIcons.x,
              heading: 'Payment Failed',
              subtitle: widget.message,
            ),
            const SizedBox(height: 24),
            _processStatusCard(details),
            if (details.reason != null) ...[
              const SizedBox(height: 20),
              _reasonBox(details.reason!),
            ],
            const SizedBox(height: 20),
            _transactionDetails(details, decorated: true),
          ],
        ),
      ),
    );
  }

  // ── Desktop / tablet ──────────────────────────────────────────────────
  Widget _buildDesktop(
    BuildContext context,
    MotorInsuranceState state,
    PaymentFlowDetails details,
  ) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 48, 32, 32),
        child: ResponsiveContainer(
          maxWidth: 760,
          child: _desktopCard(context, state, details),
        ),
      ),
    );
  }

  Widget _desktopCard(
    BuildContext context,
    MotorInsuranceState state,
    PaymentFlowDetails details,
  ) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: _cardDecoration(),
      child: Column(
        children: [
          ResultHero(
            tone: ResultTone.failure,
            icon: LucideIcons.x,
            heading: 'Payment Failed',
            subtitle: widget.message,
            banner: true,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
            child: Column(
              children: [
                _processStatusCard(details),
                if (details.reason != null) ...[
                  const SizedBox(height: 20),
                  _reasonBox(details.reason!),
                ],
                const SizedBox(height: 20),
                _transactionDetails(details, decorated: false),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Back to Home',
                        variant: AppButtonVariant.outline,
                        isFullWidth: true,
                        textColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        onPressed: () => context.go('/'),
                      ),
                    ),
                    if (details.canRetryPayment) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppButton(
                          text: 'Retry Payment',
                          variant: AppButtonVariant.primary,
                          isFullWidth: true,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          isLoading: state.isProcessing,
                          onPressed:
                              state.isProcessing ? null : () => context.pop(),
                        ),
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

  // ── Shared pieces ─────────────────────────────────────────────────────
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
            status: ProcessStepStatus.failed,
            description: 'Payment has been Failed.',
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
            status: ProcessStepStatus.notStarted,
            description: 'Policy will be issued after Successful payment.',
            filled: false,
          ),
        ],
      ),
    );
  }

  Widget _reasonBox(String reason) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Reason',
            style: AppTextStyle.bodyLarge,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: 8),
          AppText(
            reason,
            style: AppTextStyle.bodyMedium,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _transactionDetails(PaymentFlowDetails details,
      {required bool decorated}) {
    final rows = <SummaryRow>[];
    if (details.referenceNumber != null) {
      rows.add(SummaryRow('Reference Number', details.referenceNumber!));
    }
    if (details.referenceNumber != null) {
      rows.add(SummaryRow('Host Reference Number', details.hostRefNumber!));
    }
    if (details.coveragePeriod != null) {
      rows.add(SummaryRow('Coverage Period', details.coveragePeriod!));
    }
    if (details.vehicle != null) {
      rows.add(SummaryRow('Vehicle', details.vehicle!));
    }
    if (details.selectedPaymentMethod != null) {
      rows.add(SummaryRow('Payment Method', details.selectedPaymentMethod!));
    }
    if (details.premiumAmount != null) {
      rows.add(SummaryRow('Premium Amount', details.premiumAmount!));
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

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      );
}
