import 'package:citizenone_app/modules/agency_banking/core/services/connectivity_service.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/AuthService.dart';
import '../../../utils/AppLogger.dart';
import '../login_bloc/login_event.dart';
import '../login_bloc/login_state.dart';

class OrgLoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService;

  OrgLoginBloc(this.authService) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    // Check internet connection first
    final isConnected = await ConnectivityService.hasConnection();

    if (!isConnected) {
      emit(LoginFailure(
          "You're offline. Please check your internet connection and try again.",
          LoginUserReqResInfo()));
      return;
    }
    emit(LoginLoading());

    try {
      final user = await authService.orgLogin(event.loginRequest);
      if (user != null && user.resMessage.errorCode == "AB-ATTEMPT-100") {
        emit(LoginSuccess(
            user, user.resMessage.errorDescription, user.resMessage.errorCode));
      } else if (user != null) {
        emit(LoginFailure(user.resMessage.errorDescription, user));
      } else {
        emit(LoginFailure(
            'Unable to connect to server. Please check your network connection.',
            LoginUserReqResInfo()));
      }
    } catch (e) {
      AppLogger.error('Org login error', e);
      emit(LoginFailure(
          'Connection failed: ${e.toString()}', LoginUserReqResInfo()));
    }
  }
}
