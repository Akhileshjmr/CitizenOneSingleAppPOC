import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../responsive/responsive_layout.dart';
import '../bloc/loan_account_selection_bloc.dart';
import '../bloc/loan_account_selection_event.dart';
import '../widgets/loan_account_summary.dart';
import 'loan_account_selection_mobile.dart';
import 'loan_account_selection_web.dart';

/// "Select Loan Account" results screen — shown after a loan search
/// returns one or more matching accounts. Push this with your own
/// [fetchAccounts] implementation (using your real Dio-backed
/// repository) and navigation callbacks:
///
/// ```dart
/// Navigator.push(context, MaterialPageRoute(
///   builder: (_) => LoanAccountSelectionScreen(
///     fetchAccounts: () => loanRepository.searchResults(searchParams),
///     onProceed: (account) => Navigator.push(context, MaterialPageRoute(
///       builder: (_) => LoanPaymentScreen(accountId: account.id),
///     )),
///     onViewDetails: (account) => Navigator.push(context, MaterialPageRoute(
///       builder: (_) => LoanDetailsScreen(accountId: account.id),
///     )),
///   ),
/// ));
/// ```
class LoanAccountSelectionScreen extends StatelessWidget {
  final Future<List<LoanAccountSummary>> Function() fetchAccounts;
  final void Function(LoanAccountSummary account) onProceed;
  final void Function(LoanAccountSummary account) onViewDetails;
  final String? promoImageUrl;
  final String promoCaption;

  const LoanAccountSelectionScreen({
    super.key,
    required this.fetchAccounts,
    required this.onProceed,
    required this.onViewDetails,
    this.promoImageUrl,
    this.promoCaption =
        'Manage all your loan accounts securely in one place with CitizenOne.',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoanAccountSelectionBloc()
        ..add(LoanAccountListRequested(fetchAccounts: fetchAccounts)),
      child: _LoanAccountSelectionView(
        fetchAccounts: fetchAccounts,
        onProceed: onProceed,
        onViewDetails: onViewDetails,
        promoImageUrl: promoImageUrl,
        promoCaption: promoCaption,
      ),
    );
  }
}

class _LoanAccountSelectionView extends StatelessWidget {
  final Future<List<LoanAccountSummary>> Function() fetchAccounts;
  final void Function(LoanAccountSummary account) onProceed;
  final void Function(LoanAccountSummary account) onViewDetails;
  final String? promoImageUrl;
  final String promoCaption;

  const _LoanAccountSelectionView({
    required this.fetchAccounts,
    required this.onProceed,
    required this.onViewDetails,
    this.promoImageUrl,
    required this.promoCaption,
  });

  void _handleBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LoanAccountSelectionBloc>();

    return ResponsiveLayout(
      mobileLayout: LoanAccountSelectionMobileLayout(
        controller: bloc,
        onBack: () => _handleBack(context),
        fetchAccounts: fetchAccounts,
        onProceed: onProceed,
        onViewDetails: onViewDetails,
        promoImageUrl: promoImageUrl,
        promoCaption: promoCaption,
      ),
      tabletWebLayout: LoanAccountSelectionWebLayout(
        controller: bloc,
        onBack: () => _handleBack(context),
        fetchAccounts: fetchAccounts,
        onProceed: onProceed,
        onViewDetails: onViewDetails,
        promoImageUrl: promoImageUrl,
        promoCaption: promoCaption,
      ),
    );
  }
}
