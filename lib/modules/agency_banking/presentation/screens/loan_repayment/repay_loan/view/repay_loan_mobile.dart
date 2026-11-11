import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/form/app_button.dart';
import '../../../../../core/widgets/form/app_text.dart';
import '../../../../../core/widgets/form/app_text_field.dart';
import '../../../../../theme/app_theme_style.dart';
import '../../../../../theme/colors/Appcolors.dart';
import '../../review/view/review_screen.dart';
import '../bloc/repay_loan_bloc.dart';
import '../bloc/repay_loan_event.dart';
import '../bloc/repay_loan_state.dart';
import '../widgets/loan_repayment_details.dart';
import '../widgets/repay_loan_pieces.dart';

/// Mobile layout for "Repay Loan" — matches the reference screenshot:
/// back arrow + "Repay Loan" header, loan summary card (2x2 detail
/// grid), "Select Repayment Amount" section with two radio-style option
/// cards, and a full-width "Next" button pinned to the bottom of the
/// screen (not scrolling away with the content above it).
class RepayLoanMobileLayout extends StatelessWidget {
  final RepayLoanBloc controller;
  final VoidCallback onBack;
  final void Function(double amount) onProceed;

  const RepayLoanMobileLayout({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
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
              children: [
                _Header(onBack: onBack),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          selected:
                              state.selectedOption == AmountOption.totalDue,
                          title: 'Pay Total Due Amount',
                          subtitle: 'Clear your Total due Amount',
                          trailingText: '${controller.details.currencySymbol} '
                              '${formatAmount(controller.details.totalAmountDue)}',
                          onTap: () => controller.add(
                              const AmountOptionSelected(
                                  AmountOption.totalDue)),
                        ),
                        const SizedBox(height: 12),
                        RepaymentOptionCard(
                          selected: state.selectedOption == AmountOption.other,
                          title: 'Other Amount',
                          onTap: () => controller.add(
                              const AmountOptionSelected(AmountOption.other)),
                          child: AppTextField(
                            hintText: 'Enter Amount',
                            controller: controller.amountController,
                            focusNode: controller.amountFocus,
                            inputType: const TextInputType.numberWithOptions(
                                decimal: true),
                            isFocus: true,
                            isValid: state.errorText == null,
                            errorText: state.errorText,
                            height: 44,
                            label: '',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: AppButton(
                    title: 'Next',
                    fullWidth: true,
                    enabledColor: AppColors.primaryPurple,
                    onPressed:
                        () /*() => controller.add(const PaySubmitted()),*/ {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReviewScreen(
                            accountNumber: 'L-123456789',
                            customerName: 'John Doe',
                            paymentAmountFormatted: 'ZK 14,500',
                            onSubmit: () async {
                              return {'txnId': 'TXN123'};
                            },
                            onSubmitted: (response) {
                              print('Submitted: $response');
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;

  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardBg,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
            onPressed: onBack,
          ),
          const SizedBox(width: 4),
          AppText('Repay Loan',
              style: AppThemeStyle.headerTitle, padding: EdgeInsets.zero),
        ],
      ),
    );
  }
}
