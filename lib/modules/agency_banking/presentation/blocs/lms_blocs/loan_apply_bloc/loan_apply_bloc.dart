import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/services/AuthService.dart';
import 'loan_apply_event.dart';
import 'loan_apply_state.dart';

class LoanApplyBloc extends Bloc<LoanApplyEvent, LoanApplyState> {
  final AuthService authService;

  LoanApplyBloc(this.authService) : super(LoanApplyInitial()) {
    on<LoanApplySubmitted>(_onLoanApplySubmitted);
  }

  Future<void> _onLoanApplySubmitted(
      LoanApplySubmitted event, Emitter<LoanApplyState> emit) async {
    emit(LoanApplyLoading());

    try {
      final response =
          await authService.loanApply(event.gdbMerchantDisProductPurRequest);
      AppLogger.debug('Loan apply response received');
      // Ensure the response is not null
      if (response != null && response.responseCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(LoanApplySuccess(response.responseCode, response));
      } else if (response != null && response.responseDesc != 'PURCHASE DONE') {
        // Search failed with error description
        emit(LoanApplyFailure(response.responseDesc));
      } else {
        // Null response scenario
        emit(LoanApplyFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(LoanApplyFailure('An error occurred during the account search'));
    }
  }
}
