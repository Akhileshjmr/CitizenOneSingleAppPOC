import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/form/app_text.dart';
import '../../../../../theme/app_theme_style.dart';
import '../../../../../theme/colors/Appcolors.dart';
import '../bloc/loan_account_selection_bloc.dart';
import '../bloc/loan_account_selection_event.dart';
import '../bloc/loan_account_selection_state.dart';
import '../widgets/app_promo_card.dart';
import '../widgets/loan_account_card.dart';
import '../widgets/loan_account_summary.dart';

/// Mobile layout for "Select Loan Account" — matches the reference
/// screenshot: back arrow + "Select Loan Account" header, "Active
/// Loans" title/subtitle, a card per loan account (Proceed or View
/// Details depending on urgency), and a promo card at the bottom.
class LoanAccountSelectionMobileLayout extends StatelessWidget {
  final LoanAccountSelectionBloc controller;
  final VoidCallback onBack;
  final Future<List<LoanAccountSummary>> Function() fetchAccounts;
  final void Function(LoanAccountSummary account) onProceed;
  final void Function(LoanAccountSummary account) onViewDetails;
  final String? promoImageUrl;
  final String promoCaption;

  const LoanAccountSelectionMobileLayout({
    super.key,
    required this.controller,
    required this.onBack,
    required this.fetchAccounts,
    required this.onProceed,
    required this.onViewDetails,
    this.promoImageUrl,
    this.promoCaption =
        'Manage all your loan accounts securely in one place with CitizenOne.',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _Header(onBack: onBack),
            Expanded(
              child: BlocBuilder<LoanAccountSelectionBloc,
                  LoanAccountSelectionState>(
                bloc: controller,
                builder: (context, state) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.add(
                        LoanAccountListRequested(fetchAccounts: fetchAccounts),
                      );
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            'Active Loans',
                            style: AppThemeStyle.pageTitle,
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(height: 8),
                          AppText(
                            'Please select an account to view details or make a payment.',
                            style: AppThemeStyle.pageSubtitle,
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(height: 20),
                          _buildBody(state),
                          const SizedBox(height: 20),
                          AppPromoCard(
                            imageUrl: promoImageUrl,
                            caption: promoCaption,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LoanAccountSelectionState state) {
    if (state.status == LoanAccountListStatus.loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.status == LoanAccountListStatus.failure) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: AppText(
            state.errorText ?? 'Something went wrong.',
            textAlign: TextAlign.center,
            color: AppColors.appPrimaryRedColor,
            padding: EdgeInsets.zero,
          ),
        ),
      );
    }

    if (state.accounts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: AppText(
            'No active loan accounts found.',
            color: AppColors.secondaryText,
            padding: EdgeInsets.zero,
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final account in state.accounts) ...[
          LoanAccountCard(
            account: account,
            onProceed: () => onProceed(account),
            onViewDetails: () => onViewDetails(account),
          ),
          const SizedBox(height: 14),
        ],
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
          AppText(
            'Select Loan Account',
            style: AppThemeStyle.headerTitle,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
