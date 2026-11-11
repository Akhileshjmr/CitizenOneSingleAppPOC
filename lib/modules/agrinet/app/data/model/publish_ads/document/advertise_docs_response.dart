import 'package:citizenone_app/modules/agrinet/app/data/model/common/ch_message.dart';

import 'advertise_docs.dart';

class AdvertiseDocsResponse {
  AdvertiseDocs? advertiseDocs;
  ChMessage? message;

  AdvertiseDocsResponse({this.advertiseDocs, this.message});

  AdvertiseDocsResponse.fromJson(Map<String, dynamic> json) {
    advertiseDocs =
        json['advertiseDocs'] != null
            ? AdvertiseDocs.fromJson(json['advertiseDocs'])
            : null;
    message =
        json['message'] != null ? ChMessage.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (advertiseDocs != null) {
      data['advertiseDocs'] = advertiseDocs!.toJson();
    }
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}
