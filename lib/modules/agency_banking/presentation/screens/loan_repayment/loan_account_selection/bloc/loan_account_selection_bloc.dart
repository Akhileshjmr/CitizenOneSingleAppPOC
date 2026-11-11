import 'package:flutter_bloc/flutter_bloc.dart';
import 'loan_account_selection_event.dart';
import 'loan_account_selection_state.dart';

class LoanAccountSelectionBloc
    extends Bloc<LoanAccountSelectionEvent, LoanAccountSelectionState> {
  LoanAccountSelectionBloc() : super(const LoanAccountSelectionState()) {
    on<LoanAccountListRequested>(_onListRequested);
  }

  Future<void> _onListRequested(
    LoanAccountListRequested event,
    Emitter<LoanAccountSelectionState> emit,
  ) async {
    emit(state.copyWith(
        status: LoanAccountListStatus.loading, clearError: true));

    try {
      final accounts = await event.fetchAccounts();
      emit(state.copyWith(
        status: LoanAccountListStatus.loaded,
        accounts: accounts,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: LoanAccountListStatus.failure,
        errorText: 'Could not load your loan accounts. Please try again.',
      ));
    }
  }
}
