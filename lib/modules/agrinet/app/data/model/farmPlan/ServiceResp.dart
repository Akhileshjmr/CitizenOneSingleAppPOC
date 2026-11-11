// main_response.dart
import '../common/ch_message.dart';
import '../common/option.dart';

class ServiceResponse {
  final String? reqSecureKey;
  final dynamic addiParams;
  final ChMessage? chMessage;
  final dynamic urlDecision;
  final List<ServiceReq>? serviceReq;
  final dynamic tempStr;
  final ServiceReq? docs;
  final dynamic cmOtherDocs;

  ServiceResponse({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.serviceReq,
    this.tempStr,
    this.docs,
    this.cmOtherDocs,
  });

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      reqSecureKey: json['reqSecureKey'],
      addiParams: json['addiParams'],
      chMessage:
          json['chMessage'] != null
              ? ChMessage.fromJson(json['chMessage'] as Map<String, dynamic>)
              : null,
      urlDecision: json['urlDecision'],
      serviceReq:
          json['serviceReq'] != null
              ? List<ServiceReq>.from(
                (json['serviceReq'] as List).map(
                  (x) => ServiceReq.fromJson(x as Map<String, dynamic>),
                ),
              )
              : null,
      tempStr: json['tempStr'],
      docs: json["docs"] == null ? null : ServiceReq.fromJson(json["docs"]),
      cmOtherDocs: json['cmOtherDocs'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reqSecureKey': reqSecureKey,
      'addiParams': addiParams,
      'chMessage': chMessage?.toJson(),
      'urlDecision': urlDecision,
      'serviceReq': serviceReq?.map((x) => x.toJson()).toList(),
      'tempStr': tempStr,
      "docs": docs?.toJson(),
      'cmOtherDocs': cmOtherDocs,
    };
  }
}

// service_req.dart
class ServiceReq {
  final String? reqSecureKey;
  final dynamic addiParams;
  final ChMessage? chMessage;
  final dynamic urlDecision;
  final dynamic requestGenDet;
  final int? id;
  final RequestDet? requestDet;
  final dynamic docDet;
  final dynamic recomondationDet;
  final dynamic adminCommnets;
  final dynamic close;
  final dynamic closeDate;
  final String? srNumber;
  final dynamic actualCost;

  ServiceReq({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    this.requestGenDet,
    this.id,
    this.requestDet,
    this.docDet,
    this.recomondationDet,
    this.adminCommnets,
    this.close,
    this.closeDate,
    this.srNumber,
    this.actualCost,
  });

  factory ServiceReq.fromJson(Map<String, dynamic> json) {
    return ServiceReq(
      reqSecureKey: json['reqSecureKey'],
      addiParams: json['addiParams'],
      chMessage:
          json['chMessage'] != null
              ? ChMessage.fromJson(json['chMessage'] as Map<String, dynamic>)
              : null,
      urlDecision: json['urlDecision'],
      requestGenDet: json['requestGenDet'],
      id: json['id'],
      requestDet:
          json['requestDet'] != null
              ? RequestDet.fromJson(json['requestDet'] as Map<String, dynamic>)
              : null,
      docDet: json['docDet'],
      recomondationDet: json['recomondationDet'],
      adminCommnets: json['adminCommnets'],
      close: json['close'],
      closeDate: json['closeDate'],
      srNumber: json['srNumber'],
      actualCost: json['actualCost'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reqSecureKey': reqSecureKey,
      'addiParams': addiParams,
      'chMessage': chMessage?.toJson(),
      'urlDecision': urlDecision,
      'requestGenDet': requestGenDet,
      'id': id,
      'requestDet': requestDet?.toJson(),
      'docDet': docDet,
      'recomondationDet': recomondationDet,
      'adminCommnets': adminCommnets,
      'close': close,
      'closeDate': closeDate,
      'srNumber': srNumber,
      'actualCost': actualCost,
    };
  }
}

// request_det.dart
class RequestDet {
  final dynamic raisedBy;
  final Option? serviceType;
  final Option? relatedTo;
  final dynamic enquiryDetail;
  final int? dueDate;
  final Option? status;
  final dynamic comments;
  final dynamic estimatedCost;
  final dynamic reviveRequired;

  RequestDet({
    this.raisedBy,
    this.serviceType,
    this.relatedTo,
    this.enquiryDetail,
    this.dueDate,
    this.status,
    this.comments,
    this.estimatedCost,
    this.reviveRequired,
  });

  factory RequestDet.fromJson(Map<String, dynamic> json) {
    return RequestDet(
      raisedBy: json['raisedBy'],
      serviceType:
          json['serviceType'] != null
              ? Option.fromJson(json['serviceType'] as Map<String, dynamic>)
              : null,
      relatedTo:
          json['relatedTo'] != null
              ? Option.fromJson(json['relatedTo'] as Map<String, dynamic>)
              : null,
      enquiryDetail: json['enquiryDetail'],
      dueDate: json['dueDate'],
      status:
          json['status'] != null
              ? Option.fromJson(json['status'] as Map<String, dynamic>)
              : null,
      comments: json['comments'],
      estimatedCost: json['estimatedCost'],
      reviveRequired: json['reviveRequired'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'raisedBy': raisedBy,
      'serviceType': serviceType?.toJson(),
      'relatedTo': relatedTo?.toJson(),
      'enquiryDetail': enquiryDetail,
      'dueDate': dueDate,
      'status': status?.toJson(),
      'comments': comments,
      'estimatedCost': estimatedCost,
      'reviveRequired': reviveRequired,
    };
  }
}
