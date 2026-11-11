import 'dart:convert';

KycVerifyOtpResponseModel kycVerifyOtpResponseMOdelFromJson(String str) => KycVerifyOtpResponseModel.fromJson(json.decode(str));

String kycVerifyOtpResponseMOdelToJson(KycVerifyOtpResponseModel data) => json.encode(data.toJson());

class KycVerifyOtpResponseModel {
    dynamic reqSecureKey;
    dynamic addiParams;
    ChMessage chMessage;
    dynamic urlDecision;
    String otpId;
    dynamic otp;
    dynamic expiryTime;
    dynamic attemptRemaining;
    dynamic validityMinutes;
    String status;
    dynamic lockedTime;

    KycVerifyOtpResponseModel({
        required this.reqSecureKey,
        required this.addiParams,
        required this.chMessage,
        required this.urlDecision,
        required this.otpId,
        required this.otp,
        required this.expiryTime,
        required this.attemptRemaining,
        required this.validityMinutes,
        required this.status,
        required this.lockedTime,
    });

    factory KycVerifyOtpResponseModel.fromJson(Map<String, dynamic> json) => KycVerifyOtpResponseModel(
        reqSecureKey: json["reqSecureKey"],
        addiParams: json["addiParams"],
        chMessage: ChMessage.fromJson(json["chMessage"]),
        urlDecision: json["urlDecision"],
        otpId: json["otpId"],
        otp: json["otp"],
        expiryTime: json["expiryTime"],
        attemptRemaining: json["attemptRemaining"],
        validityMinutes: json["validityMinutes"],
        status: json["status"],
        lockedTime: json["lockedTime"],
    );

    Map<String, dynamic> toJson() => {
        "reqSecureKey": reqSecureKey,
        "addiParams": addiParams,
        "chMessage": chMessage.toJson(),
        "urlDecision": urlDecision,
        "otpId": otpId,
        "otp": otp,
        "expiryTime": expiryTime,
        "attemptRemaining": attemptRemaining,
        "validityMinutes": validityMinutes,
        "status": status,
        "lockedTime": lockedTime,
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
