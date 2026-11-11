import '../../../data/models/common_models/AbFcErrorType.dart';
import '../../../data/models/CommAccountRequest.dart';

abstract class AccountSearchState {}

class AccountSearchInitial extends AccountSearchState {}

class AccountSearchLoading extends AccountSearchState {}

class AccountSearchSuccess extends AccountSearchState {
  final String message;
  final CommAccountRequest commAccountRequest;
  List<AbFcErrorType>? fcError;
  AccountSearchSuccess(this.message,this.commAccountRequest,this.fcError);
}

class AccountSearchFailure extends AccountSearchState {
  final String error;
  List<AbFcErrorType>? fcError;
  AccountSearchFailure(this.error, this.fcError);
}
