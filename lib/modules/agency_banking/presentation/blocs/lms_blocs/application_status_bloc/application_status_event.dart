import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/emi_calculation_models/GdbChAppStatusReqRes.dart';

abstract class ApplicationStatusEvent {}

class ApplicationStatusSubmitted extends ApplicationStatusEvent {
  final GdbChAppStatusReqRes appStatusReqRes;
  ApplicationStatusSubmitted(this.appStatusReqRes);
}