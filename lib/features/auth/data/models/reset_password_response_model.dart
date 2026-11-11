import 'change_password_response_model.dart' show ChMessage;

/// Response DTO for the agent user service `POST /password/reset`
/// endpoint. The success payload may omit the `data` field.
class ResetPasswordResponseModel {
  final ChMessage chMessage;
  final dynamic value;

  const ResetPasswordResponseModel({required this.chMessage, this.value});

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponseModel(
      chMessage: ChMessage.fromJson(
        (json['chMessage'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
      value: json['value'],
    );
  }

  bool get isSuccess => chMessage.code == 'SUCCESS' && !chMessage.isError;
}
