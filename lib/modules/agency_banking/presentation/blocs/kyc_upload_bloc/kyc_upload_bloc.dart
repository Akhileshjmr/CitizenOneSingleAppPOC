import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'kyc_upload_event.dart';
import 'kyc_upload_state.dart';

class KycUploadBloc extends Bloc<KycUploadEvent, KycUploadState> {
  final AuthService authService;

  KycUploadBloc(this.authService) : super(KycUploadInitial()) {
    on<KycUploadSubmitted>(_KycUploadSubmitted);
  }

  Future<void> _KycUploadSubmitted(
      KycUploadSubmitted event, Emitter<KycUploadState> emit) async {
    emit(KycUploadLoading());

    try {
      final lovResponse = await authService.upload_kyc(event.kycUpload);

      // Check if the response is successful
      if (lovResponse != null && lovResponse.resMessage.errorCode == "AB-ATTEMPT-100") {
        emit(KycUploadSuccess(
          lovResponse,
          lovResponse.resMessage.errorDescription,
          lovResponse.resMessage.errorCode,
        ));
      } else {
        emit(KycUploadFailure(lovResponse?.resMessage.errorDescription ?? "Unknown error"));
      }
    } catch (e) {
      emit(KycUploadFailure('An error occurred: ${e.toString()}'));
    }
  }
}
