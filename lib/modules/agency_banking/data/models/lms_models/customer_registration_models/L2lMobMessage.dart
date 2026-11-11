class L2lMobMessage {
  String? code;
  String? message;
  String? type;
  String dispType;
  bool isError;
  String subject;
  List<String>? dataArr;

  L2lMobMessage({
    this.code,
    this.message,
    this.type,
    this.dispType = 'ALERT',
    this.isError = false,
    this.subject = 'Alert',
    this.dataArr,
  });

  L2lMobMessage.withMessage(this.message, {this.isError = false})
      : code = null,
        type = null,
        dispType = 'ALERT',
        subject = 'Alert',
        dataArr = null;

  factory L2lMobMessage.fromJson(Map<String, dynamic> json) {
    return L2lMobMessage(
      code: json['code'],
      message: json['message'],
      type: json['type'],
      dispType: json['dispType'] ?? 'ALERT',
      isError: json['isError'] ?? false,
      subject: json['subject'] ?? 'Alert',
      dataArr: (json['dataArr'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'type': type,
      'dispType': dispType,
      'isError': isError,
      'subject': subject,
      'dataArr': dataArr,
    };
  }


}