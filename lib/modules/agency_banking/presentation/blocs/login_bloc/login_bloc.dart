import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_bloc/login_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_bloc/login_state.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService;

  LoginBloc(this.authService) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      final user = await authService.login(
          event.loginRequest, null, event.endpointOverride);
      AppLogger.debug('Login response received');
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
      AppLogger.error('Login error', e);
      emit(LoginFailure(
          'Connection failed: ${e.toString()}', LoginUserReqResInfo()));
    }
  }
}
