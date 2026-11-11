import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/AuthService.dart';
import 'bulk_wallet_registration_event.dart';
import 'bulk_wallet_registration_state.dart';

class BulkWalletRegistrationBloc extends Bloc<BulkWalletRegistrationEvent, BulkWalletRegistrationState> {
  final AuthService authService;

  BulkWalletRegistrationBloc(this.authService) : super(BulkWalletRegistrationInitial()) {
    on<BulkWalletRegistrationSubmitted>(_onBulkWalletRegistrationSubmitted);
  }

  Future<void> _onBulkWalletRegistrationSubmitted(BulkWalletRegistrationSubmitted event,
      Emitter<BulkWalletRegistrationState> emit) async {
    emit(BulkWalletRegistrationLoading());

    try {
      final response = await authService.bulk_wallet(event.excelDataUpload);

      // Ensure the response is not null
      if (response != null &&
          response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(BulkWalletRegistrationSuccess(response.resMessage!.errorDescription, response));
      } else if (response != null) {
        // Search failed with error description
        emit(BulkWalletRegistrationFailure(response.resMessage!.errorDescription));
      } else {
        // Null response scenario
        emit(BulkWalletRegistrationFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(BulkWalletRegistrationFailure('An error occurred while uploading bulk wallet'));
    }
  }
}