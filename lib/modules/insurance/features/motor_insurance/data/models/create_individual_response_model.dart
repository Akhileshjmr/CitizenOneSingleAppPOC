class CreateIndividualResponseModel {
  final ChMessage? chMessage;
  final CustomerData? data;

  CreateIndividualResponseModel({
    this.chMessage,
    this.data,
  });

  factory CreateIndividualResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateIndividualResponseModel(
      chMessage: json['chMessage'] == null
          ? null
          : ChMessage.fromJson(json['chMessage'] as Map<String, dynamic>),
      data: json['data'] == null
          ? null
          : CustomerData.fromJson(json['data'] as Map<String, dynamic>),
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

class CustomerData {
  final String? id;
  final String? email;
  final String? phoneNumber;
  final String? physicalAddress;
  final String? firstName;
  final String? lastName;
  final String? idNumber;
  final String? idType;
  final String? gender;
  final String? type;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomerData({
    this.id,
    this.email,
    this.phoneNumber,
    this.physicalAddress,
    this.firstName,
    this.lastName,
    this.idNumber,
    this.idType,
    this.gender,
    this.type,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json['id'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      physicalAddress: json['physicalAddress'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      idNumber: json['idNumber'] as String?,
      idType: json['idType'] as String?,
      gender: json['gender'] as String?,
      type: json['type'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phoneNumber': phoneNumber,
      'physicalAddress': physicalAddress,
      'firstName': firstName,
      'lastName': lastName,
      'idNumber': idNumber,
      'idType': idType,
      'gender': gender,
      'type': type,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
