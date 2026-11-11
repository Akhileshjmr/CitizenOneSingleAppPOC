import 'package:citizenone_app/modules/agency_banking/data/models/CommAccountRequest.dart';

abstract class AdditionalAccountEvent {}

class AdditionalAccountSubmitted extends AdditionalAccountEvent {
  final CommAccountRequest accountRequest;
  AdditionalAccountSubmitted(this.accountRequest);
}
