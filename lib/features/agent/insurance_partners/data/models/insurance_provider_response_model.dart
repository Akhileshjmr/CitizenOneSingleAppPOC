class InsuranceProviderResponseModel {
  final InsuranceResponseMessageModel message;
  final List<InsuranceProviderModel> providers;
  final bool hasProvidersField;

  const InsuranceProviderResponseModel({
    required this.message,
    required this.providers,
    required this.hasProvidersField,
  });

  factory InsuranceProviderResponseModel.fromJson(Map<String, dynamic> json) {
    final rawProviders = json['providers'];
    return InsuranceProviderResponseModel(
      message: InsuranceResponseMessageModel.fromJson(
        (json['chMessage'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      providers: rawProviders is List
          ? rawProviders
                .whereType<Map>()
                .map(
                  (provider) => InsuranceProviderModel.fromJson(
                    provider.cast<String, dynamic>(),
                  ),
                )
                .toList(growable: false)
          : const [],
      hasProvidersField: rawProviders is List,
    );
  }

  bool get isSuccess => message.code == 'SUCCESS' && !message.isError;
}

class InsuranceResponseMessageModel {
  final String code;
  final String message;
  final bool isError;

  const InsuranceResponseMessageModel({
    required this.code,
    required this.message,
    required this.isError,
  });

  factory InsuranceResponseMessageModel.fromJson(Map<String, dynamic> json) =>
      InsuranceResponseMessageModel(
        code: json['code'] as String? ?? '',
        message: json['message'] as String? ?? '',
        isError: json['isError'] as bool? ?? false,
      );
}

class InsuranceProviderModel {
  final String? vendorName;
  final String? vendorCode;
  final String? vendorDesc;
  final String? vendorLogo;
  final String? vendorKey;
  final String? vendorMob;

  const InsuranceProviderModel({
    this.vendorName,
    this.vendorCode,
    this.vendorDesc,
    this.vendorLogo,
    this.vendorKey,
    this.vendorMob,
  });

  factory InsuranceProviderModel.fromJson(Map<String, dynamic> json) =>
      InsuranceProviderModel(
        vendorName: json['vendorName'] as String?,
        vendorCode: json['vendorCode'] as String?,
        vendorDesc: json['vendorDesc'] as String?,
        vendorLogo: json['vendorLogo'] as String?,
        vendorKey: json['vendorKey'] as String?,
        vendorMob: json['vendorMob'] as String?,
      );
}
