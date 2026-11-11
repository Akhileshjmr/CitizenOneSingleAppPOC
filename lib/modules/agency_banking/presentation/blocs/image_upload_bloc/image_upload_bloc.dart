
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/AuthService.dart';
import 'image_upload_event.dart';
import 'image_upload_state.dart';

class CustImageUploadBloc extends Bloc<CustImageUploadEvent, CustImageUploadState> {
  final AuthService authService;
  CustImageUploadBloc(this.authService) : super(CustImageUploadInitial()) {
    on<CustImageUploadSubmitted>(_onCustImageUploadSubmitted);
  }

  Future<void> _onCustImageUploadSubmitted(
      CustImageUploadSubmitted event, Emitter<CustImageUploadState> emit) async {
    emit(CustImageUploadLoading());

    try {
      final response = await authService.image_upload(event.imageSignList);

      // Ensure the response is not null
      if (response != null && response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(CustImageUploadSuccess(response.resMessage!.errorDescription,response));

      } else if (response != null) {
        // Search failed with error description
        emit(CustImageUploadFailure(response.resMessage!.errorDescription));


        //

      } else {
        // Null response scenario
        emit(CustImageUploadFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(CustImageUploadFailure('An error occurred during the account search'));
    }
  }
}