import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/emi_calculation_models/GdbChAppStatusReqRes.dart';

abstract class ApplicationStatusState {}

class ApplicationStatusInitial extends ApplicationStatusState {}

class ApplicationStatusLoading extends ApplicationStatusState {}

class ApplicationStatusSuccess extends ApplicationStatusState {
  final String? message;
  final GdbChAppStatusReqRes appStatusReqRes;
  ApplicationStatusSuccess(this.message,this.appStatusReqRes);
}

class ApplicationStatusFailure extends ApplicationStatusState {
  final String? error;
  ApplicationStatusFailure(this.error);
}