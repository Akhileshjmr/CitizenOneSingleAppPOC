import 'package:citizenone_app/modules/agency_banking/core/services/connectivity_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/AuthService.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthService authService;
  ForgotPasswordBloc(this.authService) : super(ForgotPasswordInitial()) {
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);
    on<ValidateOtpSubmitted>(_onValidateOtpSubmitted);
    on<ResetForgotPasswordState>(_onResetState);
  }
  Future<void> _onForgotPasswordSubmitted(
      ForgotPasswordSubmitted event, Emitter<ForgotPasswordState> emit) async {
    // Check internet connection first
    final isConnected = await ConnectivityService.hasConnection();

    if (!isConnected) {
      emit(ForgotPasswordFailure(
          "You're offline. Please check your internet connection and try again."));
      return;
    }
    emit(ForgotPasswordLoading());

    try {
      final userOtp = await authService.request_Otp(event.otpRequest);

      if (userOtp != null && userOtp.resMessage.errorCode == "AB-ATTEMPT-100") {
        emit(ForgotPasswordSuccess(userOtp, userOtp.resMessage.errorDescription,
            userOtp.resMessage.errorCode)); // On success
      } else {
        emit(ForgotPasswordFailure(
            userOtp?.resMessage.errorDescription ?? 'OTP validation failed'));
      }
    } catch (e) {
      emit(ForgotPasswordFailure('An error occurred during OTP request'));
    }
  }

  // NEW: Validate OTP
  Future<void> _onValidateOtpSubmitted(
      ValidateOtpSubmitted event, Emitter<ForgotPasswordState> emit) async {
    emit(ForgotPasswordLoading());

    try {
      final response =
          await authService.otpFailedValidation(event.otpValidationRequest);

      if (response?.resMessage.errorCode == "AB-ATTEMPT-100") {
        emit(OtpValidationSuccess(response!.resMessage.errorCode, response));
      } else {
        emit(OtpValidationFailure(response!.resMessage.errorDescription));
      }
    } catch (e) {
      emit(OtpValidationFailure("OTP validation failed"));
    }
  }

  void _onResetState(
      ResetForgotPasswordState event, Emitter<ForgotPasswordState> emit) {
    emit(ForgotPasswordInitial()); // resets everything
  }
}
