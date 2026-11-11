import 'package:equatable/equatable.dart';
import 'repay_loan_event.dart';

enum RepayLoanStatus { idle, validated }

class RepayLoanState extends Equatable {
  final AmountOption selectedOption;
  final RepayLoanStatus status;
  final String? errorText;
  final double? validatedAmount;

  const RepayLoanState({
    this.selectedOption = AmountOption.totalDue,
    this.status = RepayLoanStatus.idle,
    this.errorText,
    this.validatedAmount,
  });

  RepayLoanState copyWith({
    AmountOption? selectedOption,
    RepayLoanStatus? status,
    String? errorText,
    bool clearError = false,
    double? validatedAmount,
  }) {
    return RepayLoanState(
      selectedOption: selectedOption ?? this.selectedOption,
      status: status ?? this.status,
      errorText: clearError ? null : (errorText ?? this.errorText),
      validatedAmount: validatedAmount ?? this.validatedAmount,
    );
  }

  @override
  List<Object?> get props =>
      [selectedOption, status, errorText, validatedAmount];
}
