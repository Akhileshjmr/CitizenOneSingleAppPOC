import 'package:citizenone_app/modules/agency_banking/core/services/connectivity_service.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/balance_sms_bloc/balance_sms_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/balance_sms_bloc/balance_sms_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/AuthService.dart';

class BalanceSmsBloc extends Bloc<BalanceSmsEvent, BalanceSmsState> {
  final AuthService authService;

  BalanceSmsBloc(this.authService) : super(BalanceSmsInitial()) {
    on<BalanceSmsSubmitted>(_onBalanceSmsSubmitted);
  }

  Future<void> _onBalanceSmsSubmitted(
      BalanceSmsSubmitted event, Emitter<BalanceSmsState> emit) async {
    // Check internet connection first
    final isConnected = await ConnectivityService.hasConnection();

    if (!isConnected) {
      emit(BalanceSmsFailure(
          "You're offline. Please check your internet connection and try again."));
      return;
    }
    emit(BalanceSmsLoading());

    try {
      final response = await authService.balanceSMS(event.accountBalance);

      // Ensure the response is not null
      if (response != null &&
          response.resMessage.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(BalanceSmsSuccess(response.resMessage.errorDescription, response));
      } else if (response != null) {
        // Search failed with error description
        emit(BalanceSmsFailure(response.resMessage.errorDescription));
      } else {
        // Null response scenario
        emit(BalanceSmsFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(BalanceSmsFailure('An error occurred during the account search'));
    }
  }
}
