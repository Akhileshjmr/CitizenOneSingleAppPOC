import 'package:citizenone_app/modules/agency_banking/data/models/CommAccountRequest.dart';

abstract class AdditionalAccountState {}

class AdditionalAccountInitial extends AdditionalAccountState {}

class AdditionalAccountLoading extends AdditionalAccountState {}

class AdditionalAccountSuccess extends AdditionalAccountState {
  final String message;
  final CommAccountRequest accountRequest;
  AdditionalAccountSuccess(this.message, this.accountRequest);
}

class AdditionalAccountFailure extends AdditionalAccountState {
  final String error;
  AdditionalAccountFailure(this.error);
}
