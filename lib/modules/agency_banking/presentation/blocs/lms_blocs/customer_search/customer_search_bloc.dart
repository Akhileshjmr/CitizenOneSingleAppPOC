import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/services/AuthService.dart';
import 'customer_search_event.dart';
import 'customer_search_state.dart';

class CustomerSearchBloc
    extends Bloc<CustomerSearchEvent, CustomerSearchState> {
  final AuthService authService;

  CustomerSearchBloc(this.authService) : super(CustomerSearchInitial()) {
    on<CustomerSearchSubmitted>(_onCustomerSearchSubmitted);
  }

  Future<void> _onCustomerSearchSubmitted(
      CustomerSearchSubmitted event, Emitter<CustomerSearchState> emit) async {
    emit(CustomerSearchLoading());

    try {
      final response =
          await authService.customer_search(event.gdbCustSearchRequest);
      AppLogger.debug('Customer search response received');
      if (response!.customerSearchStatus == 'SUCCESS') {
        emit(CustomerSearchSuccess(response));
      } else if (response.customerSearchStatus != 'FAIL') {
        emit(CustomerSearchFailure(response.customerSearchStatus));
      }
      // Ensure the response is not null
      // if (response != null && response.responseCode == "AB-ATTEMPT-100")
      // {
      //   // Successful search
      //   emit(CustomerSearchSuccess(response.responseCode,response));
      // }
      // else if (response != null) {
      //   // Search failed with error description
      //   emit(CustomerSearchFailure(response.responseDesc));
      // }
      // else {
      //   // Null response scenario
      //   emit(CustomerSearchFailure('No data returned from the search'));
      // }
    } catch (e) {
      // Error handling during search
      emit(
          CustomerSearchFailure('An error occurred during the account search'));
    }
  }
}
