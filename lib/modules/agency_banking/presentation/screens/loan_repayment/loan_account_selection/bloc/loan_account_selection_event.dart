import 'package:equatable/equatable.dart';

import '../widgets/loan_account_summary.dart';

abstract class LoanAccountSelectionEvent extends Equatable {
  const LoanAccountSelectionEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once when the screen opens (or on pull-to-refresh / retry).
/// [fetchAccounts] performs the actual API call using YOUR Dio client —
/// this Bloc stays networking-agnostic, same pattern as the loan search
/// and OTP Blocs.
class LoanAccountListRequested extends LoanAccountSelectionEvent {
  final Future<List<LoanAccountSummary>> Function() fetchAccounts;

  const LoanAccountListRequested({required this.fetchAccounts});

  @override
  List<Object?> get props => [fetchAccounts];
}
