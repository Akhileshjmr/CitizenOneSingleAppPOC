import '../../../../data/models/lms_models/customer_registration_models/GdbCustSearchRequest.dart';

abstract class CustomerSearchEvent {}

class CustomerSearchSubmitted extends CustomerSearchEvent {
  final GdbCustSearchRequest gdbCustSearchRequest;
  CustomerSearchSubmitted(this.gdbCustSearchRequest);
}
