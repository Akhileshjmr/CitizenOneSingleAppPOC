import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_account_search/wallet_account_search_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_account_search/wallet_account_search_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_registration_bloc/wallet_registration_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_registration_bloc/wallet_registration_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/AuthService.dart';

class WalletRegistrationBloc extends Bloc<WalletRegistrationEvent, WalletRegistrationState> {
  final AuthService authService;
  WalletRegistrationBloc(this.authService) : super(WalletRegistrationInitial()) {
    on<WalletRegistrationSubmitted>(_onWalletRegistrationSubmitted);
  }

  Future<void> _onWalletRegistrationSubmitted(
      WalletRegistrationSubmitted event, Emitter<WalletRegistrationState> emit) async {
    emit(WalletRegistrationLoading());

    try {
      final response = await authService.wallet_creation(event.WalletRegistrationRequest);

      // Ensure the response is not null
      if (response != null && response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(WalletRegistrationSuccess(response.resMessage!.errorDescription,response));

      } else if (response != null) {
        // Search failed with error description
        emit(WalletRegistrationFailure(response.resMessage!.errorDescription));


        //

      } else {
        // Null response scenario
        emit(WalletRegistrationFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(WalletRegistrationFailure('An error occurred during the account search'));
    }
  }
}