
import '../../../data/models/CommCustEnrollment.dart';

abstract class CustEnrollmentState {}

class CustEnrollmentInitial extends CustEnrollmentState {}

class CustEnrollmentLoading extends CustEnrollmentState {}

class CustEnrollmentSuccess extends CustEnrollmentState {
  final CommCustEnrollment user;
  final String responseMessage;
  final String responseCode;
  CustEnrollmentSuccess(this.user, this.responseMessage, this.responseCode);
}

class CustEnrollmentFailure extends CustEnrollmentState {
  final String error;
  CustEnrollmentFailure(this.error);
}
