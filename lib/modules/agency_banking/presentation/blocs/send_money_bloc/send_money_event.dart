import 'package:citizenone_app/modules/agency_banking/data/models/CommTransaction.dart';

abstract class SendMoneyEvent {}

class SendMoneySubmitted extends SendMoneyEvent {
  final CommTransaction accountTransaction;
  SendMoneySubmitted(this.accountTransaction);
}
