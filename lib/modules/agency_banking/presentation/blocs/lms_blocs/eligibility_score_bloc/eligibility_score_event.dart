import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/emi_calculation_models/GdbChScoreReqRes.dart';

abstract class EligibilityScoreEvent {}

class EligibilityScoreSubmitted extends EligibilityScoreEvent {
  final GdbChScoreReqRes scoreReqRes;
  EligibilityScoreSubmitted(this.scoreReqRes);
}