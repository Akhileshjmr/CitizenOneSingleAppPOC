import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_qr_bloc/login_qr_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_qr_bloc/login_qr_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/AuthService.dart';

class LoginQrBloc extends Bloc<LoginQrEvent, LoginQrState> {
  final AuthService authService;
  LoginQrBloc(this.authService) : super(LoginQrInitial()) {
    on<LoginQrSubmitted>(_onLoginQrSubmitted);
  }

  Future<void> _onLoginQrSubmitted(
      LoginQrSubmitted event, Emitter<LoginQrState> emit) async {
    emit(LoginQrLoading());

    try {
      final response = await authService.loginQr(event.qrImage);

      // Ensure the response is not null
      if (response != null && response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(LoginQrSuccess(response.resMessage!.errorDescription,response));
      } else if (response != null) {
        // Search failed with error description
        emit(LoginQrFailure(response.resMessage!.errorDescription));
      } else {
        // Null response scenario
        emit(LoginQrFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(LoginQrFailure('An error occurred while getting user profile'));
    }
  }
}
