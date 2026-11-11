import 'package:bloc/bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/send_money_bloc/send_money_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/send_money_bloc/send_money_state.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';

import '../../../data/services/AuthService.dart';

class SendMoneyBloc extends Bloc<SendMoneyEvent, SendMoneyState> {
  final AuthService authService;

  SendMoneyBloc(this.authService) : super(SendMoneyInitial()) {
    on<SendMoneySubmitted>(_onSendMoneySubmitted);
  }

  Future<void> _onSendMoneySubmitted(
      SendMoneySubmitted event, Emitter<SendMoneyState> emit) async {
    emit(SendMoneyLoading());

    try {
      final response =
          await authService.send_money_account(event.accountTransaction);
      AppLogger.debug('Send money response received');
      // Ensure the response is not null
      if (response != null &&
          response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(SendMoneySuccess(response.resMessage!.errorDescription, response));
      } else if (response != null) {
        // Search failed with error description
        emit(SendMoneyFailure(response.resMessage!.errorDescription));
      } else {
        // Null response scenario
        emit(SendMoneyFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(SendMoneyFailure('An error occurred during the account search'));
    }
  }
}
