import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/AuthService.dart';
import 'account_wallet_transaction_event.dart';
import 'account_wallet_transaction_state.dart';

class AccountWalletTransactionBloc extends Bloc<AccountWalletTransactionEvent, AccountWalletTransactionState> {
  final AuthService authService;

  AccountWalletTransactionBloc(this.authService) : super(AccountWalletTransactionInitial()) {
    on<AccountWalletTransactionSubmitted>(_onAccountWalletTransactionSubmitted);
  }

  Future<void> _onAccountWalletTransactionSubmitted(AccountWalletTransactionSubmitted event,
      Emitter<AccountWalletTransactionState> emit) async {
    emit(AccountWalletTransactionLoading());

    try {
      final response = await authService.accountWallettransaction(event.commWalletTransaction);

      // Ensure the response is not null
      if (response != null &&
          response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(AccountWalletTransactionSuccess(response.resMessage!.errorDescription, response));
      } else if (response != null) {
        // Search failed with error description
        emit(AccountWalletTransactionFailure(response.resMessage!.errorDescription));
      } else {
        // Null response scenario
        emit(AccountWalletTransactionFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(AccountWalletTransactionFailure('An error occurred during the account search'));
    }
  }
}
