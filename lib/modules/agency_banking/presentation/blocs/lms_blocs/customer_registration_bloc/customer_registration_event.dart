import '../../../../data/models/lms_models/customer_registration_models/GdbCustRtlAppRequest2.dart';

abstract class CustomerRegistrationEvent {}

class CustomerRegistrationSubmitted<T> extends CustomerRegistrationEvent {
  final GdbCustRtlAppRequest<T> gdbCustRtlAppRequest;

  CustomerRegistrationSubmitted(this.gdbCustRtlAppRequest);
}
