class ChMessage {
  String? code;
  String? message;
  String? type;
  String? dispType;
  bool? isError;
  String? subject;
  dynamic dataArr;

  ChMessage({
    this.code,
    this.message,
    this.type,
    this.dispType,
    this.isError,
    this.subject,
    this.dataArr,
  });

  factory ChMessage.fromJson(Map<String, dynamic> json) {
    return ChMessage(
      code: json['code'],
      message: json['message'],
      type: json['type'],
      dispType: json['dispType'],
      isError: json['isError'],
      subject: json['subject'],
      dataArr: json['dataArr'],
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
