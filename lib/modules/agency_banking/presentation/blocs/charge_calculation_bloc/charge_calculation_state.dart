
import 'package:citizenone_app/modules/agency_banking/data/models/CommWalletTransaction.dart';

import '../../../data/models/CommCustEnrollment.dart';
import '../../../data/models/CommFeeCalulation.dart';

abstract class ChargeCalculationState {}

class ChargeCalculationInitial extends ChargeCalculationState {}

class ChargeCalculationLoading extends ChargeCalculationState {}

class ChargeCalculationSuccess extends ChargeCalculationState {
  final CommFeeCalculation user;
  final String responseMessage;
  final String responseCode;
  ChargeCalculationSuccess(this.user, this.responseMessage, this.responseCode);
}

class ChargeCalculationFailure extends ChargeCalculationState {
  late final String error;
  ChargeCalculationFailure(this.error);
}
