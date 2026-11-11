import 'package:equatable/equatable.dart';

/// The two repayment options shown in the screenshot: pay the total
/// amount due in full, or enter a custom "Other Amount".
enum AmountOption { totalDue, other }

abstract class RepayLoanEvent extends Equatable {
  const RepayLoanEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the user taps either radio option.
class AmountOptionSelected extends RepayLoanEvent {
  final AmountOption option;
  const AmountOptionSelected(this.option);

  @override
  List<Object?> get props => [option];
}

/// Fired on every keystroke in the "Other Amount" field — clears any
/// previous error.
class AmountFieldEdited extends RepayLoanEvent {
  const AmountFieldEdited();
}

/// Fired when the user taps "Next". Validates the effective amount
/// (the fixed total due, or the entered custom amount).
class PaySubmitted extends RepayLoanEvent {
  const PaySubmitted();
}
