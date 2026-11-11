
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_account_balance/wallet_balance_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_account_balance/wallet_balance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/AuthService.dart';

class WalletBalanceBloc extends Bloc<WalletBalanceEvent, WalletBalanceState> {
  final AuthService authService;

  WalletBalanceBloc(this.authService) : super(WalletBalanceInitial()) {
    on<WalletBalanceSubmitted>(_onWalletBalanceSubmitted);
  }

  Future<void> _onWalletBalanceSubmitted(WalletBalanceSubmitted event,
      Emitter<WalletBalanceState> emit) async {
    emit(WalletBalanceLoading());

    try {
      final response = await authService.walletBalance(
          event.walletBalance);

      // Ensure the response is not null
      if (response != null &&
          response.resMessage.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(WalletBalanceSuccess(response.resMessage.errorDescription, response));
      } else if (response != null) {
        // Search failed with error description
        emit(WalletBalanceFailure(response.resMessage.errorDescription));
      } else {
        // Null response scenario
        emit(WalletBalanceFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(WalletBalanceFailure('An error occurred during the account search'));
    }
  }
}
