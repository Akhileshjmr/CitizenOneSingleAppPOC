import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/form/app_button.dart';
import '../../../../../core/widgets/form/app_text.dart';
import '../../../../../theme/app_theme_style.dart';
import '../../../../../theme/colors/Appcolors.dart';
import '../bloc/review_bloc.dart';
import '../bloc/review_event.dart';
import '../bloc/review_state.dart';

/// Web / desktop / tablet / landscape-phone layout for the Review
/// screen. Same three-tier responsive scheme as the rest of this app.
class ReviewWebLayout extends StatelessWidget {
  final ReviewBloc controller;
  final VoidCallback onBack;
  final String accountNumber;
  final String customerName;
  final String paymentAmountFormatted;
  final Future<Map<String, dynamic>> Function() onSubmit;

  const ReviewWebLayout({
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
      body: Column(
        children: [
          _WebHeader(onBack: onBack),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double formMaxWidth = constraints.maxWidth >= 1100
                    ? 460
                    : constraints.maxWidth >= 700
                        ? 520
                        : double.infinity;

                return Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth >= 700 ? 24 : 16,
                      vertical: 40,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: formMaxWidth),
                      child: BlocBuilder<ReviewBloc, ReviewState>(
                        bloc: controller,
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppText('Review',
                                  style: AppThemeStyle.pageTitle,
                                  padding: EdgeInsets.zero),
                              const SizedBox(height: 18),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.cardBg,
                                  borderRadius: BorderRadius.circular(
                                      AppThemeStyle.cardRadius),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 24,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
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
                              const SizedBox(height: 24),
                              state.isSubmitting
                                  ? const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 14),
                                      child: Center(
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2.4),
                                        ),
                                      ),
                                    )
                                  : AppButton(
                                      title: 'Submit',
                                      fullWidth: true,
                                      enabledColor: AppColors.primaryPurple,
                                      onPressed: () => controller.add(
                                          ReviewSubmitted(onSubmit: onSubmit)),
                                    ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
          AppText('Review', style: AppThemeStyle.headerTitle, padding: EdgeInsets.zero),
        ],
      ),
    );
  }
}
