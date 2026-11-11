import 'package:citizenone_app/modules/agency_banking/core/services/connectivity_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/common_models/ServerMessage.dart';
import '../../../data/services/AuthService.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthService authService;
  ResetPasswordBloc(this.authService) : super(ResetPasswordInitial()) {
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
  }

  Future<void> _onResetPasswordSubmitted(
      ResetPasswordSubmitted event, Emitter<ResetPasswordState> emit) async {
    // Check internet connection first
    final isConnected = await ConnectivityService.hasConnection();

    if (!isConnected) {
      emit(ResetPasswordFailure(
          "You're offline. Please check your internet connection and try again."));
      return;
    }
    emit(ResetPasswordLoading());

    try {
      final ServerMessage response = (await authService
          .reset_password(event.resetPasswordRequest)) as ServerMessage;
      // Check for a successful response
      if (response.errorCode == "AB-ATTEMPT-100") {
        // Change this to the actual success code
        emit(ResetPasswordSuccess(response.errorDescription));
      } else {
        emit(ResetPasswordFailure(response.errorDescription));
      }
    } catch (e) {
      emit(ResetPasswordFailure('An error occurred during the password reset'));
    }
  }
}
