// To parse this JSON data, do
//
//     final kycOtpResponseModel = kycOtpResponseModelFromJson(jsonString);

import 'dart:convert';

KycOtpResponseModel kycOtpResponseModelFromJson(String str) => KycOtpResponseModel.fromJson(json.decode(str));

String kycOtpResponseModelToJson(KycOtpResponseModel data) => json.encode(data.toJson());

class KycOtpResponseModel {
    dynamic reqSecureKey;
    dynamic addiParams;
    ChMessage chMessage;
    dynamic urlDecision;
    String otpId;
    String otp;
    bool isDefaultOtp;
    dynamic expiryTime;
    int attemptRemaining;
    int validityTime;
    String status;
    dynamic lockedTime;
    String channel;
    bool isLocked;
    int resentCount;

    KycOtpResponseModel({
        required this.reqSecureKey,
        required this.addiParams,
        required this.chMessage,
        required this.urlDecision,
        required this.otpId,
        required this.otp,
        required this.isDefaultOtp,
        required this.expiryTime,
        required this.attemptRemaining,
        required this.validityTime,
        required this.status,
        required this.lockedTime,
        required this.channel,
        required this.isLocked,
        required this.resentCount,
    });

    factory KycOtpResponseModel.fromJson(Map<String, dynamic> json) => KycOtpResponseModel(
        reqSecureKey: json["reqSecureKey"],
        addiParams: json["addiParams"],
        chMessage: ChMessage.fromJson(json["chMessage"]),
        urlDecision: json["urlDecision"],
        otpId: json["otpId"],
        otp: json["otp"],
        isDefaultOtp: json["isDefaultOtp"],
        expiryTime: json["expiryTime"],
        attemptRemaining: json["attemptRemaining"],
        validityTime: json["validityTime"],
        status: json["status"],
        lockedTime: json["lockedTime"],
        channel: json["channel"],
        isLocked: json["isLocked"],
        resentCount: json["resentCount"],
    );

    Map<String, dynamic> toJson() => {
        "reqSecureKey": reqSecureKey,
        "addiParams": addiParams,
        "chMessage": chMessage.toJson(),
        "urlDecision": urlDecision,
        "otpId": otpId,
        "otp": otp,
        "isDefaultOtp": isDefaultOtp,
        "expiryTime": expiryTime,
        "attemptRemaining": attemptRemaining,
        "validityTime": validityTime,
        "status": status,
        "lockedTime": lockedTime,
        "channel": channel,
        "isLocked": isLocked,
        "resentCount": resentCount,
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
