import 'CardImage.dart';
import 'Reasons.dart';
import 'Benefits.dart';

class CreditCardComparisionsList {
  CreditCardComparisionsList({
      this.productName, 
      this.cardBroucher, 
      this.subSegment, 
      this.shortDescription, 
      this.displayPriority, 
      this.cashAdvanceFee, 
      this.interestRate, 
      this.joiningFees, 
      this.fornCurTxnFees, 
      this.annualFeeWaiver, 
      this.latePaymentCharges, 
      this.bestSuitedFor, 
      this.brandPartners, 
      this.cardVarients, 
      this.minimumAge, 
      this.minimumIncome, 
      this.fuelSurchargeWaiver, 
      this.airportLoungeAccess, 
      this.addOnCards, 
      this.insuranceCoverage, 
      this.balanceTransfer, 
      this.cashBack, 
      this.internetBanking, 
      this.travelBenefits, 
      this.emiConversion, 
      this.shariaCompliant, 
      this.studentCard, 
      this.travelInsurance, 
      this.fuelCard, 
      this.supplementaryCard, 
      this.bankWebsiteLink, 
      this.cardImage, 
      this.cardName, 
      this.cardDesc, 
      this.minSalary, 
      this.rate, 
      this.cardCode, 
      this.annualFee, 
      this.creditCardType, 
      this.bankName, 
      this.categoryName, 
      this.recordStatus, 
      this.bankId, 
      this.cardId, 
      this.categoryId, 
      this.cardType, 
      this.reasons, 
      this.benefits, 
      this.isApplied,});

  CreditCardComparisionsList.fromJson(dynamic json) {
    productName = json['productName'];
    cardBroucher = json['cardBroucher'];
    subSegment = json['subSegment'];
    shortDescription = json['shortDescription'];
    displayPriority = json['displayPriority'];
    cashAdvanceFee = json['cashAdvanceFee'];
    interestRate = json['interestRate'];
    joiningFees = json['joiningFees'];
    fornCurTxnFees = json['fornCurTxnFees'];
    annualFeeWaiver = json['annualFeeWaiver'];
    latePaymentCharges = json['latePaymentCharges'];
    bestSuitedFor = json['bestSuitedFor'];
    brandPartners = json['brandPartners'];
    cardVarients = json['cardVarients'];
    minimumAge = json['minimumAge'];
    minimumIncome = json['minimumIncome'];
    fuelSurchargeWaiver = json['fuelSurchargeWaiver'];
    airportLoungeAccess = json['airportLoungeAccess'];
    addOnCards = json['addOnCards'];
    insuranceCoverage = json['insuranceCoverage'];
    balanceTransfer = json['balanceTransfer'];
    cashBack = json['cashBack'];
    internetBanking = json['internetBanking'];
    travelBenefits = json['travelBenefits'];
    emiConversion = json['emiConversion'];
    shariaCompliant = json['shariaCompliant'];
    studentCard = json['studentCard'];
    travelInsurance = json['travelInsurance'];
    fuelCard = json['fuelCard'];
    supplementaryCard = json['supplementaryCard'];
    bankWebsiteLink = json['bankWebsiteLink'];
    cardImage = json['cardImage'] != null ? CardImage.fromJson(json['cardImage']) : null;
    cardName = json['cardName'];
    cardDesc = json['cardDesc'];
    minSalary = json['minSalary'];
    rate = json['rate'];
    cardCode = json['cardCode'];
    annualFee = json['annualFee'];
    creditCardType = json['creditCardType'];
    bankName = json['bankName'];
    categoryName = json['categoryName'];
    recordStatus = json['recordStatus'];
    bankId = json['bankId'];
    cardId = json['cardId'];
    categoryId = json['categoryId'];
    cardType = json['cardType'];
    reasons = json['reasons'] != null ? Reasons.fromJson(json['reasons']) : null;
    benefits = json['benefits'] != null ? Benefits.fromJson(json['benefits']) : null;
    isApplied = json['isApplied'];
  }
  dynamic productName;
  dynamic cardBroucher;
  String? subSegment;
  String? shortDescription;
  int? displayPriority;
  String? cashAdvanceFee;
  String? interestRate;
  String? joiningFees;
  dynamic fornCurTxnFees;
  dynamic annualFeeWaiver;
  String? latePaymentCharges;
  dynamic bestSuitedFor;
  dynamic brandPartners;
  dynamic cardVarients;
  String? minimumAge;
  double? minimumIncome;
  bool? fuelSurchargeWaiver;
  bool? airportLoungeAccess;
  bool? addOnCards;
  bool? insuranceCoverage;
  bool? balanceTransfer;
  bool? cashBack;
  bool? internetBanking;
  bool? travelBenefits;
  bool? emiConversion;
  bool? shariaCompliant;
  bool? studentCard;
  bool? travelInsurance;
  bool? fuelCard;
  bool? supplementaryCard;
  dynamic bankWebsiteLink;
  CardImage? cardImage;
  String? cardName;
  String? cardDesc;
  dynamic minSalary;
  dynamic rate;
  String? cardCode;
  String? annualFee;
  String? creditCardType;
  String? bankName;
  String? categoryName;
  dynamic recordStatus;
  int? bankId;
  int? cardId;
  int? categoryId;
  dynamic cardType;
  Reasons? reasons;
  Benefits? benefits;
  bool? isApplied;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['productName'] = productName;
    map['cardBroucher'] = cardBroucher;
    map['subSegment'] = subSegment;
    map['shortDescription'] = shortDescription;
    map['displayPriority'] = displayPriority;
    map['cashAdvanceFee'] = cashAdvanceFee;
    map['interestRate'] = interestRate;
    map['joiningFees'] = joiningFees;
    map['fornCurTxnFees'] = fornCurTxnFees;
    map['annualFeeWaiver'] = annualFeeWaiver;
    map['latePaymentCharges'] = latePaymentCharges;
    map['bestSuitedFor'] = bestSuitedFor;
    map['brandPartners'] = brandPartners;
    map['cardVarients'] = cardVarients;
    map['minimumAge'] = minimumAge;
    map['minimumIncome'] = minimumIncome;
    map['fuelSurchargeWaiver'] = fuelSurchargeWaiver;
    map['airportLoungeAccess'] = airportLoungeAccess;
    map['addOnCards'] = addOnCards;
    map['insuranceCoverage'] = insuranceCoverage;
    map['balanceTransfer'] = balanceTransfer;
    map['cashBack'] = cashBack;
    map['internetBanking'] = internetBanking;
    map['travelBenefits'] = travelBenefits;
    map['emiConversion'] = emiConversion;
    map['shariaCompliant'] = shariaCompliant;
    map['studentCard'] = studentCard;
    map['travelInsurance'] = travelInsurance;
    map['fuelCard'] = fuelCard;
    map['supplementaryCard'] = supplementaryCard;
    map['bankWebsiteLink'] = bankWebsiteLink;
    if (cardImage != null) {
      map['cardImage'] = cardImage?.toJson();
    }
    map['cardName'] = cardName;
    map['cardDesc'] = cardDesc;
    map['minSalary'] = minSalary;
    map['rate'] = rate;
    map['cardCode'] = cardCode;
    map['annualFee'] = annualFee;
    map['creditCardType'] = creditCardType;
    map['bankName'] = bankName;
    map['categoryName'] = categoryName;
    map['recordStatus'] = recordStatus;
    map['bankId'] = bankId;
    map['cardId'] = cardId;
    map['categoryId'] = categoryId;
    map['cardType'] = cardType;
    if (reasons != null) {
      map['reasons'] = reasons?.toJson();
    }
    if (benefits != null) {
      map['benefits'] = benefits?.toJson();
    }
    map['isApplied'] = isApplied;
    return map;
  }

}