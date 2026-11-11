import 'package:citizenone_app/modules/agency_banking/data/models/CommAgentDetails.dart';

abstract class UserProfileEvent {}

class UserProfileSubmitted extends UserProfileEvent {
  final CommAgentDetails agentDetails;
  UserProfileSubmitted(this.agentDetails);
}
