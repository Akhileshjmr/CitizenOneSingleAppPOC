import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/services/AuthService.dart';
import 'account_specific_repayment_event.dart';
import 'account_specific_repayment_state.dart';

class AccountSpecificRepaymentBloc
    extends Bloc<AccountSpecificRepaymentEvent, AccountSpecificRepaymentState> {
  final AuthService authService;

  AccountSpecificRepaymentBloc(this.authService)
      : super(AccountSpecificRepaymentInitial()) {
    on<AccountSpecificRepaymentSubmitted>(_onAccountSpecificRepaymentSubmitted);
  }

  Future<void> _onAccountSpecificRepaymentSubmitted(
      AccountSpecificRepaymentSubmitted event,
      Emitter<AccountSpecificRepaymentState> emit) async {
    emit(AccountSpecificRepaymentLoading());

    try {
      final response = await authService.account_specific_repayment(event.req);
      AppLogger.debug('Account specific repayment response received');
      if (response != null && response.responseCode == "AB-ATTEMPT-100") ;
      {
        // Successful search
        emit(
            AccountSpecificRepaymentSuccess(response?.responseCode, response!));
      }
      if (response.responseCode != "AB-ATTEMPT-100") {
        // Search failed with error description
        emit(AccountSpecificRepaymentFailure(response.responseMessage));
      } else {
        // Null response scenario
        emit(AccountSpecificRepaymentFailure(
            'No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(AccountSpecificRepaymentFailure(
          'An error occurred during the account search'));
    }
  }
}
