import 'package:collection/collection.dart';

import '../common/ch_message.dart';
import '../common/option.dart';
import '../common/select_option_item.dart';

class ServiceRequest {
  List<SelectOptionItem>? selectOptionList;
  ChMessage? message;

  ServiceRequest({this.selectOptionList, this.message});

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      selectOptionList:
          json["selectOptionList"] == null
              ? null
              : List<SelectOptionItem>.from(
                json["selectOptionList"].map(
                  (x) => SelectOptionItem.fromJson(x),
                ),
              ),
      message:
          json["message"] != null ? ChMessage.fromJson(json["message"]) : null,
    );
  }
}

extension ServiceRequestOptionHelper on ServiceRequest {
  List<Option> getOptions(String key) {
    return selectOptionList?.firstWhereOrNull((e) => e.key == key)?.options ??
        [];
  }
}
