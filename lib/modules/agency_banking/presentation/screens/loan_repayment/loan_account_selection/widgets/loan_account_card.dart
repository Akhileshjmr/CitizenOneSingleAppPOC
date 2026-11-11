import 'package:flutter/material.dart';

import '../../../../../core/widgets/form/app_button.dart';
import '../../../../../core/widgets/form/app_text.dart';
import '../../../../../theme/app_theme_style.dart';
import '../../../../../theme/colors/Appcolors.dart';
import '../../repay_loan/view/repay_loan_screen.dart';
import '../../repay_loan/widgets/loan_repayment_details.dart';
import 'app_status_badge.dart';
import 'loan_account_summary.dart';

class LoanAccountCard extends StatelessWidget {
  final LoanAccountSummary account;
  final VoidCallback onProceed;
  final VoidCallback onViewDetails;

  const LoanAccountCard({
    super.key,
    required this.account,
    required this.onProceed,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    //final badge = account.urgency == LoanAccountUrgency.attentionNeeded
        //? AppStatusBadge.amber(account.statusLabel)
       // : AppStatusBadge.green(account.statusLabel);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppThemeStyle.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      account.loanType,
                      fontSize: 12,
                      color: AppColors.secondaryText,
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 2),
                    AppText(
                      account.accountNumber,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              //badge,
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Customer Name',
                      fontSize: 12,
                      color: AppColors.secondaryText,
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 2),
                    AppText(
                      account.customerName,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              if (account.requiresAction)
                AppButton(
                  title: 'Proceed',
                  enabledColor: AppColors.primaryPurple,
                  height: 40,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RepayLoanScreen(
                          details: const LoanRepaymentDetails(
                            loanType: 'Home Loan',
                            accountNumber: 'L-123456789',
                            customerName: 'John Doe',
                            emiAmount: 1800,
                            outstandingAmount: 100000,
                            totalAmountDue: 14500,
                            // statusLabel: 'Due',      ← optional, defaults to 'Due'
                            // currencySymbol: 'ZK',    ← optional, defaults to 'ZK'
                          ),
                          onProceed: (amount) {
                            print('Pay amount: $amount');
                          },
                        ),
                      ),
                    );
                  },
                )
              else
                _ViewDetailsLink(onTap: onViewDetails),
            ],
          ),
        ],
      ),
    );
  }
}

/// "View Details >" — a plain tappable text link, not a filled button.
///
/// PLACEHOLDER: built from AppText + Icon since I don't have your
/// team's actual text-button component's source. If you have one
/// (something like AppTextButton), share it and I'll swap this for the
/// real thing so styling/tap-feedback matches your other text buttons
/// exactly.
class _ViewDetailsLink extends StatelessWidget {
  final VoidCallback onTap;
  const _ViewDetailsLink({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              'View Details',
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryPurple,
              padding: EdgeInsets.zero,
            ),
            const SizedBox(width: 2),
            const Icon(Icons.chevron_right,
                size: 18, color: AppColors.primaryPurple),
          ],
        ),
      ),
    );
  }
}
