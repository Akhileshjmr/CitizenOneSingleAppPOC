import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_transaction_bloc/wallet_transaction_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_transaction_bloc/wallet_transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/AuthService.dart';

class WalletTransactionBloc extends Bloc<WalletTransactionEvent, WalletTransactionState> {
  final AuthService authService;

  WalletTransactionBloc(this.authService) : super(WalletTransactionInitial()) {
    on<WalletTransactionSubmitted>(_onWalletTransactionSubmitted);
  }

  Future<void> _onWalletTransactionSubmitted(WalletTransactionSubmitted event,
      Emitter<WalletTransactionState> emit) async {
    emit(WalletTransactionLoading());

    try {
      final response = await authService.wallettransaction(event.walletTransaction);

      // Ensure the response is not null
      if (response != null &&
          response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(WalletTransactionSuccess(response.resMessage!.errorDescription, response));
      } else if (response != null) {
        // Search failed with error description
        emit(WalletTransactionFailure(response.resMessage!.errorDescription));
      } else {
        // Null response scenario
        emit(WalletTransactionFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(WalletTransactionFailure('An error occurred during the account search'));
    }
  }
}
