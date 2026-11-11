import 'package:citizenone_app/modules/agency_banking/data/models/CommWalletTransaction.dart';

abstract class ChargeCalculationEvent {}

class ChargeCalculationSubmitted extends ChargeCalculationEvent {
  final CommWalletTransaction chargeCal;
  ChargeCalculationSubmitted(this.chargeCal);
}
