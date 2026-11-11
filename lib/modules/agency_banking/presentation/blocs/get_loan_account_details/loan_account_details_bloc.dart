
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/AuthService.dart';
import 'loan_account_details_event.dart';
import 'loan_account_details_state.dart';


class LoanAccountDetailsBloc extends Bloc<LoanAccountDetailsEvent, LoanAccountDetailsState> {
  final AuthService authService;

  LoanAccountDetailsBloc(this.authService) : super(LoanAccountDetailsInitial()) {
    on<LoanAccountDetailsSubmitted>(_onLoanAccountDetailsSubmitted);
  }

  Future<void> _onLoanAccountDetailsSubmitted(LoanAccountDetailsSubmitted event,
      Emitter<LoanAccountDetailsState> emit) async {
    emit(LoanAccountDetailsLoading());

    try {
      final response = await authService.getloanAccountDetails(
          event.loanDetails);

      // Ensure the response is not null
      if (response != null &&
          response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(LoanAccountDetailsSuccess(response.resMessage!.errorDescription,response));
      } else if (response != null) {
        // Search failed with error description
        emit(LoanAccountDetailsFailure(response.resMessage!.errorDescription));
      } else {
        // Null response scenario
        emit(LoanAccountDetailsFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(LoanAccountDetailsFailure('An error occurred during the account search'));
    }
  }
}