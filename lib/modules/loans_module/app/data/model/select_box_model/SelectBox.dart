import 'Message.dart';
import 'SelectOptionList.dart';

class SelectBox {
  SelectBox({
      this.selectOptionList, 
      this.tempStr, 
      this.message, 
      this.lookUpForm,});

  SelectBox.fromJson(dynamic json) {
    if (json['selectOptionList'] != null) {
      selectOptionList = [];
      json['selectOptionList'].forEach((v) {
        selectOptionList!.add(SelectOptionList.fromJson(v));
      });
    }
    tempStr = json['tempStr'];
    message = json['message'] != null ? Message.fromJson(json['message']) : null;
    lookUpForm = json['lookUpForm'];
  }
  List<SelectOptionList>? selectOptionList;
  String? tempStr;
  Message? message;
  dynamic lookUpForm;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (selectOptionList != null) {
      map['selectOptionList'] = selectOptionList!.map((v) => v.toJson()).toList();
    }
    map['tempStr'] = tempStr;
    if (message != null) {
      map['message'] = message!.toJson();
    }
    map['lookUpForm'] = lookUpForm;
    return map;
  }

}