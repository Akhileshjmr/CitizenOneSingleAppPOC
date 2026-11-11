import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/insurance_transaction_entity.dart';

class InsuranceTransactionListResponseModel {
  final ChMessageModel? chMessage;
  final TransactionPageDataModel? data;

  InsuranceTransactionListResponseModel({
    this.chMessage,
    this.data,
  });

  factory InsuranceTransactionListResponseModel.fromJson(
      Map<String, dynamic> json) {
    return InsuranceTransactionListResponseModel(
      chMessage: json['chMessage'] != null
          ? ChMessageModel.fromJson(
              json['chMessage'] as Map<String, dynamic>,
            )
          : null,
      data: json['data'] != null
          ? TransactionPageDataModel.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class TransactionPageDataModel {
  final List<TransactionModel> content;
  final PageableModel? pageable;
  final int totalElements;
  final int totalPages;
  final bool last;
  final bool first;
  final int size;
  final int number; // current page (0-indexed)
  final int numberOfElements;
  final bool empty;

  TransactionPageDataModel({
    required this.content,
    this.pageable,
    required this.totalElements,
    required this.totalPages,
    required this.last,
    required this.first,
    required this.size,
    required this.number,
    required this.numberOfElements,
    required this.empty,
  });

  factory TransactionPageDataModel.fromJson(Map<String, dynamic> json) {
    return TransactionPageDataModel(
      content: (json['content'] as List<dynamic>? ?? [])
          .map(
            (e) => TransactionModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      pageable: json['pageable'] != null
          ? PageableModel.fromJson(
              json['pageable'] as Map<String, dynamic>,
            )
          : null,
      totalElements: (json['totalElements'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      last: json['last'] as bool? ?? true,
      first: json['first'] as bool? ?? true,
      size: (json['size'] as num?)?.toInt() ?? 20,
      number: (json['number'] as num?)?.toInt() ?? 0,
      numberOfElements: (json['numberOfElements'] as num?)?.toInt() ?? 0,
      empty: json['empty'] as bool? ?? true,
    );
  }
  InsuranceTransactionListEntity toEntity() {
    return InsuranceTransactionListEntity(
      transactions: content.map((e) => e.toEntity()).toList(),
      currentPage: number,
      totalPages: totalPages,
      totalElements: totalElements,
      isLastPage: last,
    );
  }
}

class PageableModel {
  final int offset;
  final int pageNumber;
  final int pageSize;
  final bool paged;
  final bool unpaged;

  PageableModel({
    required this.offset,
    required this.pageNumber,
    required this.pageSize,
    required this.paged,
    required this.unpaged,
  });

  factory PageableModel.fromJson(Map<String, dynamic> json) {
    return PageableModel(
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      pageNumber: (json['pageNumber'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
      paged: json['paged'] as bool? ?? true,
      unpaged: json['unpaged'] as bool? ?? false,
    );
  }
}

class TransactionModel {
  final String txnNumber;
  final String? category;
  final String? vendorCode;
  final String? agentCode;
  final String? agentMobile;
  final String? customerId;
  final String? customerName;
  final String? customerPhone;
  final String? customerEmail;
  final String? customerIdNumber;
  final String? customerIdType;
  final String? customerState;
  final String? vehicleId;
  final String? vehicleRegNo;
  final String? vehicleMake;
  final String? vehicleModel;
  final int? vehicleYear;
  final String? quotationId;
  final String? productId;
  final double? quotationPremium;
  final String? quotationStatus;
  final String? paymentReference;
  final String? paymentTxnId;
  final String? paymentMethod;
  final String? paymentGateway;
  final String? paymentStatus;
  final double? paymentAmount;
  final String? paymentMobileAcct;
  final String? policyId;
  final String? policyNumber;
  final String? policyStatus;
  final DateTime? policyStartDate;
  final DateTime? policyEndDate;
  final double? policyGrossPremium;
  final double? policyBasicPremium;
  final String transactionStatus;
  final String transactionStatusLabel;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? referenceNumber;
  final String? hostRefNumber;

  TransactionModel(
      {required this.txnNumber,
      this.category,
      this.vendorCode,
      this.agentCode,
      this.agentMobile,
      this.customerId,
      this.customerName,
      this.customerPhone,
      this.customerEmail,
      this.customerIdNumber,
      this.customerIdType,
      this.customerState,
      this.vehicleId,
      this.vehicleRegNo,
      this.vehicleMake,
      this.vehicleModel,
      this.vehicleYear,
      this.quotationId,
      this.productId,
      this.quotationPremium,
      this.quotationStatus,
      this.paymentReference,
      this.paymentTxnId,
      this.paymentMethod,
      this.paymentGateway,
      this.paymentStatus,
      this.paymentAmount,
      this.paymentMobileAcct,
      this.policyId,
      this.policyNumber,
      this.policyStatus,
      this.policyStartDate,
      this.policyEndDate,
      this.policyGrossPremium,
      this.policyBasicPremium,
      required this.transactionStatus,
      required this.transactionStatusLabel,
      this.createdAt,
      this.updatedAt,
      this.referenceNumber,
      this.hostRefNumber});

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    double? _toDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    int? _toInt(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString());
    }

    DateTime? _toDate(dynamic value) {
      if (value == null) return null;
      if (value is String && value.isNotEmpty) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return TransactionModel(
      txnNumber: json['txnNumber'] as String? ?? '',
      category: json['category'] as String?,
      vendorCode: json['vendorCode'] as String?,
      agentCode: json['agentCode'] as String?,
      agentMobile: json['agentMobile'] as String?,
      customerId: json['customerId'] as String?,
      customerName: json['customerName'] as String?,
      customerPhone: json['customerPhone'] as String?,
      customerEmail: json['customerEmail'] as String?,
      customerIdNumber: json['customerIdNumber'] as String?,
      customerIdType: json['customerIdType'] as String?,
      customerState: json['customerState'] as String?,
      vehicleId: json['vehicleId'] as String?,
      vehicleRegNo: json['vehicleRegNo'] as String?,
      vehicleMake: json['vehicleMake'] as String?,
      vehicleModel: json['vehicleModel'] as String?,
      vehicleYear: _toInt(json['vehicleYear']),
      quotationId: json['quotationId'] as String?,
      productId: json['productId'] as String?,
      quotationPremium: _toDouble(json['quotationPremium']),
      quotationStatus: json['quotationStatus'] as String?,
      paymentReference: json['paymentReference'] as String?,
      paymentTxnId: json['paymentTxnId'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      paymentGateway: json['paymentGateway'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      paymentAmount: _toDouble(json['paymentAmount']),
      paymentMobileAcct: json['paymentMobileAcct'] as String?,
      policyId: json['policyId'] as String?,
      policyNumber: json['policyNumber'] as String?,
      policyStatus: json['policyStatus'] as String?,
      policyStartDate: _toDate(json['policyStartDate']),
      policyEndDate: _toDate(json['policyEndDate']),
      policyGrossPremium: _toDouble(json['policyGrossPremium']),
      policyBasicPremium: _toDouble(json['policyBasicPremium']),
      transactionStatus: json['transactionStatus'] as String? ?? '',
      transactionStatusLabel: json['transactionStatusLabel'] as String? ?? '',
      createdAt: _toDate(json['createdAt']),
      updatedAt: _toDate(json['updatedAt']),
      referenceNumber: json['referenceNumber'] as String?,
      hostRefNumber: json['hostRefNumber'] != null
          ? json['hostRefNumber'] as String
          : 'NA',
    );
  }
  InsuranceTransactionEntity toEntity() {
    return InsuranceTransactionEntity(
      policyId: policyId ?? '',
      txnNumber: txnNumber,
      category: category ?? '',
      customerName: customerName ?? '',
      customerPhone: customerPhone ?? '',
      vehicleRegNo: policyId,
      policyNumber: policyNumber,
      policyGrossPremium: policyGrossPremium,
      transactionStatus: transactionStatus,
      transactionStatusLabel: transactionStatusLabel,
      createdAt: createdAt,
      referenceNumber: referenceNumber,
      hostReferenceNumber: hostRefNumber,
    );
  }
}

class ChMessageModel {
  final String? code;
  final String? message;
  final String? type;
  final String? dispType;
  final bool? isError;
  final String? subject;

  ChMessageModel({
    this.code,
    this.message,
    this.type,
    this.dispType,
    this.isError,
    this.subject,
  });

  factory ChMessageModel.fromJson(Map<String, dynamic> json) {
    return ChMessageModel(
      code: json['code'] as String?,
      message: json['message'] as String?,
      type: json['type'] as String?,
      dispType: json['dispType'] as String?,
      isError: json['isError'] as bool?,
      subject: json['subject'] as String?,
    );
  }
}
