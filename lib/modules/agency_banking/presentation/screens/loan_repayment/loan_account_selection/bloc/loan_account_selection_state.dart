import 'package:equatable/equatable.dart';

import '../widgets/loan_account_summary.dart';
enum LoanAccountListStatus { loading, loaded, failure }

class LoanAccountSelectionState extends Equatable {
  final LoanAccountListStatus status;
  final List<LoanAccountSummary> accounts;
  final String? errorText;

  const LoanAccountSelectionState({
    this.status = LoanAccountListStatus.loading,
    this.accounts = const [],
    this.errorText,
  });

  LoanAccountSelectionState copyWith({
    LoanAccountListStatus? status,
    List<LoanAccountSummary>? accounts,
    String? errorText,
    bool clearError = false,
  }) {
    return LoanAccountSelectionState(
      status: status ?? this.status,
      accounts: accounts ?? this.accounts,
      errorText: clearError ? null : (errorText ?? this.errorText),
    );
  }

  @override
  List<Object?> get props => [status, accounts, errorText];
}
