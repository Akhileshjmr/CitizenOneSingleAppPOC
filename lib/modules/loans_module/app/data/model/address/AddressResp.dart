import '../common/ch_message.dart';
import '../employee/employee_details.dart';
import 'AddressDet.dart';

class AddressResp {
  AddressResp({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.value,
    this.key,
    this.genDet,
    this.empDetails,
    this.addressDet,
    this.loanDetails,
    this.fields,
  });

  AddressResp.fromJson(dynamic json) {
    reqSecureKey = json['reqSecureKey'];
    addiParams = json['addiParams'];
    chMessage =
        json['chMessage'] != null
            ? ChMessage.fromJson(json['chMessage'])
            : null;
    urlDecision = json['urlDecision'];
    value = json['value'];
    key = json['key'];
    genDet = json['genDet'];
    empDetails =
        json['empDetails'] != null
            ? EmployeeDetails.fromJson(json['empDetails'])
            : null;
    addressDet =
        json['addressDet'] != null
            ? AddressDet.fromJson(json['addressDet'])
            : null;
    loanDetails = json['loanDetails'];
    fields = json['fields'];
  }
  dynamic reqSecureKey;
  dynamic addiParams;
  ChMessage? chMessage;
  dynamic urlDecision;
  dynamic value;
  String? key;
  dynamic genDet;
  EmployeeDetails? empDetails;
  AddressDet? addressDet;
  dynamic loanDetails;
  dynamic fields;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reqSecureKey'] = reqSecureKey;
    map['addiParams'] = addiParams;
    if (chMessage != null) {
      map['chMessage'] = chMessage?.toJson();
    }
    map['urlDecision'] = urlDecision;
    map['value'] = value;
    map['key'] = key;
    map['genDet'] = genDet;
    map['empDetails'] = empDetails;
    if (empDetails != null) {
      map['empDetails'] = empDetails?.toJson();
    }
    if (addressDet != null) {
      map['addressDet'] = addressDet?.toJson();
    }
    map['loanDetails'] = loanDetails;
    map['fields'] = fields;
    return map;
  }
}
