import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/customer_registration_models/GdbCustRtlAppRequest.dart';

abstract class CustomerSearchState {}

class CustomerSearchInitial extends CustomerSearchState {}

class CustomerSearchLoading extends CustomerSearchState {}

class CustomerSearchSuccess extends CustomerSearchState {
  final GdbCustRtlAppRequest2 gdbMerchantDisProductPurRequest;
  CustomerSearchSuccess(this.gdbMerchantDisProductPurRequest);
}

class CustomerSearchFailure extends CustomerSearchState {
  final String? error;
  CustomerSearchFailure(this.error);
}
