import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/quotation_response_model.dart';

class CreateQuotationModel {
  final ChMessage chMessage;
  final QuoteData data;

  const CreateQuotationModel({required this.chMessage, required this.data});

  factory CreateQuotationModel.fromJson(Map<String, dynamic> json) =>
      CreateQuotationModel(
        chMessage:
            ChMessage.fromJson(json['chMessage'] as Map<String, dynamic>),
        data: QuoteData.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'chMessage': chMessage.toJson(),
        'data': data.toJson(),
      };
}

class QuoteData {
  final String id;
  final String? productId;
  final String? clientId;
  final String status;
  final double totalPremium;
  final double basePremium;
  final double levies;
  final double? stampDuty;
  final String currency;
  final String? expiryDate;
  final String policyNumber;
  final String startDate;
  final String endDate;
  final String durationType;
  final int duration;
  final String approvedDate;
  final double discountsPremium;
  final double extensionsPremium;
  final double limitsOfLiabilitiesPremium;
  final List<dynamic> clauses;
  final Product product;
  final Insurer insurer;
  final Client client;
  final List<Risk> risks;
  final String createdAt;
  final String updatedAt;
  final Map<String, dynamic>? additionalProperties;
  final String referenceNumber;
  final String? transactionNumber;
  final String? hostRefNumber;
  final double gatewayCharge;
  final double platformCharge;
  final double totalPayable;
  final String? gatewayChargeType;
  final double? gatewayChargeValue;
  final String? platformChargeType;
  final double? platformChargeValue;
  final double? convenienceFee;

  const QuoteData({
    required this.id,
    this.productId,
    this.clientId,
    required this.status,
    required this.totalPremium,
    required this.basePremium,
    required this.levies,
    this.stampDuty,
    required this.currency,
    this.expiryDate,
    required this.policyNumber,
    required this.startDate,
    required this.endDate,
    required this.durationType,
    required this.duration,
    required this.approvedDate,
    required this.discountsPremium,
    required this.extensionsPremium,
    required this.limitsOfLiabilitiesPremium,
    required this.clauses,
    required this.product,
    required this.insurer,
    required this.client,
    required this.risks,
    required this.createdAt,
    required this.updatedAt,
    required this.referenceNumber,
    required this.hostRefNumber,
    required this.gatewayCharge,
    required this.platformCharge,
    required this.totalPayable,
    this.gatewayChargeValue,
    this.gatewayChargeType,
    this.platformChargeType,
    this.platformChargeValue,
    this.convenienceFee,
    this.transactionNumber,
    this.additionalProperties,
  });

  factory QuoteData.fromJson(Map<String, dynamic> json) => QuoteData(
        id: json['id'] as String,
        productId: json['productId'] as String?,
        clientId: json['clientId'] as String?,
        status: json['status'] as String,
        totalPremium: (json['totalPremium'] as num).toDouble(),
        basePremium: (json['basePremium'] as num).toDouble(),
        levies: (json['levies'] as num).toDouble(),
        stampDuty: (json['stampDuty'] as num?)?.toDouble(),
        currency: json['currency'] as String,
        expiryDate: json['expiryDate'] as String?,
        policyNumber: json['policyNumber'] as String,
        startDate: json['startDate'] as String,
        endDate: json['endDate'] as String,
        durationType: json['durationType'] as String,
        duration: json['duration'] as int,
        approvedDate: json['approvedDate'] as String,
        discountsPremium: (json['discountsPremium'] as num).toDouble(),
        extensionsPremium: (json['extensionsPremium'] as num).toDouble(),
        limitsOfLiabilitiesPremium:
            (json['limitsOfLiabilitiesPremium'] as num).toDouble(),
        clauses: json['clauses'] as List<dynamic>,
        product: Product.fromJson(json['product'] as Map<String, dynamic>),
        insurer: Insurer.fromJson(json['insurer'] as Map<String, dynamic>),
        client: Client.fromJson(json['client'] as Map<String, dynamic>),
        risks: (json['risks'] as List<dynamic>)
            .map((e) => Risk.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: json['createdAt'] as String,
        updatedAt: json['updatedAt'] as String,
        additionalProperties:
            json['additionalProperties'] as Map<String, dynamic>?,
        referenceNumber: json['referenceNumber'] as String,
        transactionNumber: json['transactionNumber'] as String?,
        hostRefNumber: json['hostRefNumber'] != null
            ? json['hostRefNumber'] as String
            : 'NA',
        gatewayCharge: (json['gatewayCharge'] as num).toDouble(),
        platformCharge: (json['platformCharge'] as num).toDouble(),
        totalPayable: (json['totalPayable'] as num).toDouble(),
        gatewayChargeType: json['gatewayChargeType'] as String?,
        gatewayChargeValue: (json['gatewayChargeValue'] as num?)?.toDouble(),
        platformChargeType: json['platformChargeType'] as String?,
        platformChargeValue: (json['platformChargeValue'] as num?)?.toDouble(),
        convenienceFee: (json['convenienceFee'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'clientId': clientId,
        'status': status,
        'totalPremium': totalPremium,
        'basePremium': basePremium,
        'levies': levies,
        'stampDuty': stampDuty,
        'currency': currency,
        'expiryDate': expiryDate,
        'policyNumber': policyNumber,
        'startDate': startDate,
        'endDate': endDate,
        'durationType': durationType,
        'duration': duration,
        'approvedDate': approvedDate,
        'discountsPremium': discountsPremium,
        'extensionsPremium': extensionsPremium,
        'limitsOfLiabilitiesPremium': limitsOfLiabilitiesPremium,
        'clauses': clauses,
        'product': product.toJson(),
        'insurer': insurer.toJson(),
        'client': client.toJson(),
        'risks': risks.map((e) => e.toJson()).toList(),
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'additionalProperties': additionalProperties,
        'referenceNumber': referenceNumber,
        'transactionNumber': transactionNumber,
        'hostRefNumber': hostRefNumber,
        'gatewayCharge': gatewayCharge,
        'platformCharge': platformCharge,
        'totalPayable': totalPayable,
        'gatewayChargeType': gatewayChargeType,
        'gatewayChargeValue': gatewayChargeValue,
        'platformChargeType': platformChargeType,
        'platformChargeValue': platformChargeValue,
        'convenienceFee': convenienceFee,
      };
}
