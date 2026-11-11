import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../responsive/responsive_layout.dart';
import '../bloc/loan_search_bloc.dart';
import 'loan_search_mobile.dart';
import 'loan_search_web.dart';

/// Entry point for the Loan Account Search screen.
///
/// Provides a single [LoanSearchBloc] (via [BlocProvider]) shared by
/// whichever layout [ResponsiveLayout] picks, so switching between mobile
/// and web — e.g. resizing a browser window, rotating a tablet — never
/// loses form state or re-triggers a new submit.
class LoanAccountSearchScreen extends StatelessWidget {
  const LoanAccountSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoanSearchBloc(),
      child: const _LoanAccountSearchView(),
    );
  }
}

class _LoanAccountSearchView extends StatelessWidget {
  const _LoanAccountSearchView();

  Future<void> _handleSearch(BuildContext context) async {
    // TODO: replace with the real API call, e.g.
    // final bloc = context.read<LoanSearchBloc>();
    // final result = await loanRepository.lookupAccount(
    //   loanAccountNumber: bloc.loanAccountController.text.trim(),
    //   mobileNumber: bloc.mobileNumberController.text.trim(),
    //   customerId: bloc.customerIdController.text.trim(),
    // );
    // then navigate to the account details / EMI payment screen.
    await Future<void>.delayed(const Duration(milliseconds: 900));
  }

  void _handleBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _handleFindLoanNumber() {
    // TODO: open the "where can I find my loan number" help sheet.
  }

  void _handleCheckEmiSchedule() {
    // TODO: navigate to the EMI schedule screen.
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LoanSearchBloc>();

    return ResponsiveLayout(
      mobileLayout: LoanSearchMobileLayout(
        controller: bloc,
        onBack: () => _handleBack(context),
        onSearch: () => _handleSearch(context),
        onFindLoanNumberTap: _handleFindLoanNumber,
        onCheckEmiScheduleTap: _handleCheckEmiSchedule,
      ),
      tabletWebLayout: LoanSearchWebLayout(
        controller: bloc,
        onBack: () => _handleBack(context),
        onSearch: () => _handleSearch(context),
        onFindLoanNumberTap: _handleFindLoanNumber,
        onCheckEmiScheduleTap: _handleCheckEmiSchedule,
      ),
    );
  }
}
