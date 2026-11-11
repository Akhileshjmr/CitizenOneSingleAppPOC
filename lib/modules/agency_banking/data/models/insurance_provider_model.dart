class InsuranceProviderResponseModel {
  final String? reqSecureKey;
  final dynamic addiParams;
  final ChMessage? chMessage;
  final dynamic urlDecision;
  final List<ProviderModel> providers;

  InsuranceProviderResponseModel({
    this.reqSecureKey,
    this.addiParams,
    this.chMessage,
    this.urlDecision,
    required this.providers,
  });

  factory InsuranceProviderResponseModel.fromJson(Map<String, dynamic> json) {
    return InsuranceProviderResponseModel(
      reqSecureKey: json['reqSecureKey'] as String?,
      addiParams: json['addiParams'],
      chMessage: json['chMessage'] != null
          ? ChMessage.fromJson(json['chMessage'] as Map<String, dynamic>)
          : null,
      urlDecision: json['urlDecision'],
      providers: (json['providers'] as List<dynamic>?)
              ?.map((e) => ProviderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reqSecureKey': reqSecureKey,
      'addiParams': addiParams,
      'chMessage': chMessage?.toJson(),
      'urlDecision': urlDecision,
      'providers': providers.map((e) => e.toJson()).toList(),
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

class ProviderModel {
  final String? vendorName;
  final String? vendorCode;
  final String? vendorDesc;
  final String? vendorLogo;
  final String? vendorKey;
  final String? vendorMob;

  ProviderModel({
    this.vendorName,
    this.vendorCode,
    this.vendorDesc,
    this.vendorLogo,
    this.vendorKey,
    this.vendorMob,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      vendorName: json['vendorName'] as String?,
      vendorCode: json['vendorCode'] as String?,
      vendorDesc: json['vendorDesc'] as String?,
      vendorLogo: json['vendorLogo'] as String?,
      vendorKey: json['vendorKey'] as String?,
      vendorMob: json['vendorMob'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendorName': vendorName,
      'vendorCode': vendorCode,
      'vendorDesc': vendorDesc,
      'vendorLogo': vendorLogo,
      'vendorKey': vendorKey,
      'vendorMob': vendorMob,
    };
  }
}

class InsuranceProvider {
  String vendorName;
  String vendorCode;
  String vendorDesc;
  String vendorLogo;
  String vendorKey;
  String vendorMob;

  InsuranceProvider({
    required this.vendorName,
    required this.vendorCode,
    required this.vendorDesc,
    required this.vendorLogo,
    required this.vendorKey,
    required this.vendorMob,
  });

  factory InsuranceProvider.fromJson(Map<String, dynamic> json) =>
      InsuranceProvider(
        vendorName: json["vendorName"],
        vendorCode: json["vendorCode"],
        vendorDesc: json["vendorDesc"],
        vendorLogo: json["vendorLogo"],
        vendorKey: json["vendorKey"],
        vendorMob: json["vendorMob"],
      );

  Map<String, dynamic> toJson() => {
        "vendorName": vendorName,
        "vendorCode": vendorCode,
        "vendorDesc": vendorDesc,
        "vendorLogo": vendorLogo,
        "vendorKey": vendorKey,
        "vendorMob": vendorMob,
      };
}
