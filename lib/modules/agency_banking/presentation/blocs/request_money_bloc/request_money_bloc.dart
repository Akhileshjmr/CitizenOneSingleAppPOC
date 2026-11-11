import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/Loader.dart'; // contains LoadingCubit
import 'request_money_event.dart';
import 'request_money_state.dart';
import '../../../data/services/AuthService.dart';

class RequestMoneyBloc extends Bloc<RequestMoneyEvent, RequestMoneyState> {
  final AuthService authService;

  RequestMoneyBloc(this.authService) : super(RequestMoneyInitial()) {
    on<RequestMoneySubmitted>(_onRequestMoneySubmitted);
  }

  Future<void> _onRequestMoneySubmitted(
      RequestMoneySubmitted event,
      Emitter<RequestMoneyState> emit,
      ) async {
    try {
      final response = await authService.request_money(event.requestMoney);

      if (response != null && response.resMessage?.errorCode == "AB-ATTEMPT-100") {
        emit(RequestMoneySuccess(response.resMessage!.errorDescription, response));
      } else if (response != null) {
        emit(RequestMoneyFailure(response.resMessage!.errorDescription));
      } else {
        emit(RequestMoneyFailure('No data returned from the request'));
      }
    } catch (e) {
      emit(RequestMoneyFailure('An unexpected error occurred'));
    }
  }
}
