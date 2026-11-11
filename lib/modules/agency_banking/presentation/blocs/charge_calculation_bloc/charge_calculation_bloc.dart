import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'charge_calculation_event.dart';
import 'charge_calculation_state.dart';

class ChargeCalculationBloc
    extends Bloc<ChargeCalculationEvent, ChargeCalculationState> {
  final AuthService authService;

  ChargeCalculationBloc(this.authService) : super(ChargeCalculationInitial()) {
    on<ChargeCalculationSubmitted>(_ChargeCalculationSubmitted);
  }

  Future<void> _ChargeCalculationSubmitted(ChargeCalculationSubmitted event,
      Emitter<ChargeCalculationState> emit) async {
    emit(ChargeCalculationLoading());
    try {
      final lovResponse = await authService.tax_cal(event.chargeCal);
      AppLogger.debug('Charge calculation response received');
      if (lovResponse != null &&
          lovResponse.resMessage?.errorCode == "AB-ATTEMPT-100") {
        emit(ChargeCalculationSuccess(
          lovResponse,
          lovResponse.resMessage!.errorDescription,
          lovResponse.resMessage!.errorCode,
        ));
      } else {
        emit(ChargeCalculationFailure(
            lovResponse?.resMessage?.errorDescription ?? "Unknown error"));
      }
    } catch (e) {
      emit(ChargeCalculationFailure('An error occurred: ${e.toString()}'));
    }
  }
}
