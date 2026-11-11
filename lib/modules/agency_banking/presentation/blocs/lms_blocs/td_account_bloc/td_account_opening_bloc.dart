
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/td_account_bloc/td_account_opening_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/td_account_bloc/td_account_opening_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/services/AuthService.dart';


class TdAccountOpeningBloc extends Bloc<TdAccountOpeningEvent, TdAccountOpeningState> {
  final AuthService authService;

  TdAccountOpeningBloc(this.authService) : super(TdAccountOpeningInitial()) {
    on<TdAccountOpeningSubmitted>(_onTdAccountOpeningSubmitted);
  }

  Future<void> _onTdAccountOpeningSubmitted(TdAccountOpeningSubmitted event,
      Emitter<TdAccountOpeningState> emit) async {
    emit(TdAccountOpeningLoading());

    try {

      final response = await authService.td_account_opening(event.tdAccOpeningRequest);
      if (response != null && response.responseCode == "AB-ATTEMPT-100")
      {
        emit(TdAccountOpeningSuccess(response));
      }
      else if (response != null && response.responseCode!="AB-ATTEMPT-100") {
        emit(TdAccountOpeningFailure(response.responseMessage));
      }
      else {
        // Null response scenario
        emit(TdAccountOpeningFailure('No data returned from the search'));
      }
    } catch (e) {
      // Error handling during search
      emit(TdAccountOpeningFailure('An error occurred during the account search'));
    }
  }
}