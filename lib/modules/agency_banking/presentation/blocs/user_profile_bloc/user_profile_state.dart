import 'package:citizenone_app/modules/agency_banking/data/models/CommAgentDetails.dart';

abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileSuccess extends UserProfileState {
  final String message;
  final CommAgentDetails agentDetails;
  UserProfileSuccess(this.message, this.agentDetails);
}

class UserProfileFailure extends UserProfileState {
  final String error;
  UserProfileFailure(this.error);
}
