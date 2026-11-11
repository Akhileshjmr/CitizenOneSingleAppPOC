import 'package:citizenone_app/modules/agency_banking/data/models/CommAgentDetails.dart';

abstract class ProfileDrawerEvent {}

class FetchProfileDrawerData extends ProfileDrawerEvent {
  final CommAgentDetails agentDetails;
  FetchProfileDrawerData(this.agentDetails);
}
