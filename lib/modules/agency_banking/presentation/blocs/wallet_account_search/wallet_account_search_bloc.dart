import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_account_search/wallet_account_search_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_account_search/wallet_account_search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/AuthService.dart';

class WalletSearchBloc extends Bloc<WalletSearchEvent, WalletSearchState> {
  final AuthService authService;
  WalletSearchBloc(this.authService) : super(WalletSearchInitial()) {
    on<WalletSearchSubmitted>(_onWalletSearchSubmitted);
  }

  Future<void> _onWalletSearchSubmitted(
      WalletSearchSubmitted event, Emitter<WalletSearchState> emit) async {
    emit(WalletSearchLoading());

    try {
      final response = await authService.walletSearch(event.WalletSearchRequest);

      // Ensure the response is not null
      if (response != null && response.resMessage.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(WalletSearchSuccess(response.resMessage.errorDescription,response));

      } else if (response != null) {
        // Search failed with error description
        emit(WalletSearchFailure(response.resMessage.errorDescription));


        //

      } else {
        // Null response scenario
        emit(WalletSearchFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(WalletSearchFailure('An error occurred during the account search'));
    }
  }
}