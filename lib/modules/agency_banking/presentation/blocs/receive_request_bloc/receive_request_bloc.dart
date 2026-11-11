
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/receive_request_bloc/receive_request_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/receive_request_bloc/receive_request_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/request_money_bloc/request_money_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/request_money_bloc/request_money_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/AuthService.dart';

class ReceiveRequestBloc extends Bloc<ReceiveRequestEvent, ReceiveRequestState> {
  final AuthService authService;

  ReceiveRequestBloc(this.authService) : super(ReceiveRequestInitial()) {
    on<ReceiveRequestSubmitted>(_onReceiveRequestSubmitted);
  }

  Future<void> _onReceiveRequestSubmitted(ReceiveRequestSubmitted event,
      Emitter<ReceiveRequestState> emit) async {
    emit(ReceiveRequestLoading());

    try {
      final response = await authService.receive_request(
          event.requestList);
      if (response != null &&
          response.resMessage?.errorCode == "AB-ATTEMPT-100")
      {
        emit(ReceiveRequestSuccess(response.resMessage!.errorDescription, response));
      } else if (response != null)
      {
        emit(ReceiveRequestFailure(response.resMessage!.errorDescription));
      } else
      {
        emit(ReceiveRequestFailure('No data returned from the search'));
      }
    } catch (e)
    {
      emit(ReceiveRequestFailure('An error occurred during the account search'));
    }
  }
}
