import 'package:citizenone_app/modules/agency_banking/presentation/blocs/change_pin_bloc/change_pin_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/change_pin_bloc/change_pin_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/AuthService.dart';

class ChangePinBloc extends Bloc<ChangePinEvent, ChangePinState> {
  final AuthService authService;

  ChangePinBloc(this.authService) : super(ChangePinInitial()) {
    on<ChangePinSubmitted>(_onChangePinSubmitted);
  }

  Future<void> _onChangePinSubmitted(
      ChangePinSubmitted event, Emitter<ChangePinState> emit) async {
    emit(ChangePinLoading());

    try {
      final response = await authService.changePin(event.changePin);

      // Ensure the response is not null
      if (response != null && response.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(ChangePinSuccess(response.errorDescription));
      } else if (response != null) {
        // Search failed with error description
        emit(ChangePinFailure(response.errorDescription));
      } else {
        // Null response scenario
        emit(ChangePinFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(ChangePinFailure('An error occurred while changing pin'));
    }
  }
}
