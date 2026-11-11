import 'package:citizenone_app/modules/agency_banking/data/models/lov_models/AbLovsMaster.dart';

abstract class GetLovEvent {}

class GetLovSubmitted extends GetLovEvent
{
  final AbLovsMaster GetLovRequest;
  GetLovSubmitted(this.GetLovRequest);
}
