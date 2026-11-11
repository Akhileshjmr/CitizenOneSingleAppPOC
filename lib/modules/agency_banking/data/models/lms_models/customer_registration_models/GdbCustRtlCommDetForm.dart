import 'GdbCustAddressForm.dart';

class GdbCustRtlCommDetForm {
  GdbCustAddressForm? primaryAddress;

  GdbCustRtlCommDetForm({this.primaryAddress});

  factory GdbCustRtlCommDetForm.fromJson(Map<String, dynamic> json) {
    return GdbCustRtlCommDetForm(
      primaryAddress: json['primaryAddress'] != null
          ? GdbCustAddressForm.fromJson(json['primaryAddress'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primaryAddress': primaryAddress?.toJson(),
    };
  }
}
