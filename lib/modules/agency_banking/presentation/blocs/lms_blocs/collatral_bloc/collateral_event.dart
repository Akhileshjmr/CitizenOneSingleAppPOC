
import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/loan_product_models/CollateralDetailsReqRes.dart';

abstract class CollateralEvent {}

class CollateralSubmitted extends CollateralEvent {
  final CollateralDetailsReqRes req;
  CollateralSubmitted(this.req);
}