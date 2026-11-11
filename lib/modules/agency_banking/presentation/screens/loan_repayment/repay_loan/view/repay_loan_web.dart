import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/form/app_button.dart';
import '../../../../../core/widgets/form/app_text.dart';
import '../../../../../core/widgets/form/app_text_field.dart';
import '../../../../../theme/app_theme_style.dart';
import '../../../../../theme/colors/Appcolors.dart';
import '../bloc/repay_loan_bloc.dart';
import '../bloc/repay_loan_event.dart';
import '../bloc/repay_loan_state.dart';
import '../widgets/loan_repayment_details.dart';
import '../widgets/repay_loan_pieces.dart';

/// Web / desktop / tablet / landscape-phone layout for "Repay Loan".
/// Same three-tier responsive scheme as the other web layouts in this
/// app — a landscape phone (~600-900px) gets its own compact tier, not
/// a shrunken desktop one.
class RepayLoanWebLayout extends StatelessWidget {
  final RepayLoanBloc controller;
  final VoidCallback onBack;
  final void Function(double amount) onProceed;

  const RepayLoanWebLayout({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          _WebHeader(onBack: onBack),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final bool showBrandingPanel = constraints.maxWidth >= 1100;
                final double formMaxWidth = constraints.maxWidth >= 1100
                    ? 480
                    : constraints.maxWidth >= 700
                        ? 560
                        : double.infinity;

                final form = _FormColumn(
                  controller: controller,
                  onProceed: onProceed,
                  maxWidth: formMaxWidth,
                );

                if (!showBrandingPanel) {
                  return Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth >= 700 ? 24 : 16,
                        vertical: 32,
                      ),
                      child: form,
                    ),
                  );
                }

                return Row(
                  children: [
                    const Expanded(flex: 5, child: _BrandingPanel()),
                    Expanded(
                      flex: 6,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 48),
                        child: Center(child: form),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WebHeader extends StatelessWidget {
  final VoidCallback onBack;
  const _WebHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBg,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
            onPressed: onBack,
          ),
          const SizedBox(width: 8),
          AppText('Repay Loan',
              style: AppThemeStyle.headerTitle, padding: EdgeInsets.zero),
        ],
      ),
    );
  }
}

class _BrandingPanel extends StatelessWidget {
  const _BrandingPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      color: const Color(0xFFEFF1F8),
      padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryPurple,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.payments_outlined,
                color: Colors.white, size: 28),
          ),
          const SizedBox(height: 28),
          AppText(
            'Clear your balance\nin a few taps',
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText,
            lineHeight: 1.3,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),
          AppText(
            'Review your outstanding balance, choose how much to pay, and confirm securely.',
            fontSize: 15,
            color: AppColors.secondaryText,
            lineHeight: 1.5,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class _FormColumn extends StatelessWidget {
  final RepayLoanBloc controller;
  final void Function(double amount) onProceed;
  final double maxWidth;

  const _FormColumn({
    required this.controller,
    required this.onProceed,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: BlocConsumer<RepayLoanBloc, RepayLoanState>(
        bloc: controller,
        listenWhen: (previous, current) =>
            previous.status != RepayLoanStatus.validated &&
            current.status == RepayLoanStatus.validated,
        listener: (context, state) {
          if (state.validatedAmount != null) {
            onProceed(state.validatedAmount!);
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              LoanSummaryCard(details: controller.details),
              const SizedBox(height: 22),
              AppText('Select Repayment Amount',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText,
                  padding: EdgeInsets.zero),
              const SizedBox(height: 12),
              RepaymentOptionCard(
                selected: state.selectedOption == AmountOption.totalDue,
                title: 'Pay Total Due Amount',
                subtitle: 'Clear your Total due Amount',
                trailingText: '${controller.details.currencySymbol} '
                    '${formatAmount(controller.details.totalAmountDue)}',
                onTap: () => controller
                    .add(const AmountOptionSelected(AmountOption.totalDue)),
              ),
              const SizedBox(height: 12),
              RepaymentOptionCard(
                selected: state.selectedOption == AmountOption.other,
                title: 'Other Amount',
                onTap: () => controller
                    .add(const AmountOptionSelected(AmountOption.other)),
                child: AppTextField(
                  hintText: 'Enter Amount',
                  controller: controller.amountController,
                  focusNode: controller.amountFocus,
                  inputType:
                      const TextInputType.numberWithOptions(decimal: true),
                  isFocus: true,
                  isValid: state.errorText == null,
                  errorText: state.errorText,
                  height: 44,
                  label: '',
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                title: 'Next',
                fullWidth: true,
                enabledColor: AppColors.primaryPurple,
                onPressed: () => controller.add(const PaySubmitted()),
              ),
            ],
          );
        },
      ),
    );
  }
}
