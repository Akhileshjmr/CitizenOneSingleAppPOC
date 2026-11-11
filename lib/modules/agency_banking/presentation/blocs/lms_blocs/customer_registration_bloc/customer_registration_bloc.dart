import 'package:bloc/bloc.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';

import '../../../../data/services/AuthService.dart';
import 'customer_registration_event.dart';
import 'customer_registration_state.dart';

class CustomerRegistrationBloc
    extends Bloc<CustomerRegistrationEvent, CustomerRegistrationState> {
  final AuthService authService;

  CustomerRegistrationBloc(this.authService)
      : super(CustomerRegistrationInitial()) {
    on<CustomerRegistrationSubmitted>(_onCustomerRegistrationSubmitted);
  }

  Future<void> _onCustomerRegistrationSubmitted(
      CustomerRegistrationSubmitted event,
      Emitter<CustomerRegistrationState> emit) async {
    emit(CustomerRegistrationLoading());

    try {
      final response =
          await authService.customer_reg(event.gdbCustRtlAppRequest);
      AppLogger.debug('Customer registration response received');
      if (response != null && response.gdbCustId != null) {
        // Successful search
        emit(CustomerRegistrationSuccess(response.message.type, response));
      } else if (response != null && response.gdbCustId != null) {
        // Search failed with error description
        emit(CustomerRegistrationFailure(response.message.message));
      } else {
        // Null response scenario
        emit(CustomerRegistrationFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(CustomerRegistrationFailure(
          'An error occurred during the account search'));
    }
  }
}
