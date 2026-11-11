import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/form/app_button.dart';
import '../../../../../core/widgets/form/app_text.dart';
import '../../../../../theme/app_theme_style.dart';
import '../../../../../theme/colors/Appcolors.dart';
import '../bloc/review_bloc.dart';
import '../bloc/review_event.dart';
import '../bloc/review_state.dart';

/// Mobile layout for the Review screen — matches the reference
/// screenshot: back arrow + "Review" header, a card with three
/// label/value rows (Loan Account Number, Customer Name, Payment
/// Amount), and a full-width "Submit" button pinned to the bottom.
class ReviewMobileLayout extends StatelessWidget {
  final ReviewBloc controller;
  final VoidCallback onBack;
  final String accountNumber;
  final String customerName;
  final String paymentAmountFormatted; // e.g. "ZK 14,500"
  final Future<Map<String, dynamic>> Function() onSubmit;

  const ReviewMobileLayout({
    super.key,
    required this.controller,
    required this.onBack,
    required this.accountNumber,
    required this.customerName,
    required this.paymentAmountFormatted,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: BlocBuilder<ReviewBloc, ReviewState>(
          bloc: controller,
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
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius:
                                BorderRadius.circular(AppThemeStyle.cardRadius),
                          ),
                          child: Column(
                            children: [
                              _ReviewRow(
                                label: 'Loan Account Number',
                                value: accountNumber,
                              ),
                              const SizedBox(height: 14),
                              _ReviewRow(
                                label: 'Customer Name',
                                value: customerName,
                              ),
                              const SizedBox(height: 14),
                              _ReviewRow(
                                label: 'Payment Amount',
                                value: paymentAmountFormatted,
                              ),
                            ],
                          ),
                        ),
                        if (state.errorText != null) ...[
                          const SizedBox(height: 14),
                          AppText(
                            state.errorText!,
                            textAlign: TextAlign.center,
                            color: AppColors.appPrimaryRedColor,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: state.isSubmitting
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2.4),
                            ),
                          ),
                        )
                      : AppButton(
                          title: 'Submit',
                          fullWidth: true,
                          enabledColor: AppColors.primaryPurple,
                          onPressed: () => controller
                              .add(ReviewSubmitted(onSubmit: onSubmit)),
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

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;
  const _ReviewRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(label,
            fontSize: 12.5, color: AppColors.secondaryText, padding: EdgeInsets.zero),
        AppText(value,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
            padding: EdgeInsets.zero),
      ],
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
          AppText('Review', style: AppThemeStyle.headerTitle, padding: EdgeInsets.zero),
        ],
      ),
    );
  }
}
