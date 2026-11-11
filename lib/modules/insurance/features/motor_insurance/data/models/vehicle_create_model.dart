import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/vehicle_details_response_model.dart';

class VehicleCreateResponse {
  final ChMessage? chMessage;
  final VehicleData? data;

  VehicleCreateResponse({
    this.chMessage,
    this.data,
  });

  factory VehicleCreateResponse.fromJson(Map<String, dynamic> json) {
    return VehicleCreateResponse(
      chMessage: json['chMessage'] != null
          ? ChMessage.fromJson(json['chMessage'] as Map<String, dynamic>)
          : null,
      data: json['data'] != null
          ? VehicleData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chMessage': chMessage?.toJson(),
      'data': data?.toJson(),
    };
  }
}

class ChMessage {
  final String? code;
  final String? message;
  final String? type;
  final String? dispType;
  final bool? isError;
  final String? subject;
  final dynamic dataArr;

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
      code: json['code'] as String?,
      message: json['message'] as String?,
      type: json['type'] as String?,
      dispType: json['dispType'] as String?,
      isError: json['isError'] as bool?,
      subject: json['subject'] as String?,
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
