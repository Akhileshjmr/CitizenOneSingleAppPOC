// To parse this JSON data, do
//
//     final submitKycResponseModel = submitKycResponseModelFromJson(jsonString);

import 'dart:convert';

SubmitKycResponseModel submitKycResponseModelFromJson(String str) => SubmitKycResponseModel.fromJson(json.decode(str));

String submitKycResponseModelToJson(SubmitKycResponseModel data) => json.encode(data.toJson());

class SubmitKycResponseModel {
    dynamic reqSecureKey;
    dynamic addiParams;
    ChMessage chMessage;
    dynamic urlDecision;

    SubmitKycResponseModel({
        required this.reqSecureKey,
        required this.addiParams,
        required this.chMessage,
        required this.urlDecision,
    });

    factory SubmitKycResponseModel.fromJson(Map<String, dynamic> json) => SubmitKycResponseModel(
        reqSecureKey: json["reqSecureKey"],
        addiParams: json["addiParams"],
        chMessage: ChMessage.fromJson(json["chMessage"]),
        urlDecision: json["urlDecision"],
    );

    Map<String, dynamic> toJson() => {
        "reqSecureKey": reqSecureKey,
        "addiParams": addiParams,
        "chMessage": chMessage.toJson(),
        "urlDecision": urlDecision,
    };
}

class ChMessage {
    String code;
    String message;
    String type;
    String dispType;
    bool isError;
    String subject;
    dynamic dataArr;

    ChMessage({
        required this.code,
        required this.message,
        required this.type,
        required this.dispType,
        required this.isError,
        required this.subject,
        required this.dataArr,
    });

    factory ChMessage.fromJson(Map<String, dynamic> json) => ChMessage(
        code: json["code"],
        message: json["message"],
        type: json["type"],
        dispType: json["dispType"],
        isError: json["isError"],
        subject: json["subject"],
        dataArr: json["dataArr"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "type": type,
        "dispType": dispType,
        "isError": isError,
        "subject": subject,
        "dataArr": dataArr,
    };
}
