import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/emi_calculation_models/L2lEmiCalculateResponse.dart';

abstract class EmiCalculationState {}

class EmiCalculationInitial extends EmiCalculationState {}

class EmiCalculationLoading extends EmiCalculationState {}

class EmiCalculationSuccess extends EmiCalculationState {
  final String? message;
  final L2lEmiCalculateResponse emiCalculateResponse;
  EmiCalculationSuccess(this.message,this.emiCalculateResponse);
}

class EmiCalculationFailure extends EmiCalculationState {
  final String? error;
  EmiCalculationFailure(this.error);
}