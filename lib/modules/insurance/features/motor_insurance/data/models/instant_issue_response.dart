class InstantIssueResponse {
  final ChMessage? chMessage;
  final PolicyData? data;

  InstantIssueResponse({
    this.chMessage,
    this.data,
  });

  factory InstantIssueResponse.fromJson(Map<String, dynamic> json) {
    return InstantIssueResponse(
      chMessage: json['chMessage'] != null
          ? ChMessage.fromJson(json['chMessage'] as Map<String, dynamic>)
          : null,
      data: json['data'] != null
          ? PolicyData.fromJson(json['data'] as Map<String, dynamic>)
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

class PolicyData {
  final String? id;
  final String? policyNumber;
  final String? status;
  final double? grossPremium;
  final double? basicPremium;
  final double? premiumLevy;
  final double? extensionsPremium;
  final double? discountsPremium;
  final String? currency;
  final int? duration;
  final String? durationType;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? approvedDate;
  final String? clientId;
  final String? clientName;
  final String? vehicleId;
  final String? productId;
  final String? insurerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PolicyData({
    this.id,
    this.policyNumber,
    this.status,
    this.grossPremium,
    this.basicPremium,
    this.premiumLevy,
    this.extensionsPremium,
    this.discountsPremium,
    this.currency,
    this.duration,
    this.durationType,
    this.startDate,
    this.endDate,
    this.approvedDate,
    this.clientId,
    this.clientName,
    this.vehicleId,
    this.productId,
    this.insurerId,
    this.createdAt,
    this.updatedAt,
  });

  factory PolicyData.fromJson(Map<String, dynamic> json) {
    return PolicyData(
      id: json['id'] as String?,
      policyNumber: json['policyNumber'] as String?,
      status: json['status'] as String?,
      grossPremium: (json['grossPremium'] as num?)?.toDouble(),
      basicPremium: (json['basicPremium'] as num?)?.toDouble(),
      premiumLevy: (json['premiumLevy'] as num?)?.toDouble(),
      extensionsPremium: (json['extensionsPremium'] as num?)?.toDouble(),
      discountsPremium: (json['discountsPremium'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      durationType: json['durationType'] as String?,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'] as String)
          : null,
      approvedDate: json['approvedDate'] != null
          ? DateTime.tryParse(json['approvedDate'] as String)
          : null,
      clientId: json['clientId'] as String?,
      clientName: json['clientName'] as String?,
      vehicleId: json['vehicleId'] as String?,
      productId: json['productId'] as String?,
      insurerId: json['insurerId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'policyNumber': policyNumber,
      'status': status,
      'grossPremium': grossPremium,
      'basicPremium': basicPremium,
      'premiumLevy': premiumLevy,
      'extensionsPremium': extensionsPremium,
      'discountsPremium': discountsPremium,
      'currency': currency,
      'duration': duration,
      'durationType': durationType,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'approvedDate': approvedDate?.toIso8601String(),
      'clientId': clientId,
      'clientName': clientName,
      'vehicleId': vehicleId,
      'productId': productId,
      'insurerId': insurerId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}