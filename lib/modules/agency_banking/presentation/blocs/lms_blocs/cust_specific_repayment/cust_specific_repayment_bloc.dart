import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/services/AuthService.dart';
import 'cust_specific_repayment_event.dart';
import 'cust_specific_repayment_state.dart';

class CustSpecificRepaymentBloc
    extends Bloc<CustSpecificRepaymentEvent, CustSpecificRepaymentState> {
  final AuthService authService;

  CustSpecificRepaymentBloc(this.authService)
      : super(CustSpecificRepaymentInitial()) {
    on<CustSpecificRepaymentSubmitted>(_onCustSpecificRepaymentSubmitted);
  }

  Future<void> _onCustSpecificRepaymentSubmitted(
      CustSpecificRepaymentSubmitted event,
      Emitter<CustSpecificRepaymentState> emit) async {
    emit(CustSpecificRepaymentLoading());

    try {
      final response = await authService.cust_specific_repayment(event.req);
      AppLogger.debug('Customer specific repayment response received');
      if (response != null && response.responseCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(CustSpecificRepaymentSuccess(response.responseCode, response));
      }

      if (response?.responseCode == "AB-ATTEMPT-101") {
        // Search failed with error description
        emit(CustSpecificRepaymentFailure(response?.message));
      }
    } catch (e) {
      // Error handling during search
      emit(CustSpecificRepaymentFailure(
          'An error occurred during the account search'));
    }
  }
}
