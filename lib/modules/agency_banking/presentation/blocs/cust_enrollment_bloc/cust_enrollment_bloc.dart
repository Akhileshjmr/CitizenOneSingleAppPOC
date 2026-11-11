import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cust_enrollment_event.dart';
import 'cust_enrollment_state.dart';

class CustEnrollmentBloc
    extends Bloc<CustEnrollmentEvent, CustEnrollmentState> {
  final AuthService authService;

  CustEnrollmentBloc(this.authService) : super(CustEnrollmentInitial()) {
    on<CustEnrollmentSubmitted>(_CustEnrollmentSubmitted);
  }

  Future<void> _CustEnrollmentSubmitted(
      CustEnrollmentSubmitted event, Emitter<CustEnrollmentState> emit) async {
    emit(CustEnrollmentLoading());

    try {
      final lovResponse = await authService.cust_enroll(event.custEnroll);
      AppLogger.debug('Customer enrollment response received');
      if (lovResponse != null &&
          lovResponse.resMessage.errorCode == "AB-ATTEMPT-100") {
        emit(CustEnrollmentSuccess(
          lovResponse,
          lovResponse.resMessage.errorDescription,
          lovResponse.resMessage.errorCode,
        ));
      } else {
        emit(CustEnrollmentFailure(
            lovResponse?.resMessage.errorDescription ?? "Unknown error"));
      }
    } catch (e) {
      emit(CustEnrollmentFailure('An error occurred: ${e.toString()}'));
    }
  }
}
