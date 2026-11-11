import 'package:citizenone_app/modules/agency_banking/data/models/lov_models/AbLovsMaster.dart';

abstract class GetLovState {}

class GetLovInitial extends GetLovState {}

class GetLovLoading extends GetLovState {}

class GetLovSuccess extends GetLovState {
  final AbLovsMaster user;
  final String responseMessage;
  final String responseCode;
  GetLovSuccess(this.user, this.responseMessage, this.responseCode);
}

class GetLovFailure extends GetLovState {
  final String error;
  GetLovFailure(this.error);
}