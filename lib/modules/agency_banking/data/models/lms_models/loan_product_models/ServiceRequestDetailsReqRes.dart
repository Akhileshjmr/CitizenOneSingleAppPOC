import '../customer_registration_models/L2lMobMessage.dart';
import 'ServiceRequestDetls.dart';

class ServiceRequestDetailsReqRes {
  String? reqSecureKey;
  L2lMobMessage? chMessage;
  String? serviceReqType;
  List<ServiceRequestDetls>? lstServiceRequest;

  ServiceRequestDetailsReqRes({
    this.reqSecureKey,
    this.chMessage,
    this.serviceReqType,
    this.lstServiceRequest,
  });

  factory ServiceRequestDetailsReqRes.fromJson(Map<String, dynamic> json) {
    return ServiceRequestDetailsReqRes(
      reqSecureKey: json['reqSecureKey'],
      chMessage: json['chMessage'] != null
          ? L2lMobMessage.fromJson(json['chMessage'])
          : null,
      serviceReqType: json['serviceReqType'],
      lstServiceRequest: (json['lstServiceRequest'] as List<dynamic>?)
          ?.map((e) => ServiceRequestDetls.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reqSecureKey': reqSecureKey,
      'chMessage': chMessage?.toJson(),
      'serviceReqType': serviceReqType,
      'lstServiceRequest':
      lstServiceRequest?.map((e) => e.toJson()).toList(),
    };
  }
}



