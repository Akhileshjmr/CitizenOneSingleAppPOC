import 'package:citizenone_app/modules/agency_banking/core/services/connectivity_service.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/common_models/HeaderInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/AbAgentForgotChangePwd.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AESEncryption.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'security_event.dart';
import 'security_state.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  final AuthService authService;

  SecurityBloc(this.authService) : super(SecurityInitial()) {
    on<ChangePasswordSubmitted>(_onChangePasswordSubmitted);
  }

  Future<void> _onChangePasswordSubmitted(
      ChangePasswordSubmitted event, Emitter<SecurityState> emit) async {
    final isConnected = await ConnectivityService.hasConnection();

    if (!isConnected) {
      emit(ChangePasswordFailure(
          "You're offline. Please check your internet connection and try again."));
      return;
    }

    emit(SecurityLoading());

    try {
      final resetRequest = AbAgentForgetChangePwd(
        headerInfo: HeaderInfo(message: "SKIP_SESSION", initialAccess: true),
        userName: event.loginResponse.loginUserInfo.userName ?? "",
        newPwd: AESEncryptionService.encrypt(event.newPassword),
        deviceId: AESEncryptionService.encrypt("3704e319b72f9d3e"),
        status: '',
        pwd: AESEncryptionService.encrypt(event.currentPassword),
        confPword: '',
        agentCode: '',
        otp: '',
        email: '',
        ph_no: '',
      );

      final response = await authService.reset_password(resetRequest);

      if (response != null && response.errorCode == "AB-ATTEMPT-100") {
        emit(ChangePasswordSuccess(response.errorDescription));
      } else if (response != null) {
        emit(ChangePasswordFailure(response.errorDescription));
      } else {
        emit(ChangePasswordFailure('No response from server'));
      }
    } catch (e) {
      emit(ChangePasswordFailure('An error occurred during password change'));
    }
  }
}
