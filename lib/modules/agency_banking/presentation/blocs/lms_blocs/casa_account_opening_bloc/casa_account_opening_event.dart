import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/casa_account_models/CasaAccountCreateRequest.dart';

abstract class CasaAccountOpeningEvent {}

class CasaAccountOpeningSubmitted extends CasaAccountOpeningEvent {
  final CasaAccountCreateRequest casaAccountCreateRequest;
  CasaAccountOpeningSubmitted(this.casaAccountCreateRequest);
}