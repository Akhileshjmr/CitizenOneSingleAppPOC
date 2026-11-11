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

/// Web / desktop / tablet layout for "Select Loan Account". Same content
/// as mobile, centered with a comfortable max width so the card list
/// never stretches edge-to-edge on a wide browser window.
class LoanAccountSelectionWebLayout extends StatelessWidget {
  final LoanAccountSelectionBloc controller;
  final VoidCallback onBack;
  final Future<List<LoanAccountSummary>> Function() fetchAccounts;
  final void Function(LoanAccountSummary account) onProceed;
  final void Function(LoanAccountSummary account) onViewDetails;
  final String? promoImageUrl;
  final String promoCaption;

  const LoanAccountSelectionWebLayout({
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
      body: Column(
        children: [
          _WebHeader(onBack: onBack),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double contentMaxWidth =
                    constraints.maxWidth >= 900 ? 720 : double.infinity;

                return Center(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: contentMaxWidth),
                      child: BlocBuilder<LoanAccountSelectionBloc,
                          LoanAccountSelectionState>(
                        bloc: controller,
                        builder: (context, state) {
                          return Column(
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
                              const SizedBox(height: 24),
                              _buildBody(state),
                              const SizedBox(height: 24),
                              AppPromoCard(
                                imageUrl: promoImageUrl,
                                caption: promoCaption,
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
          child: Column(
            children: [
              AppText(
                state.errorText ?? 'Something went wrong.',
                textAlign: TextAlign.center,
                color: AppColors.appPrimaryRedColor,
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => controller.add(
                  LoanAccountListRequested(fetchAccounts: fetchAccounts),
                ),
                child: const Text('Retry'),
              ),
            ],
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
