import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/emi_calculation_bloc/emi_calculation_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/emi_calculation_bloc/emi_calculation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/services/AuthService.dart';

class EmiCalculationBloc
    extends Bloc<EmiCalculationEvent, EmiCalculationState> {
  final AuthService authService;

  EmiCalculationBloc(this.authService) : super(EmiCalculationInitial()) {
    on<EmiCalculationSubmitted>(_onEmiCalculationSubmitted);
  }

  Future<void> _onEmiCalculationSubmitted(
      EmiCalculationSubmitted event, Emitter<EmiCalculationState> emit) async {
    emit(EmiCalculationLoading());

    try {
      final response =
          await authService.emi_calculator(event.emiCalculateRequest);
      if (response != null && response.message == "AB-ATTEMPT-100") ;
      {
        // Successful search
        emit(EmiCalculationSuccess(response?.message, response!));
      }
      if (response.message != "AB-ATTEMPT-100") {
        // Search failed with error description
        emit(EmiCalculationFailure(response.message));
      } else {
        // Null response scenario
        emit(EmiCalculationFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(
          EmiCalculationFailure('An error occurred during the account search'));
    }
  }
}
