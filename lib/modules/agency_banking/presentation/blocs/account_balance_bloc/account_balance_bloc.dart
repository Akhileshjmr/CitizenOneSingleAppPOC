import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/AuthService.dart';
import 'account_balance_event.dart';
import 'account_balance_state.dart';

class AccountBalanceBloc
    extends Bloc<AccountBalanceEvent, AccountBalanceState> {
  final AuthService authService;

  AccountBalanceBloc(this.authService) : super(AccountBalanceInitial()) {
    on<AccountBalanceSubmitted>(_onAccountBalanceSubmitted);
  }

  Future<void> _onAccountBalanceSubmitted(
      AccountBalanceSubmitted event, Emitter<AccountBalanceState> emit) async {
    emit(AccountBalanceLoading());

    try {
      final response = await authService.accountBalance(event.accountBalance);

      // Ensure the response is not null
      if (response != null &&
          response.resMessage.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(AccountBalanceSuccess(
            response.resMessage.errorDescription, response));
      } else if (response != null) {
        // Search failed with error description
        emit(AccountBalanceFailure(response.resMessage.errorDescription));
      } else {
        // Null response scenario
        emit(AccountBalanceFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(
          AccountBalanceFailure('An error occurred during the account search'));
    }
  }
}
