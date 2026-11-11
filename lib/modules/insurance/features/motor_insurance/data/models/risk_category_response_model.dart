class RiskCategoryResponseModel {
  final ChMessage? chMessage;
  final List<RiskCategoryModel>? data;

  RiskCategoryResponseModel({
    this.chMessage,
    this.data,
  });

  factory RiskCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return RiskCategoryResponseModel(
      chMessage: json['chMessage'] != null
          ? ChMessage.fromJson(json['chMessage'] as Map<String, dynamic>)
          : null,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => RiskCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chMessage': chMessage?.toJson(),
      'data': data?.map((e) => e.toJson()).toList(),
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

  ChMessage({
    this.code,
    this.message,
    this.type,
    this.dispType,
    this.isError,
    this.subject,
  });

  factory ChMessage.fromJson(Map<String, dynamic> json) {
    return ChMessage(
      code: json['code'] as String?,
      message: json['message'] as String?,
      type: json['type'] as String?,
      dispType: json['dispType'] as String?,
      isError: json['isError'] as bool?,
      subject: json['subject'] as String?,
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
    };
  }
}

class RiskCategoryModel {
  final String? id;
  final String? name;
  final String? description;
  final String? iconUrl;

  RiskCategoryModel({
    this.id,
    this.name,
    this.description,
    this.iconUrl,
  });

  factory RiskCategoryModel.fromJson(Map<String, dynamic> json) {
    return RiskCategoryModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconUrl': iconUrl,
    };
  }
}
