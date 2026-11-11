import 'package:citizenone_app/modules/agency_banking/core/services/connectivity_service.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/transaction_method_bloc/transaction_method_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/transaction_method_bloc/transaction_method_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/AuthService.dart';

class TransactionMethodBloc
    extends Bloc<TransactionMethodEvent, TransactionMethodState> {
  final AuthService authService;
  TransactionMethodBloc(this.authService) : super(TransactionMethodInitial()) {
    on<TransactionMethodSubmitted>(_onTransactionMethodSubmitted);
    on<ClearTransactionMethod>((event, emit) {
      emit(TransactionMethodInitial());
    });
  }

  Future<void> _onTransactionMethodSubmitted(TransactionMethodSubmitted event,
      Emitter<TransactionMethodState> emit) async {
    // Check internet connection first
    final isConnected = await ConnectivityService.hasConnection();

    if (!isConnected) {
      emit(TransactionMethodFailure(
          "You're offline. Please check your internet connection and try again."));
      return;
    }

    emit(TransactionMethodLoading());

    try {
      final response = await authService.transMethod(event.transactionName);

      // Ensure the response is not null
      if (response != null &&
          response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(TransactionMethodSuccess(
            response.resMessage!.errorDescription, response));
      } else if (response != null) {
        // Search failed with error description
        emit(TransactionMethodFailure(response.resMessage!.errorDescription));
      } else {
        // Null response scenario
        emit(TransactionMethodFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(TransactionMethodFailure(
          'An error occurred while getting transaction receipt'));
    }
  }
}
