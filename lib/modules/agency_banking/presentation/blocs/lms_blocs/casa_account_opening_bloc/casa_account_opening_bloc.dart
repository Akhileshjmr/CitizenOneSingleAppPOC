import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/casa_account_opening_bloc/casa_account_opening_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/casa_account_opening_bloc/casa_account_opening_state.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/services/AuthService.dart';

class CasaAccountOpeningBloc
    extends Bloc<CasaAccountOpeningEvent, CasaAccountOpeningState> {
  final AuthService authService;

  CasaAccountOpeningBloc(this.authService)
      : super(CasaAccountOpeningInitial()) {
    on<CasaAccountOpeningSubmitted>(_onCasaAccountOpeningSubmitted);
  }

  Future<void> _onCasaAccountOpeningSubmitted(CasaAccountOpeningSubmitted event,
      Emitter<CasaAccountOpeningState> emit) async {
    emit(CasaAccountOpeningLoading());

    try {
      final response = await authService
          .casa_account_opening(event.casaAccountCreateRequest);
      AppLogger.debug('CASA account opening response received');
      if (response != null && response.responseCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(CasaAccountOpeningSuccess(response?.responseMessage, response!));
      } else if (response != null &&
          response.responseCode != "AB-ATTEMPT-100") {
        // Search failed with error description
        emit(CasaAccountOpeningFailure(response.responseMessage));
      } else {
        // Null response scenario
        emit(CasaAccountOpeningFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(CasaAccountOpeningFailure(
          'An error occurred during the account search'));
    }
  }
}
