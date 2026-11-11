import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/emi_calculation_models/GdbChScoreReqRes.dart';

abstract class EligibilityScoreState {}

class EligibilityScoreInitial extends EligibilityScoreState {}

class EligibilityScoreLoading extends EligibilityScoreState {}

class EligibilityScoreSuccess extends EligibilityScoreState {
  final String? message;
  final GdbChScoreReqRes scoreReqRes;
  EligibilityScoreSuccess(this.message,this.scoreReqRes);
}

class EligibilityScoreFailure extends EligibilityScoreState {
  final String? error;
  EligibilityScoreFailure(this.error);
}