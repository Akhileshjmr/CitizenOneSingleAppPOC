import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/services/AuthService.dart';
import 'collateral_event.dart';
import 'collateral_state.dart';

class CollateralBloc extends Bloc<CollateralEvent, CollateralState> {
  final AuthService authService;

  CollateralBloc(this.authService) : super(CollateralInitial()) {
    on<CollateralSubmitted>(_onCollateralSubmitted);
  }

  Future<void> _onCollateralSubmitted(
      CollateralSubmitted event, Emitter<CollateralState> emit) async {
    emit(CollateralLoading());

    try {
      final response = await authService.collateral_details(event.req);
      AppLogger.debug('Collateral details response received');
      if (response != null && response.chMessage?.code == "AB-ATTEMPT-100") ;
      {
        // Successful search
        emit(CollateralSuccess(response?.chMessage?.message, response!));
      }
      if (response.chMessage?.code != "AB-ATTEMPT-100") {
        // Search failed with error description
        emit(CollateralFailure(response.chMessage?.message));
      } else {
        // Null response scenario
        emit(CollateralFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(CollateralFailure('An error occurred during the account search'));
    }
  }
}
