import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/eligibility_score_bloc/eligibility_score_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/eligibility_score_bloc/eligibility_score_state.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/services/AuthService.dart';

class EligibilityScoreBloc
    extends Bloc<EligibilityScoreEvent, EligibilityScoreState> {
  final AuthService authService;

  EligibilityScoreBloc(this.authService) : super(EligibilityScoreInitial()) {
    on<EligibilityScoreSubmitted>(_onEligibilityScoreSubmitted);
  }

  Future<void> _onEligibilityScoreSubmitted(EligibilityScoreSubmitted event,
      Emitter<EligibilityScoreState> emit) async {
    emit(EligibilityScoreLoading());

    try {
      final response = await authService.eligibility_score(event.scoreReqRes);
      AppLogger.debug('Eligibility score response received');
      if (response != null && response.responseCode == "SUCCESS") ;
      {
        // Successful search
        emit(EligibilityScoreSuccess(response?.responseDesc, response!));
      }
      if (response.responseCode == "SUCCESS") {
        // Search failed with error description
        emit(EligibilityScoreFailure(response.responseDesc));
      } else {
        // Null response scenario
        emit(EligibilityScoreFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(EligibilityScoreFailure(
          'An error occurred during the account search'));
    }
  }
}
