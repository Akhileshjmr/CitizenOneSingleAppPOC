import 'package:citizenone_app/modules/agency_banking/presentation/blocs/pin_validation_bloc/pin_validation_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/pin_validation_bloc/pin_validation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/AuthService.dart';

class PinValidationBloc extends Bloc<PinValidationEvent, PinValidationState> {
  final AuthService authService;

  PinValidationBloc(this.authService) : super(PinValidationInitial()) {
    on<PinValidationSubmitted>(_onPinValidationSubmitted);
    on<ResetPinValidationState>(_onResetState);
  }

  Future<void> _onPinValidationSubmitted(
      PinValidationSubmitted event, Emitter<PinValidationState> emit) async
  {
    emit(PinValidationLoading());

    try {
      final response = await authService.pinValidation(event.validatePin);

      if (response != null && response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        emit(PinValidationSuccess(response.resMessage!.errorDescription,response,)); // On success
      } else {
        emit(PinValidationFailure(response?.resMessage?.errorDescription ?? 'Pin validation failed'));
      }
    } catch (e) {
      emit(PinValidationFailure('An error occurred during Pin validation'));
    }
  }
  void _onResetState(
      ResetPinValidationState event, Emitter<PinValidationState> emit) {
    emit(PinValidationInitial());
  }
}