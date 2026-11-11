class QuotationResponse {
  final ChMessage chMessage;
  final QuotationData data;

  QuotationResponse({required this.chMessage, required this.data});

  factory QuotationResponse.fromJson(Map<String, dynamic> json) {
    return QuotationResponse(
      chMessage: ChMessage.fromJson(json['chMessage'] as Map<String, dynamic>),
      data: QuotationData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'chMessage': chMessage.toJson(),
        'data': data.toJson(),
      };
}

class ChMessage {
  final String code;
  final String message;
  final String type;
  final String dispType;
  final bool isError;
  final String subject;
  final dynamic dataArr;

  ChMessage({
    required this.code,
    required this.message,
    required this.type,
    required this.dispType,
    required this.isError,
    required this.subject,
    this.dataArr,
  });

  factory ChMessage.fromJson(Map<String, dynamic> json) {
    return ChMessage(
      code: json['code'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      dispType: json['dispType'] as String,
      isError: json['isError'] as bool,
      subject: json['subject'] as String,
      dataArr: json['dataArr'],
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'type': type,
        'dispType': dispType,
        'isError': isError,
        'subject': subject,
        'dataArr': dataArr,
      };
}

class QuotationData {
  final List<Quotation> quotations;

  QuotationData({required this.quotations});

  factory QuotationData.fromJson(Map<String, dynamic> json) {
    return QuotationData(
      quotations: (json['quotations'] as List<dynamic>)
          .map((q) => Quotation.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'quotations': quotations.map((q) => q.toJson()).toList(),
      };
}

class Quotation {
  final String policyNumber;
  final String status;
  final DateTime approvedDate;
  final DateTime startDate;
  final DateTime endDate;
  final double extensionsPremium;
  final double discountsPremium;
  final double premiumLevy;
  final double basicPremium;
  final double grossPremium;
  final String currency;
  final int duration;
  final String durationType;
  final double limitsOfLiabilitiesPremium;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Risk> risks;
  final Client client;
  final Insurer insurer;
  final Product product;
  final List<dynamic> clauses;

  Quotation({
    required this.policyNumber,
    required this.status,
    required this.approvedDate,
    required this.startDate,
    required this.endDate,
    required this.extensionsPremium,
    required this.discountsPremium,
    required this.premiumLevy,
    required this.basicPremium,
    required this.grossPremium,
    required this.currency,
    required this.duration,
    required this.durationType,
    required this.limitsOfLiabilitiesPremium,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.risks,
    required this.client,
    required this.insurer,
    required this.product,
    required this.clauses,
  });

  factory Quotation.fromJson(Map<String, dynamic> json) {
    return Quotation(
      policyNumber: json['policyNumber'] as String,
      status: json['status'] as String,
      approvedDate: DateTime.parse(json['approvedDate'] as String),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      extensionsPremium: (json['extensionsPremium'] as num).toDouble(),
      discountsPremium: (json['discountsPremium'] as num).toDouble(),
      premiumLevy: (json['premiumLevy'] as num).toDouble(),
      basicPremium: (json['basicPremium'] as num).toDouble(),
      grossPremium: (json['grossPremium'] as num).toDouble(),
      currency: json['currency'] as String,
      duration: json['duration'] as int,
      durationType: json['durationType'] as String,
      limitsOfLiabilitiesPremium:
          (json['limitsOfLiabilitiesPremium'] as num).toDouble(),
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      risks: (json['risks'] as List<dynamic>)
          .map((r) => Risk.fromJson(r as Map<String, dynamic>))
          .toList(),
      client: Client.fromJson(json['client'] as Map<String, dynamic>),
      insurer: Insurer.fromJson(json['insurer'] as Map<String, dynamic>),
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      clauses: json['clauses'] as List<dynamic>? ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'policyNumber': policyNumber,
        'status': status,
        'approvedDate': approvedDate.toIso8601String(),
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'extensionsPremium': extensionsPremium,
        'discountsPremium': discountsPremium,
        'premiumLevy': premiumLevy,
        'basicPremium': basicPremium,
        'grossPremium': grossPremium,
        'currency': currency,
        'duration': duration,
        'durationType': durationType,
        'limitsOfLiabilitiesPremium': limitsOfLiabilitiesPremium,
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'risks': risks.map((r) => r.toJson()).toList(),
        'client': client.toJson(),
        'insurer': insurer.toJson(),
        'product': product.toJson(),
        'clauses': clauses,
      };
}

class Risk {
  final double sumInsured;
  final double premiumLevy;
  final double extensionsPremium;
  final double discountsPremium;
  final double limitsOfLiabilitiesPremium;
  final double basicPremium;
  final double grossPremium;
  final List<String> photosUrls;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Vehicle vehicle;

  Risk({
    required this.sumInsured,
    required this.premiumLevy,
    required this.extensionsPremium,
    required this.discountsPremium,
    required this.limitsOfLiabilitiesPremium,
    required this.basicPremium,
    required this.grossPremium,
    required this.photosUrls,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.vehicle,
  });

  factory Risk.fromJson(Map<String, dynamic> json) {
    return Risk(
      sumInsured: (json['sumInsured'] as num).toDouble(),
      premiumLevy: (json['premiumLevy'] as num).toDouble(),
      extensionsPremium: (json['extensionsPremium'] as num).toDouble(),
      discountsPremium: (json['discountsPremium'] as num).toDouble(),
      limitsOfLiabilitiesPremium:
          (json['limitsOfLiabilitiesPremium'] as num).toDouble(),
      basicPremium: (json['basicPremium'] as num).toDouble(),
      grossPremium: (json['grossPremium'] as num).toDouble(),
      photosUrls: (json['photosUrls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      vehicle: Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'sumInsured': sumInsured,
        'premiumLevy': premiumLevy,
        'extensionsPremium': extensionsPremium,
        'discountsPremium': discountsPremium,
        'limitsOfLiabilitiesPremium': limitsOfLiabilitiesPremium,
        'basicPremium': basicPremium,
        'grossPremium': grossPremium,
        'photosUrls': photosUrls,
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'vehicle': vehicle.toJson(),
      };
}

class Vehicle {
  final String make;
  final String model;
  final int yearOfManufacture;
  final String registrationNumber;
  final String chassisNumber;
  final String engineNumber;
  final double sumInsured;
  final String currency;
  final int capacity;
  final double? tonnage;
  final int? seatingCapacity;
  final String color;
  final String status;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vehicle({
    required this.make,
    required this.model,
    required this.yearOfManufacture,
    required this.registrationNumber,
    required this.chassisNumber,
    required this.engineNumber,
    required this.sumInsured,
    required this.currency,
    required this.capacity,
    this.tonnage,
    this.seatingCapacity,
    required this.color,
    required this.status,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      make: json['make'] as String,
      model: json['model'] as String,
      yearOfManufacture: json['yearOfManufacture'] as int,
      registrationNumber: json['registrationNumber'] as String,
      chassisNumber: json['chassisNumber'] as String,
      engineNumber: json['engineNumber'] as String,
      sumInsured: (json['sumInsured'] as num).toDouble(),
      currency: json['currency'] as String,
      capacity: json['capacity'] as int,
      tonnage:
          json['tonnage'] != null ? (json['tonnage'] as num).toDouble() : null,
      seatingCapacity: json['seatingCapacity'] as int?,
      color: json['color'] as String,
      status: json['status'] as String,
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'make': make,
        'model': model,
        'yearOfManufacture': yearOfManufacture,
        'registrationNumber': registrationNumber,
        'chassisNumber': chassisNumber,
        'engineNumber': engineNumber,
        'sumInsured': sumInsured,
        'currency': currency,
        'capacity': capacity,
        'tonnage': tonnage,
        'seatingCapacity': seatingCapacity,
        'color': color,
        'status': status,
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class Client {
  final String name;
  final String? identificationNumber;
  final String? email;
  final String? phoneNumber;
  final String? physicalAddress;
  final String type;
  final String status;
  final String? taxPayerId;
  final DateTime? dateOfBirth;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  Client({
    required this.name,
    this.identificationNumber,
    this.email,
    this.phoneNumber,
    this.physicalAddress,
    required this.type,
    required this.status,
    this.taxPayerId,
    this.dateOfBirth,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      name: json['name'] as String,
      identificationNumber: json['identificationNumber'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      physicalAddress: json['physicalAddress'] as String?,
      type: json['type'] as String,
      status: json['status'] as String,
      taxPayerId: json['taxPayerId'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'identificationNumber': identificationNumber,
        'email': email,
        'phoneNumber': phoneNumber,
        'physicalAddress': physicalAddress,
        'type': type,
        'status': status,
        'taxPayerId': taxPayerId,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class Address {
  final String country;
  final String province;
  final String district;
  final String street;
  final String plotNo;

  Address({
    required this.country,
    required this.province,
    required this.district,
    required this.street,
    required this.plotNo,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      country: json['country'] as String,
      province: json['province'] as String,
      district: json['district'] as String,
      street: json['street'] as String,
      plotNo: json['plotNo'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'country': country,
        'province': province,
        'district': district,
        'street': street,
        'plotNo': plotNo,
      };
}

class Insurer {
  final String logoUrl;
  final String insurerType;
  final String name;
  final String shortName;
  final Address address;
  final String email;
  final String status;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  Insurer({
    required this.logoUrl,
    required this.insurerType,
    required this.name,
    required this.shortName,
    required this.address,
    required this.email,
    required this.status,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Insurer.fromJson(Map<String, dynamic> json) {
    return Insurer(
      logoUrl: json['logoUrl'] as String,
      insurerType: json['insurerType'] as String,
      name: json['name'] as String,
      shortName: json['shortName'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      email: json['email'] as String,
      status: json['status'] as String,
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'logoUrl': logoUrl,
        'insurerType': insurerType,
        'name': name,
        'shortName': shortName,
        'address': address.toJson(),
        'email': email,
        'status': status,
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

class Product {
  final String name;
  final String description;
  final String code;
  final String source;
  final String? partnerId;
  final Insurer insurer;
  final dynamic classOfBusiness;
  final dynamic category;
  final dynamic productCategoryName;
  final List<String> paymentMethods;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.name,
    required this.description,
    required this.code,
    required this.source,
    this.partnerId,
    required this.insurer,
    this.classOfBusiness,
    this.category,
    this.productCategoryName,
    required this.paymentMethods,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] as String,
      description: json['description'] as String,
      code: json['code'] as String,
      source: json['source'] as String,
      partnerId: json['partnerId'] as String?,
      insurer: Insurer.fromJson(json['insurer'] as Map<String, dynamic>),
      classOfBusiness: json['classOfBusiness'],
      category: json['category'],
      productCategoryName: json['productCategoryName'],
      paymentMethods: (json['paymentMethods'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'code': code,
        'source': source,
        'partnerId': partnerId,
        'insurer': insurer.toJson(),
        'classOfBusiness': classOfBusiness,
        'category': category,
        'productCategoryName': productCategoryName,
        'paymentMethods': paymentMethods,
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
