import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/loan_repayment_details.dart';
import 'repay_loan_event.dart';
import 'repay_loan_state.dart';

class RepayLoanBloc extends Bloc<RepayLoanEvent, RepayLoanState> {
  final LoanRepaymentDetails details;

  /// Only ever read when [RepayLoanState.selectedOption] is
  /// [AmountOption.other] — the "Pay Total Due Amount" option doesn't
  /// use this at all, since its amount is fixed and shown as a static
  /// trailing label, not an editable field.
  final TextEditingController amountController = TextEditingController();
  final FocusNode amountFocus = FocusNode();

  RepayLoanBloc({required this.details}) : super(const RepayLoanState()) {
    amountController.addListener(() => add(const AmountFieldEdited()));

    on<AmountOptionSelected>(_onOptionSelected);
    on<AmountFieldEdited>(_onFieldEdited);
    on<PaySubmitted>(_onSubmitted);
  }

  void _onOptionSelected(
    AmountOptionSelected event,
    Emitter<RepayLoanState> emit,
  ) {
    emit(state.copyWith(
      selectedOption: event.option,
      clearError: true,
      status: RepayLoanStatus.idle,
    ));
  }

  void _onFieldEdited(AmountFieldEdited event, Emitter<RepayLoanState> emit) {
    emit(state.copyWith(clearError: true, status: RepayLoanStatus.idle));
  }

  void _onSubmitted(PaySubmitted event, Emitter<RepayLoanState> emit) {
    if (state.selectedOption == AmountOption.totalDue) {
      emit(state.copyWith(
        status: RepayLoanStatus.validated,
        validatedAmount: details.totalAmountDue,
        clearError: true,
      ));
      return;
    }

    // AmountOption.other
    final raw = amountController.text.trim();
    final amount = double.tryParse(raw.replaceAll(',', ''));

    if (amount == null || amount <= 0) {
      emit(state.copyWith(errorText: 'Enter a valid amount to pay.'));
      return;
    }

    if (amount > details.outstandingAmount) {
      emit(state.copyWith(
        errorText: 'Amount cannot exceed the outstanding balance.',
      ));
      return;
    }

    emit(state.copyWith(
      status: RepayLoanStatus.validated,
      validatedAmount: amount,
      clearError: true,
    ));
  }

  @override
  Future<void> close() {
    amountController.dispose();
    amountFocus.dispose();
    return super.close();
  }
}
