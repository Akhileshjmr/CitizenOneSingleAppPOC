/// Response DTO for the agent user service `POST /password/change`
/// endpoint. Mirrors the wire contract: a `chMessage` envelope plus
/// an optional `value` payload.
class ChangePasswordResponseModel {
  final ChMessage chMessage;
  final dynamic value;

  const ChangePasswordResponseModel({required this.chMessage, this.value});

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponseModel(
      chMessage: ChMessage.fromJson(
        (json['chMessage'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
      value: json['value'],
    );
  }

  bool get isSuccess => chMessage.code == 'SUCCESS';
}

class ChMessage {
  final String code;
  final String message;
  final String type;
  final String dispType;
  final bool isError;
  final String? subject;
  final List<dynamic>? dataArr;

  const ChMessage({
    required this.code,
    required this.message,
    required this.type,
    required this.dispType,
    required this.isError,
    this.subject,
    this.dataArr,
  });

  factory ChMessage.fromJson(Map<String, dynamic> json) => ChMessage(
    code: json['code'] as String? ?? '',
    message: json['message'] as String? ?? '',
    type: json['type'] as String? ?? '',
    dispType: json['dispType'] as String? ?? '',
    isError: json['isError'] as bool? ?? false,
    subject: json['subject'] as String?,
    dataArr: json['dataArr'] as List<dynamic>?,
  );
}
