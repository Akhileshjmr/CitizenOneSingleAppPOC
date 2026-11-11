import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/AuthService.dart';
import 'account_transaction_event.dart';
import 'account_transaction_state.dart';

class AccountTransactionBloc
    extends Bloc<AccountTransactionEvent, AccountTransactionState> {
  final AuthService authService;

  AccountTransactionBloc(this.authService)
      : super(AccountTransactionInitial()) {
    on<AccountTransactionSubmitted>(_onAccountTransactionSubmitted);
  }

  Future<void> _onAccountTransactionSubmitted(AccountTransactionSubmitted event,
      Emitter<AccountTransactionState> emit) async {
    emit(AccountTransactionLoading());

    try {
      final response =
          await authService.accounttransaction(event.accountTransaction);
      AppLogger.debug('Account transaction response received');
      // Ensure the response is not null
      if (response != null &&
          response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(AccountTransactionSuccess(
            response.resMessage!.errorDescription, response));
      } else if (response != null) {
        // Search failed with error description
        emit(AccountTransactionFailure(response.resMessage!.errorDescription));
      } else {
        // Null response scenario
        emit(AccountTransactionFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(AccountTransactionFailure(
          'An error occurred during the account search'));
    }
  }
}
