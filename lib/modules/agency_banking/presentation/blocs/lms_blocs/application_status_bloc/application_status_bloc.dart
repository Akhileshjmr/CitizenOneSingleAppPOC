import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/application_status_bloc/application_status_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/application_status_bloc/application_status_state.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/services/AuthService.dart';

class ApplicationStatusBloc
    extends Bloc<ApplicationStatusEvent, ApplicationStatusState> {
  final AuthService authService;

  ApplicationStatusBloc(this.authService) : super(ApplicationStatusInitial()) {
    on<ApplicationStatusSubmitted>(_onApplicationStatusSubmitted);
  }

  Future<void> _onApplicationStatusSubmitted(ApplicationStatusSubmitted event,
      Emitter<ApplicationStatusState> emit) async {
    emit(ApplicationStatusLoading());

    try {
      final response = await authService.app_status(event.appStatusReqRes);
      AppLogger.debug('Application status response received');
      if (response != null &&
          response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(ApplicationStatusSuccess(response.responseDesc, response));
      } else if (response?.responseDesc != "SUCCESS") {
        // Search failed with error description
        emit(ApplicationStatusFailure(response?.responseDesc));
      } else {
        // Null response scenario
        emit(ApplicationStatusFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(ApplicationStatusFailure(
          'An error occurred during the account search'));
    }
  }
}
