class ChMessage {
  ChMessage({
      this.code, 
      this.message, 
      this.type, 
      this.dispType, 
      this.isError, 
      this.subject, 
      this.dataArr,});

  ChMessage.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    type = json['type'];
    dispType = json['dispType'];
    isError = json['isError'];
    subject = json['subject'];
    dataArr = json['dataArr'];
  }
  String? code;
  String? message;
  String? type;
  String? dispType;
  bool? isError;
  String? subject;
  dynamic dataArr;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    map['type'] = type;
    map['dispType'] = dispType;
    map['isError'] = isError;
    map['subject'] = subject;
    map['dataArr'] = dataArr;
    return map;
  }

}