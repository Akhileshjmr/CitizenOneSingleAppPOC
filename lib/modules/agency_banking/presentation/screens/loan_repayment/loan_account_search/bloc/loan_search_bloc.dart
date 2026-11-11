import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'loan_search_event.dart';
import 'loan_search_state.dart';

/// Bloc for the Loan Account Search screen.
///
/// Design choice: [TextEditingController]s are owned here (not read out of
/// [LoanSearchState]) because a [TextField] needs one stable controller
/// instance across rebuilds — routing every keystroke through an event
/// would emit a new state per character and rebuild the whole form
/// unnecessarily. State only tracks what the UI needs to react to: submit
/// status and the validation error message.
class LoanSearchBloc extends Bloc<LoanSearchEvent, LoanSearchState> {
  LoanSearchBloc() : super(const LoanSearchState()) {
    on<LoanSearchFieldEdited>(_onFieldEdited);
    on<LoanSearchSubmitted>(_onSubmitted);
    on<LoanSearchReset>(_onReset);

    loanAccountController.addListener(_notifyFieldEdited);
    mobileNumberController.addListener(_notifyFieldEdited);
  }

  final TextEditingController loanAccountController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController customerIdController = TextEditingController();

  final FocusNode loanAccountFocus = FocusNode();
  final FocusNode mobileNumberFocus = FocusNode();
  final FocusNode customerIdFocus = FocusNode();

  void _notifyFieldEdited() {
    if (state.errorText != null) {
      add(const LoanSearchFieldEdited());
    }
  }

  void _onFieldEdited(LoanSearchFieldEdited event, Emitter<LoanSearchState> emit) {
    emit(state.copyWith(clearError: true));
  }

  bool get _hasLoanAccount => loanAccountController.text.trim().isNotEmpty;
  bool get _hasMobileNumber => mobileNumberController.text.trim().isNotEmpty;
  bool get canSearch => _hasLoanAccount || _hasMobileNumber;

  Future<void> _onSubmitted(
    LoanSearchSubmitted event,
    Emitter<LoanSearchState> emit,
  ) async {
    if (!canSearch) {
      emit(state.copyWith(
        status: LoanSearchStatus.failure,
        errorText: 'Please enter your Loan Account Number or Mobile Number.',
      ));
      return;
    }

    final mobile = mobileNumberController.text.trim();
    if (_hasMobileNumber && RegExp(r'^[0-9]+$').hasMatch(mobile) && mobile.length != 10) {
      emit(state.copyWith(
        status: LoanSearchStatus.failure,
        errorText: 'Please enter a valid 10-digit mobile number.',
      ));
      return;
    }

    emit(state.copyWith(status: LoanSearchStatus.submitting, clearError: true));

    try {
      await event.onValidSearch();
      emit(state.copyWith(status: LoanSearchStatus.success));
    } catch (_) {
      emit(state.copyWith(
        status: LoanSearchStatus.failure,
        errorText: 'Something went wrong. Please try again.',
      ));
    }
  }

  void _onReset(LoanSearchReset event, Emitter<LoanSearchState> emit) {
    loanAccountController.clear();
    mobileNumberController.clear();
    customerIdController.clear();
    emit(const LoanSearchState());
  }

  @override
  Future<void> close() {
    loanAccountController.dispose();
    mobileNumberController.dispose();
    customerIdController.dispose();
    loanAccountFocus.dispose();
    mobileNumberFocus.dispose();
    customerIdFocus.dispose();
    return super.close();
  }
}
