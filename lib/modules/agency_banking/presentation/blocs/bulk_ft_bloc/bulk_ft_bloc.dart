import 'package:citizenone_app/modules/agency_banking/presentation/blocs/bulk_ft_bloc/bulk_ft_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/bulk_ft_bloc/bulk_ft_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/AuthService.dart';

class BulkFtBloc extends Bloc<BulkFtEvent, BulkFtState> {
  final AuthService authService;

  BulkFtBloc(this.authService) : super(BulkFtInitial()) {
    on<BulkFtSubmitted>(_onBulkFtSubmitted);
  }

  Future<void> _onBulkFtSubmitted(BulkFtSubmitted event,
      Emitter<BulkFtState> emit) async {
    emit(BulkFtLoading());

    try {
      final response = await authService.bulk_ft(event.excelDataUpload);

      // Ensure the response is not null
      if (response != null &&
          response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        // Successful search
        emit(BulkFtSuccess(response.resMessage!.errorDescription, response));
      } else if (response != null) {
        // Search failed with error description
        emit(BulkFtFailure(response.resMessage!.errorDescription));
      } else {
        // Null response scenario
        emit(BulkFtFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(BulkFtFailure('An error occurred while uploading bulk FT'));
    }
  }
}
