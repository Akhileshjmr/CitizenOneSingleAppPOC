import '../../../../data/models/lms_models/customer_registration_models/GdbCustRtlAppResponse.dart';

abstract class CustomerRegistrationState {}

class CustomerRegistrationInitial extends CustomerRegistrationState {}

class CustomerRegistrationLoading extends CustomerRegistrationState {}

class CustomerRegistrationSuccess extends CustomerRegistrationState {
  final String? message;
  final GdbCustRtlAppResponse gdbMerchantDisProductPurResponse;
  CustomerRegistrationSuccess(this.message,this.gdbMerchantDisProductPurResponse);
}

class CustomerRegistrationFailure extends CustomerRegistrationState {
  final String? error;
  CustomerRegistrationFailure(this.error);
}
