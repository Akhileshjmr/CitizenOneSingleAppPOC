import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'get_lov_event.dart';
import 'get_lov_state.dart';

class GetLovBloc extends Bloc<GetLovEvent, GetLovState> {
  final AuthService authService;
  GetLovBloc(this.authService) : super(GetLovInitial()) {
    on<GetLovSubmitted>(_onGetLovSubmitted);
  }

  Future<void> _onGetLovSubmitted(
      GetLovSubmitted event, Emitter<GetLovState> emit) async {
    emit(GetLovLoading());

    try {
      final user = await authService.get_Lov(event.GetLovRequest);
      if (user != null && user.resMessage?.errorCode == "AB-ATTEMPT-100") {
        emit(GetLovSuccess(user, user.resMessage!.errorDescription,
            user.resMessage!.errorCode)); // On success
      } else {
        emit(GetLovFailure(user!.resMessage!.errorDescription));
      }
    } catch (e) {
      AppLogger.error('Error fetching LOV data', e);
      emit(GetLovFailure('An error occurred'));
    }
  }
}
