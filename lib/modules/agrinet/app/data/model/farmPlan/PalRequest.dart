import 'dart:convert';

MainRequest mainRequestFromJson(String str) =>
    MainRequest.fromJson(json.decode(str));
String mainRequestToJson(MainRequest data) => json.encode(data.toJson());

class MainRequest {
  MainRequest({
    this.comReq,
    this.dob,
    this.firstName,
    this.gdbLookUpForm,
    this.gender,
    this.lastName,
    this.mailId,
    this.mobNum,
    this.secParam,
  });

  ComReq? comReq;
  String? dob;
  String? firstName;
  GdbLookUpForm? gdbLookUpForm;
  String? gender;
  String? lastName;
  String? mailId;
  String? mobNum;
  SecParam? secParam;

  factory MainRequest.fromJson(Map<String, dynamic> json) => MainRequest(
    comReq: json["comReq"] == null ? null : ComReq.fromJson(json["comReq"]),
    dob: json["dob"],
    firstName: json["firstName"],
    gdbLookUpForm:
        json["gdbLookUpForm"] == null
            ? null
            : GdbLookUpForm.fromJson(json["gdbLookUpForm"]),
    gender: json["gender"],
    lastName: json["lastName"],
    mailId: json["mailId"],
    mobNum: json["mobNum"],
    secParam:
        json["secParam"] == null ? null : SecParam.fromJson(json["secParam"]),
  );

  Map<String, dynamic> toJson() => {
    "comReq": comReq?.toJson(),
    "dob": dob,
    "firstName": firstName,
    "gdbLookUpForm": gdbLookUpForm?.toJson(),
    "gender": gender,
    "lastName": lastName,
    "mailId": mailId,
    "mobNum": mobNum,
    "secParam": secParam?.toJson(),
  };
}

class ComReq {
  ComReq({this.reqSecureKey});

  String? reqSecureKey;

  factory ComReq.fromJson(Map<String, dynamic> json) =>
      ComReq(reqSecureKey: json["reqSecureKey"]);

  Map<String, dynamic> toJson() => {"reqSecureKey": reqSecureKey};
}

class GdbLookUpForm {
  GdbLookUpForm({this.friendlyType, this.id, this.type});

  String? friendlyType;
  int? id;
  String? type;

  factory GdbLookUpForm.fromJson(Map<String, dynamic> json) => GdbLookUpForm(
    friendlyType: json["friendlyType"],
    id: json["id"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "friendlyType": friendlyType,
    "id": id,
    "type": type,
  };
}

class SecParam {
  SecParam({this.confPword, this.pwd, this.userName});

  String? confPword;
  String? pwd;
  String? userName;

  factory SecParam.fromJson(Map<String, dynamic> json) => SecParam(
    confPword: json["confPword"],
    pwd: json["pwd"],
    userName: json["userName"],
  );

  Map<String, dynamic> toJson() => {
    "confPword": confPword,
    "pwd": pwd,
    "userName": userName,
  };
}
