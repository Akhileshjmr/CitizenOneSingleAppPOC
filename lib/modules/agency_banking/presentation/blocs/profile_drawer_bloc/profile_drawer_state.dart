import 'package:citizenone_app/modules/agency_banking/data/models/CommAgentDetails.dart';

abstract class ProfileDrawerState {}

class ProfileDrawerInitial extends ProfileDrawerState {}

class ProfileDrawerLoading extends ProfileDrawerState {}

class ProfileDrawerSuccess extends ProfileDrawerState {
  final CommAgentDetails agentDetails;
  ProfileDrawerSuccess(this.agentDetails);
}

class ProfileDrawerFailure extends ProfileDrawerState {
  final String error;
  ProfileDrawerFailure(this.error);
}
