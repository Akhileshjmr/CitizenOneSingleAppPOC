import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/casa_account_models/CasaAccountCreateResponse.dart';

abstract class CasaAccountOpeningState {}

class CasaAccountOpeningInitial extends CasaAccountOpeningState {}

class CasaAccountOpeningLoading extends CasaAccountOpeningState {}

class CasaAccountOpeningSuccess extends CasaAccountOpeningState {
  final String? message;
  final CasaAccountCreateResponse casaAccountCreateResponse;
  CasaAccountOpeningSuccess(this.message,this.casaAccountCreateResponse);
}

class CasaAccountOpeningFailure extends CasaAccountOpeningState {
  final String? error;
  CasaAccountOpeningFailure(this.error);
}