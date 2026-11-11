import 'package:citizenone_app/modules/agency_banking/presentation/blocs/trustaccount_wallettransaction_bloc/trustaccount_wallettransaction_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/trustaccount_wallettransaction_bloc/trustaccount_wallettransaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/AuthService.dart';

class TrustaccountWallettransactionBloc extends Bloc<TrustaccountWallettransactionEvent, TrustaccountWallettransactionState> {
  final AuthService authService;
  TrustaccountWallettransactionBloc(this.authService) : super(TrustaccountWallettransactionInitial()) {
    on<TrustaccountWallettransactionSubmitted>(_onTrustaccountWallettransactionSubmitted);
  }

  Future<void> _onTrustaccountWallettransactionSubmitted(
      TrustaccountWallettransactionSubmitted event, Emitter<TrustaccountWallettransactionState> emit) async {
    emit(TrustaccountWallettransactionLoading());

    try {
      final response = await authService.trustaccount_wallet(event.walletTransaction);

      // Ensure the response is not null
      if (response != null && response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(TrustaccountWallettransactionSuccess(response.resMessage!.errorDescription,response));
      } else if (response != null) {
        // Search failed with error description
        emit(TrustaccountWallettransactionFailure(response.resMessage!.errorDescription));
      } else {
        // Null response scenario
        emit(TrustaccountWallettransactionFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(TrustaccountWallettransactionFailure('An error occurred'));
    }
  }
}
