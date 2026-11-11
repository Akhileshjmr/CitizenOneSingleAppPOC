import 'package:citizenone_app/modules/agency_banking/core/services/connectivity_service.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/transaction_receipt_bloc/transaction_receipt_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/transaction_receipt_bloc/transaction_receipt_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/AuthService.dart';

class TransactionReceiptBloc
    extends Bloc<TransactionReceiptEvent, TransactionReceiptState> {
  final AuthService authService;
  TransactionReceiptBloc(this.authService)
      : super(TransactionReceiptInitial()) {
    on<TransactionReceiptSubmitted>(_onTransactionReceiptSubmitted);
  }

  Future<void> _onTransactionReceiptSubmitted(TransactionReceiptSubmitted event,
      Emitter<TransactionReceiptState> emit) async {
    // Check internet connection first
    final isConnected = await ConnectivityService.hasConnection();

    if (!isConnected) {
      emit(TransactionReceiptFailure(
          "You're offline. Please check your internet connection and try again."));
      return;
    }
    emit(TransactionReceiptLoading());

    try {
      final response =
          await authService.transactionReceipt(event.transactionDetails);

      // Ensure the response is not null
      if (response != null &&
          response.resMessage.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(TransactionReceiptSuccess(
            response.resMessage.errorDescription, response));
      } else if (response != null) {
        // Search failed with error description
        emit(TransactionReceiptFailure(response.resMessage.errorDescription));
      } else {
        // Null response scenario
        emit(TransactionReceiptFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(TransactionReceiptFailure(
          'An error occurred while getting transaction receipt'));
    }
  }
}
