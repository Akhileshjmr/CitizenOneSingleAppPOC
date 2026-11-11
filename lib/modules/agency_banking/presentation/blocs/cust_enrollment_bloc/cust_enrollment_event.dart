
import 'package:citizenone_app/modules/agency_banking/data/models/lov_models/AbLovsMaster.dart';

import '../../../data/models/CommCustEnrollment.dart';
import '../../../data/models/CommKycUpload.dart';

abstract class CustEnrollmentEvent {}

class CustEnrollmentSubmitted extends CustEnrollmentEvent
{
  final CommCustEnrollment custEnroll;
  CustEnrollmentSubmitted(this.custEnroll);
}
