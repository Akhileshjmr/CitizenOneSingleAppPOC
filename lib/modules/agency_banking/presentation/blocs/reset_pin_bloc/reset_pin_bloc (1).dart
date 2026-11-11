
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/reset_pin_bloc/reset_pin_event%20(1).dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/reset_pin_bloc/reset_pin_state%20(1).dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/AuthService.dart';

class ResetPinBloc extends Bloc<ResetPinEvent, ResetPinState> {
  final AuthService authService;

  ResetPinBloc(this.authService) : super(ResetPinInitial()) {
    on<ResetPinSubmitted>(_onResetPinSubmitted);
  }

  Future<void> _onResetPinSubmitted(
      ResetPinSubmitted event, Emitter<ResetPinState> emit) async {
    emit(ResetPinLoading());

    try {
      final response = await authService.resetPin(event.resetPin);

      // Ensure the response is not null
      if (response != null && response.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(ResetPinSuccess(response.errorDescription));
      } else if (response != null) {
        // Search failed with error description
        emit(ResetPinFailure(response.errorDescription));
      } else {
        // Null response scenario
        emit(ResetPinFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(ResetPinFailure('An error occurred while resetting pin'));
    }
  }
}
