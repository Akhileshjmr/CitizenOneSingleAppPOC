import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_receive_payment_bloc/wallet_receive_payment_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_receive_payment_bloc/wallet_receive_payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/AuthService.dart';

class WalletReceivePaymentBloc extends Bloc<WalletReceivePaymentEvent, WalletReceivePaymentState> {
  final AuthService authService;
  WalletReceivePaymentBloc(this.authService) : super(WalletReceivePaymentInitial()) {
    on<WalletReceivePaymentSubmitted>(_onWalletReceivePaymentSubmitted);
  }

  Future<void> _onWalletReceivePaymentSubmitted(
      WalletReceivePaymentSubmitted event, Emitter<WalletReceivePaymentState> emit) async {
    emit(WalletReceivePaymentLoading());

    try {
      final response = await authService.wallet_receive_payment(event.commWalletTransaction);

      // Ensure the response is not null
      if (response != null && response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(WalletReceivePaymentSuccess(response.resMessage!.errorDescription,response));

      } else if (response != null) {
        // Search failed with error description
        emit(WalletReceivePaymentFailure(response.resMessage!.errorDescription));

      } else {
        // Null response scenario
        emit(WalletReceivePaymentFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(WalletReceivePaymentFailure('An error occurred during the receiving payment'));
    }
  }
}