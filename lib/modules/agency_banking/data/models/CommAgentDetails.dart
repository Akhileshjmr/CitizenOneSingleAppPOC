import 'common_models/HeaderInfo.dart';
import 'common_models/ServerMessage.dart';

class CommAgentDetails {
  HeaderInfo headerInfo;
  ServerMessage resMessage;
  String? agencyCode;
  String? agencyName;
  String? agentCode;
  String? agentName;
  String? agentType;
  String? gender;
  DateTime? dob;
  String? email;
  String? phNo;
  String? branchCode;
  String? branchName;
  String? accNo;
  String? accType;
  String? address;
  String? country;
  String? region;
  String? city;
  double dailyCommAmount;
  double monthlyCommAmount;
  double yearlyCommAmount;
  String? userpin;

  // Constructor
  CommAgentDetails({
    required this.headerInfo,
    required this.resMessage,
    this.agencyCode,
    this.agencyName,
    this.agentCode,
    this.agentName,
    this.agentType,
    this.gender,
    this.dob,
    this.email,
    this.phNo,
    this.branchCode,
    this.branchName,
    this.accNo,
    this.accType,
    this.address,
    this.country,
    this.region,
    this.city,
    this.dailyCommAmount = 0.0,
    this.monthlyCommAmount = 0.0,
    this.yearlyCommAmount = 0.0,
    this.userpin,
  });

  // From JSON factory method
  factory CommAgentDetails.fromJson(Map<String, dynamic> json) {
    return CommAgentDetails(
      headerInfo: HeaderInfo.fromJson(json['headerInfo']),
      resMessage: ServerMessage.fromJson(json['resMessage']),
      agencyCode: json['agencyCode'],
      agencyName: json['agencyName'],
      agentCode: json['agentCode'],
      agentName: json['agentName'],
      agentType: json['agentType'],
      gender: json['gender'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      email: json['email'],
      phNo: json['phNo'],
      branchCode: json['branchCode'],
      branchName: json['branchName'],
      accNo: json['accNo'],
      accType: json['accType'],
      address: json['address'],
      country: json['country'],
      region: json['region'],
      city: json['city'],
      dailyCommAmount: (json['dailyCommAmount'] ?? 0).toDouble(),
      monthlyCommAmount: (json['monthlyCommAmount'] ?? 0).toDouble(),
      yearlyCommAmount: (json['yearlyCommAmount'] ?? 0).toDouble(),
      userpin: json['userpin'],
    );
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'headerInfo': headerInfo.toJson(),
      'resMessage': resMessage.toJson(),
      'agencyCode': agencyCode,
      'agencyName': agencyName,
      'agentCode': agentCode,
      'agentName': agentName,
      'agentType': agentType,
      'gender': gender,
      'dob': dob?.toIso8601String(),
      'email': email,
      'phNo': phNo,
      'branchCode': branchCode,
      'branchName': branchName,
      'accNo': accNo,
      'accType': accType,
      'address': address,
      'country': country,
      'region': region,
      'city': city,
      'dailyCommAmount': dailyCommAmount,
      'monthlyCommAmount': monthlyCommAmount,
      'yearlyCommAmount': yearlyCommAmount,
      'userpin': userpin,
    };
  }
}
