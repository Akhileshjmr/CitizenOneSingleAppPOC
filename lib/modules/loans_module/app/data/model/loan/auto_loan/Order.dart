import 'VehicleData.dart';

class Order {
  Order({
      this.loanAppNum, 
      this.loanAmount, 
      this.status, 
      this.categoryType, 
      this.bankLogo, 
      this.bankName, 
      this.leadId, 
      this.lastMsgSendBy, 
      this.chatId, 
      this.orderId, 
      this.vehicleData,});

  Order.fromJson(dynamic json) {
    loanAppNum = json['loanAppNum'];
    loanAmount = json['loanAmount'];
    status = json['status'];
    categoryType = json['categoryType'];
    bankLogo = json['bankLogo'];
    bankName = json['bankName'];
    leadId = json['leadId'];
    lastMsgSendBy = json['lastMsgSendBy'];
    chatId = json['chatId'];
    orderId = json['orderId'];
    vehicleData = json['vehicleData'] != null ? VehicleData.fromJson(json['vehicleData']) : null;
  }
  String? loanAppNum;
  double? loanAmount;
  String? status;
  String? categoryType;
  String? bankLogo;
  String? bankName;
  int? leadId;
  dynamic lastMsgSendBy;
  dynamic chatId;
  int? orderId;
  VehicleData? vehicleData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['loanAppNum'] = loanAppNum;
    map['loanAmount'] = loanAmount;
    map['status'] = status;
    map['categoryType'] = categoryType;
    map['bankLogo'] = bankLogo;
    map['bankName'] = bankName;
    map['leadId'] = leadId;
    map['lastMsgSendBy'] = lastMsgSendBy;
    map['chatId'] = chatId;
    map['orderId'] = orderId;
    if (vehicleData != null) {
      map['vehicleData'] = vehicleData?.toJson();
    }
    return map;
  }

}