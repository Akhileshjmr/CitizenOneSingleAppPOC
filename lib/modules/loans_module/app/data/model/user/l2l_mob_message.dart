class L2lMobMessage {
  final String? code;
  final String? message;
  final String? type;
  final String? dispType;
  final bool isError;
  final String? subject;

  L2lMobMessage({
    this.code,
    this.message,
    this.type,
    this.dispType,
    this.isError = false,
    this.subject,
  });

  factory L2lMobMessage.fromJson(Map<String, dynamic> json) {
    return L2lMobMessage(
      code: json['code'] as String?,
      message: json['message'] as String?,
      type: json['type'] as String?,
      dispType: json['dispType'] as String?,
      isError: json['isError'] ?? false,
      subject: json['subject'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'message': message,
    'type': type,
    'dispType': dispType,
    'isError': isError,
    'subject': subject,
  };
}
