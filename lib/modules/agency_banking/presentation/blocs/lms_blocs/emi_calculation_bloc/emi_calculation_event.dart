import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/emi_calculation_models/L2lEmiCalculateRequest.dart';

abstract class EmiCalculationEvent {}

class EmiCalculationSubmitted extends EmiCalculationEvent {
  final L2lEmiCalculateRequest emiCalculateRequest;
  EmiCalculationSubmitted(this.emiCalculateRequest);
}